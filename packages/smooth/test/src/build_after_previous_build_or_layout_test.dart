import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth/src/build_after_previous_build_or_layout.dart';

void main() {
  group('BuildAfterPreviousLayout should build after previous layout or build', () {
    Future<void> _body(
      WidgetTester tester,
      Widget Function({required VoidCallback onPrevious, required VoidCallback onSelfBuild}) buildWidget,
    ) async {
      var previousLayoutCalled = false, selfBuildCalled = false;

      await tester.pumpWidget(buildWidget(
        onPrevious: () {
          expect(previousLayoutCalled, false);
          expect(selfBuildCalled, false);
          previousLayoutCalled = true;
        },
        onSelfBuild: () {
          expect(previousLayoutCalled, true, reason: 'when self build, should already previous layout');
          expect(selfBuildCalled, false);
          selfBuildCalled = true;
        },
      ));

      expect(previousLayoutCalled, true);
      expect(selfBuildCalled, true);
    }

    for (final layoutOrBuild in _LayoutOrBuild.values) {
      group('consider ${layoutOrBuild.name}', () {
        Widget _buildPreviousWidget(VoidCallback onPrevious) {
          switch (layoutOrBuild) {
            case _LayoutOrBuild.layout:
              return _RecordLayoutWidget(onLayout: onPrevious);
            case _LayoutOrBuild.build:
              return _RecordBuildWidget(onBuild: onPrevious);
          }
        }

        testWidgets('when previous is simple widget', (tester) async {
          await _body(
            tester,
            ({required onPrevious, required onSelfBuild}) => Column(
              children: [
                _buildPreviousWidget(onPrevious),
                BuildAfterPreviousBuildOrLayout(child: _RecordBuildWidget(onBuild: onSelfBuild)),
              ],
            ),
          );
        });

        testWidgets('when previous is wrapped within LayoutBuilder', (tester) async {
          await _body(
            tester,
            ({required onPrevious, required onSelfBuild}) => Column(
              children: [
                LayoutBuilder(builder: (_, __) => _buildPreviousWidget(onPrevious)),
                BuildAfterPreviousBuildOrLayout(child: _RecordBuildWidget(onBuild: onSelfBuild)),
              ],
            ),
          );
        });
      });
    }
  });
}

enum _LayoutOrBuild { layout, build }

class _RecordLayoutWidget extends SingleChildRenderObjectWidget {
  final VoidCallback onLayout;

  const _RecordLayoutWidget({required this.onLayout});

  @override
  _RenderRecordLayout createRenderObject(BuildContext context) => _RenderRecordLayout(onLayout: onLayout);

  @override
  void updateRenderObject(BuildContext context, _RenderRecordLayout renderObject) => renderObject.onLayout = onLayout;
}

class _RenderRecordLayout extends RenderProxyBox {
  _RenderRecordLayout({RenderBox? child, required this.onLayout}) : super(child);

  VoidCallback onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout();
  }
}

class _RecordBuildWidget extends StatelessWidget {
  final VoidCallback onBuild;

  const _RecordBuildWidget({required this.onBuild});

  @override
  Widget build(BuildContext context) {
    onBuild();
    return Container();
  }
}
