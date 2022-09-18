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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Text('$index')),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _kLongText * 5,
              style: const TextStyle(fontSize: 3),
            ),
          ),
        ],
      ),
    );
  }
}

// standard long text
const _kLongText =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore '
    'et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
    'commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
    'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id '
    'est laborum.';
