import 'package:flutter/material.dart';

class BuildAfterPreviousBuildOrLayout extends StatelessWidget {
  final Widget child;

  const BuildAfterPreviousBuildOrLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (_, __) => child);
}
