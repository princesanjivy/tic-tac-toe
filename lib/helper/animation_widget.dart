import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AnimationOnWidget extends StatefulWidget {
  final Widget child;
  final int? msDelay;
  final bool useIncomingEffect, hasRestEffect;
  final bool? doStateChange;
  final WidgetTransitionEffects? incomingEffect;

  const AnimationOnWidget({
    super.key,
    required this.child,
    this.msDelay,
    this.useIncomingEffect = false,
    this.hasRestEffect = false,
    this.doStateChange = false,
    this.incomingEffect,
  });

  @override
  State<AnimationOnWidget> createState() => _AnimationOnWidgetState();
}

class _AnimationOnWidgetState extends State<AnimationOnWidget> {
  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
      incomingEffect: widget.useIncomingEffect
          ? widget.incomingEffect
          : WidgetTransitionEffects.incomingScaleUp(
              delay: Duration(milliseconds: widget.msDelay!),
              curve: Curves.easeInOut,
            ),
      atRestEffect: widget.hasRestEffect ? WidgetRestingEffects.wave() : null,
      doStateChange: widget.doStateChange,
      child: widget.child,
    );
  }
}
