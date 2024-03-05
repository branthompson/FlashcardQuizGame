
import 'package:flashcard_quiz_game/animations/half_flip_animation.dart';
import 'package:flashcard_quiz_game/components/flashcards_view_page/card_back.dart';
import 'package:flashcard_quiz_game/notifiers/flashcards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/app/custom_appbar.dart';
import '../components/flashcards_view_page/card_front.dart';

class FlashcardsViewPage extends StatefulWidget {
  const FlashcardsViewPage({super.key});

  @override
  State<FlashcardsViewPage> createState() => _FlashcardsViewPageState();
}

class _FlashcardsViewPageState extends State<FlashcardsViewPage> {


  @override
  void initState() {
    // Using WidgetsBinding so it does not throw exception with provider package
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final flashcardsNotifier = Provider.of<FlashcardsNotifier>(context, listen: false);
      Provider.of<FlashcardsNotifier>(context, listen: false).runSwipeCard1();
      flashcardsNotifier.generateAllSelectedQuestions(); // when session starts generate all question
      flashcardsNotifier.generateCurrentQuestion(); // then generate a first question (random)
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // Consumer runs the builder to update the UI, based on value changes in the provider object (FlashcardNotifier)
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
            child: CustomAppBar()),
        body: IgnorePointer(
          ignoring: notifier.ignoreTouches,
          child: Stack(
            children: [
              CardBack(),
              CardFront(),
            ],
          ),
        ), // Front of Flashcard
      ),
    );
  }
}




