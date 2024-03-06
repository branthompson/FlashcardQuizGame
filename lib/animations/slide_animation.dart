
import 'package:flashcard_quiz_game/configs/constants.dart';
import 'package:flutter/material.dart';
import '../enums/slide_direction.dart';

class SlideAnimation extends StatefulWidget {
  const SlideAnimation({required this.child,
    required this.direction,
    this.animate = true,
    this.reset,
    this.animationCompleted,
    super.key,
    this.animationDuration = kSlideAwayDuration,
    this.animationDelay = 0,
  });

  final Widget child;
  final SlideDirection direction;
  final bool animate;
  final bool? reset;
  final VoidCallback? animationCompleted;
  final int animationDuration;
  final int animationDelay;

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation> with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;


  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration),
        vsync: this)..addListener(() {
          if(_animationController.isCompleted){
            widget.animationCompleted?.call();
          }
    });

    // if(widget.animate){
    //   _animationController.forward();
    // }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SlideAnimation oldWidget) {

    if(widget.reset == true){
      _animationController.reset();
    }

    if(widget.animate){
      if(widget.animationDelay > 0){
        Future.delayed(Duration(milliseconds: widget.animationDelay), () {
          if(mounted) {
            _animationController.forward();
          }
        });
      }
      else{
        _animationController.forward();
      }

    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    late final Animation<Offset> _animation;

    Tween<Offset> tween;

    switch(widget.direction) {
      case SlideDirection.leftAway:
        tween = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0)); // push to the left
        break;
      case SlideDirection.rightAway:
        tween = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(1, 0)); // push to the right
        break;
      case SlideDirection.leftIn:
        tween = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)); // come into the center from the left
        break;
      case SlideDirection.rightIn:
      tween = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)); // come into the center from the right
      break;
      case SlideDirection.upIn:
        tween = Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)); // come into the center from the up
        break;
      case SlideDirection.none:
        tween = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0)); // do nothing
        break;
    }

    _animation = tween.animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    return SlideTransition(position: _animation,
      child: widget.child,
    );
  }
}
