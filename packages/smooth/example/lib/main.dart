import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Smooth example')),
        body: ListView(
          children: [
            for (final enableSmooth in [false, true])
              ListTile(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute<dynamic>(builder: (_) => ExamplePage(enableSmooth: enableSmooth))),
                title: Text(enableSmooth ? 'Smooth' : 'Jank'),
              ),
          ],
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
    return TODO;
  }
}
