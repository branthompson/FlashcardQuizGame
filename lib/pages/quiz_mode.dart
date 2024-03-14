import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/flashcards_notifier.dart';
import '../models/question.dart';
import 'package:flashcard_quiz_game/components/flashcards_view_page/flashcard.dart';

class QuizModePage extends StatefulWidget {
  const QuizModePage({Key? key}) : super(key: key);

  @override
  _QuizModePageState createState() => _QuizModePageState();
}

class _QuizModePageState extends State<QuizModePage> {
  int _currentIndex = 0;
  int _score = 0;
  late List<Question> _questions;

  @override
  void initState() {
    super.initState();
    final notifier = Provider.of<FlashcardsNotifier>(context, listen: false);
    _questions = notifier.selectedQuestions;
  }

  void _nextCard(bool correct) {
    if (correct) {
      _score++;
    }
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _showQuizResults(); // End of quiz
    }
  }

  void _showQuizResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Text('You scored $_score out of ${_questions.length}.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); 
            },
            child: const Text('Back to Topics'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              setState(() {
                _currentIndex = 0; // Reset
                _score = 0;
              });
            },
            child: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar
(title: const Text('Quiz Mode')),
body: const Center(child: Text('No questions available')),
);
}

Question currentQuestion = _questions[_currentIndex];
Key flashcardKey = ValueKey(_currentIndex);

return Scaffold(
  appBar: AppBar(
    title: const Text('Quiz Mode'),
  ),
  body: Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flashcard(
            key: flashcardKey,
            question: currentQuestion, // Pass the question text
            // answer: currentQuestion.answer, // Pass the answer text
            onFlip: () {},
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _nextCard(false),
                color: Colors.red,
                iconSize: 50,
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => _nextCard(true),
                color: Colors.green,
                iconSize: 50,
              ),
            ],
          ),
            const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
