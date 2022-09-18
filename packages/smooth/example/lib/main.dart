import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smooth/smooth.dart';

void main() {
  debugPrintBeginFrameBanner = debugPrintEndFrameBanner = true;
  SmoothWidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Smooth example')),
        body: Builder(
          builder: (context) => ListView(
            children: [
              for (final enableSmooth in [false, true])
                ListTile(
                  onTap: () => Navigator.push<dynamic>(
                      context, MaterialPageRoute<dynamic>(builder: (_) => ExamplePage(enableSmooth: enableSmooth))),
                  title: Text(enableSmooth ? 'Smooth' : 'Jank'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  final bool enableSmooth;

  const ExamplePage({super.key, required this.enableSmooth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(enableSmooth ? 'Smooth' : 'Jank'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemBuilder: _buildItem,
          ),
          const Center(
            child: IgnorePointer(
              child: _ExampleAnimation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return _maybeWrapSmooth(
      index: index,
      child: _ExampleItemWidget(
        key: ValueKey('item-$index'),
        index: index,
      ),
    );
  }

  Widget _maybeWrapSmooth({required int index, required Widget child}) {
    return enableSmooth
        ? Smooth(
            debugName: 'item-$index',
            emptyPlaceholder: const SizedBox(height: 24),
            child: child,
          )
        : child;
  }
}

class _ExampleAnimation extends StatefulWidget {
  const _ExampleAnimation();

  @override
  State<_ExampleAnimation> createState() => _ExampleAnimationState();
}

class _ExampleAnimationState extends State<_ExampleAnimation> with TickerProviderStateMixin {
  late final _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)..repeat();
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(size: 150.0),
      ),
    );
  }
}

class _ExampleItemWidget extends StatelessWidget {
  final int index;

  const _ExampleItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // mimic the official test, with heavier content, to mimic heavy build & layout in real world
    // https://github.com/flutter/flutter/blob/master/dev/benchmarks/macrobenchmarks/lib/src/list_text_layout.dart
    return SizedBox(
      height: 24,
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: SizedBox(
          width: 16,
          height: 16,
          child: CircleAvatar(
            child: Text('G$index'),
          ),
        ),
        title: Text(
          'Foo contact from $index-th local contact' * 5,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 5),
        ),
        subtitle: Text('+91 88888 8800$index'),
      ),
    );
  }
}
