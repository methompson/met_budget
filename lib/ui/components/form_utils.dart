import 'package:flutter/material.dart';

class FieldMargin extends StatelessWidget {
  final Widget child;
  final double horizontal;
  final double vertical;

  const FieldMargin(
    this.child, {
    double? horizontal,
    double? vertical,
  })  : horizontal = horizontal ?? 20,
        vertical = vertical ?? 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: child,
    );
  }
}
