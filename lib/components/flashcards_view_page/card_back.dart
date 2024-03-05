import 'dart:math';

import 'package:flashcard_quiz_game/animations/slide_animation.dart';
import 'package:flashcard_quiz_game/enums/slide_direction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../animations/half_flip_animation.dart';
import '../../notifiers/flashcards_notifier.dart';

class CardBack extends StatelessWidget {
  const CardBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        // THE FLASHCARD
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 100) {
            // print('swiped right');
            notifier.runSwipeCard2(
                direction: SlideDirection
                    .leftAway); // because the card has been flipped the offset is reversed, swiping left would make the card go right
            notifier.runSwipeCard1();
            notifier.setIgnoreTouch(ignore: true);
            notifier.generateCurrentQuestion();
          }
          if (details.primaryVelocity! < -100) {
            // print('swiped left');
            notifier.runSwipeCard2(direction: SlideDirection.rightAway);
            notifier.runSwipeCard1();
            notifier.setIgnoreTouch(ignore: true);
            notifier.generateCurrentQuestion();
          }
        },
        // onTap: () {
        //   notifier.runFlipCard2();
        // },
        child: HalfFlipAnimation(
          animate: notifier.flipCard2,
          reset: notifier.resetFlipCard2,
          flipFromHalfWay: true,
          animationCompleted: () {
            notifier.setIgnoreTouch(ignore: false);
          },
          child: SlideAnimation(
            animationCompleted: () {
              notifier.resetCard2();
            },
            reset: notifier.resetSwipeCard2,
            animate: notifier.swipeCard2,
            direction: notifier.swipedDirection,
            child: Center(
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(
                        pi), // rotate the Answer text since its backwards because of the flip
                    child: Center(
                      child: Text(
                        notifier.answer.answer,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
