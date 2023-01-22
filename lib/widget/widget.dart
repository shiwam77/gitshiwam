import 'package:flutter/material.dart';


Duration defaultAnimDuration = const Duration(milliseconds: 250);
Duration transitionAnimDuration = const Duration(milliseconds: 500);
BorderRadius smallBorderRadius = BorderRadius.circular(5.0);
BorderRadius medBorderRadius = BorderRadius.circular(10.0);
BorderRadius bigBorderRadius = BorderRadius.circular(15.0);

class ScaleExpandedSection extends StatefulWidget {
  const ScaleExpandedSection(
      {this.expand = true,
        this.child,
        this.animationCurve,
        this.duration,
        Key? key})
      : super(key: key);
  final Widget? child;
  final bool expand;
  final Curve? animationCurve;
  final Duration? duration;

  @override
  _ScaleExpandedSectionState createState() => _ScaleExpandedSectionState();
}

class _ScaleExpandedSectionState extends State<ScaleExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  //Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration:
        widget.duration ?? transitionAnimDuration);
    animation = CurvedAnimation(
      parent: expandController,
      curve: widget.animationCurve ?? Curves.fastOutSlowIn,
    );
    if (widget.expand) {
      _runExpandCheck();
    }
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ScaleExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: widget.child,
    );
  }
}


class SizeExpandedSection extends StatefulWidget {
  const SizeExpandedSection(
      {this.expand = true,
        this.child,
        this.axisAlignment = 1.0,
        this.axis = Axis.vertical,
        this.duration,
        this.animationCurve,
        Key? key})
      : super(key: key);
  final Widget? child;
  final bool? expand;
  final Axis axis;
  final double axisAlignment;
  final Curve? animationCurve;
  final Duration? duration;

  @override
  _SizeExpandedSectionState createState() => _SizeExpandedSectionState();
}

class _SizeExpandedSectionState extends State<SizeExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: widget.duration ?? transitionAnimDuration);
    animation = CurvedAnimation(
      parent: expandController,
      curve: widget.animationCurve ?? Curves.fastOutSlowIn,
    );
    if (widget.expand!) {
      _runExpandCheck();
    }
  }

  void _runExpandCheck() {
    if (widget.expand!) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(SizeExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: widget.axisAlignment,
      sizeFactor: animation,
      axis: widget.axis,
      child: widget.child,
    );
  }
}



