
import 'package:flashcard_quiz_game/notifiers/flashcards_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardsViewPage extends StatefulWidget {
  const FlashcardsViewPage({super.key});

  @override
  State<FlashcardsViewPage> createState() => _FlashcardsViewPageState();
}

class _FlashcardsViewPageState extends State<FlashcardsViewPage> {

  @override
  Widget build(BuildContext context) {
    // Consumer runs the builder to update the UI, based on value changes in the provider object (FlashcardNotifier)
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => Scaffold(
        appBar: AppBar(
          title: Text(notifier.topic),
        ),
      ),
    );
  }
}
