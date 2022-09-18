import 'package:flutter/material.dart';

/// [child]'s `build` will only be called after previous subtrees has finished both build *and layout* phase
class BuildAfterPreviousBuildOrLayout extends StatelessWidget {
  final Widget child;

  const BuildAfterPreviousBuildOrLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (_, __) => child);
}
