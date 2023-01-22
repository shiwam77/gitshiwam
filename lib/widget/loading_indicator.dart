import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    Key? key,
    this.color,
    this.size = 25.0,
  }) : super(key: key);

  final Color? color;
  final double size;

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000)))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation = Tween(begin: 0.0, end: 4.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()..rotateZ((_animation.value) * math.pi),
        alignment: FractionalOffset.center,
        child: SizedBox(
            height: widget.size,
            width: widget.size,
            child: const Icon(
              Octicons.mark_github,
            )),
      ),
    );
  }
}

