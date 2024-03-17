// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

// Define a callback type for resetting the flashcard
typedef ResetCardCallback = void Function();

class Flashcard extends StatefulWidget {
  final String question;
  final String answer;
  final ResetCardCallback onReset; // Add a callback for resetting the card

  const Flashcard({
    super.key, 
    required this.question, 
    required this.answer, 
    required this.onReset, // Require the callback in the constructor
  });

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _showFrontSide = true;

  void _flipCard() {
    if (!_showFrontSide) {
      // If we are showing the answer side, call the reset callback
      widget.onReset();
    }
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  void resetCard() {
    if (!_showFrontSide) {
      setState(() {
        _showFrontSide = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedCrossFade(
        firstChild: CardFront(question: widget.question),
        secondChild: CardBack(answer: widget.answer),
        crossFadeState: _showFrontSide ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}

class CardFront extends StatelessWidget {
  final String question;

  const CardFront({super.key, required this.question});

 @override
 Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(100.0), // Increase padding
        child: Center(
          child: Text(
            question,
            style: const TextStyle(
              fontSize: 24, // Increase font size
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  final String answer;

  const CardBack({super.key, required this.answer});

@override
 Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(100.0), // Increase padding
        child: Center(
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 24, // Increase font size
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
