import 'package:flashcard_quiz_game/components/flashcards_view_page/Flashcard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/flashcards_notifier.dart';
import '../models/question.dart';

class QuizModePage extends StatefulWidget {
  const QuizModePage({super.key, required this.topicName});
  final String topicName;

  @override
  QuizModePageState createState() => QuizModePageState();
}

class QuizModePageState extends State<QuizModePage> {
  int _currentIndex = 0;
  int _score = 0;
  late List<Question> _questions;
  bool _lastQuestionAnswered = false;

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
    // If not the last question, just move to the next one
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // If the last question, mark it as answered
      setState(() {
        _lastQuestionAnswered = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Mode: $topicName')),
        body: const Center(child: Text('No questions available')),
      );
    }

    Question currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Mode')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flashcard(
                question: currentQuestion.question,
                answer: currentQuestion.answer, onReset: () {  },
              ),
              const SizedBox(height: 20),
              // Show check and cross buttons unless it's the last question and it has been answered
              if (_currentIndex < _questions.length - 1 || !_lastQuestionAnswered)
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
              // If it's the last question and it has been answered, show the "Show Results" button
              if (_currentIndex == _questions.length - 1 && _lastQuestionAnswered)
                ElevatedButton(
                  onPressed: _showQuizResults,
                  child: const Text('Show Results'),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Back to Topics'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _lastQuestionAnswered = false; // Reset this for the next quiz
              });
              Navigator.of(context).pop();
            },
            child: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }
}
