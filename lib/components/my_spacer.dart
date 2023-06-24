import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double space;

  const VerticalSpacer(this.space, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space,
    );
  }
}

class HorizontalSpacer extends StatelessWidget {
  final double space;

  const HorizontalSpacer(this.space, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space,
    );
  }
}