
import 'package:flashcard_quiz_game/animations/slide_animation.dart';
import 'package:flashcard_quiz_game/enums/slide_direction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../animations/half_flip_animation.dart';
import '../../notifiers/flashcards_notifier.dart';

class CardFront extends StatelessWidget {
  const CardFront({
    super.key, required String question,
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(  // THE FLASHCARD
        onTap: () {
          notifier.runFlipCard1();
          notifier.setIgnoreTouch(ignore: true);
        },
        child: HalfFlipAnimation(
          animate: notifier.flipCard1,
          reset: notifier.resetFlipCard1,
          flipFromHalfWay: false,
          animationCompleted: () {
            notifier.resetCard1();
            notifier.runFlipCard2();
          },
          child: SlideAnimation(
            animationDuration: 900,
            animationDelay: 200,
            animationCompleted: (){
              notifier.setIgnoreTouch(ignore: (false));
            },
            reset: notifier.resetSwipeCard1,
            animate: notifier.swipeCard1,
            direction: SlideDirection.upIn,
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
                child: Center(
                  child: Text(notifier.question.question,
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
    );
  }
}