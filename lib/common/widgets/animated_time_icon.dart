import 'package:flutter/material.dart';

class AnimatedTimerIcon extends StatefulWidget {
  const AnimatedTimerIcon({super.key});

  @override
  State<AnimatedTimerIcon> createState() => _AnimatedTimerIconState();
}

class _AnimatedTimerIconState extends State<AnimatedTimerIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: const Icon(Icons.timer_outlined),
    );
  }
}
