import 'package:flutter/material.dart';
import 'package:flashcard_quiz_game/components/flashcards_view_page/card_front.dart';
import 'package:flashcard_quiz_game/components/flashcards_view_page/card_back.dart';
import 'package:flashcard_quiz_game/models/question.dart';

class Flashcard extends StatefulWidget {
  final Question question;
  final VoidCallback onFlip;

  const Flashcard({Key? key, required this.question, required this.onFlip}) : super(key: key);

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _showFrontSide = true;

  void _flipCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
      widget.onFlip();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _showFrontSide
            ? CardFront(question: widget.question.question)
            : CardBack(answer: widget.question.answer),
      ),
    );
  }
}
