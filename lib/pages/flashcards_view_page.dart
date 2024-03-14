
import 'package:flashcard_quiz_game/animations/half_flip_animation.dart';
import 'package:flashcard_quiz_game/components/flashcards_view_page/card_back.dart';
import 'package:flashcard_quiz_game/notifiers/flashcards_notifier.dart';
import 'package:flashcard_quiz_game/pages/quiz_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/app/custom_appbar.dart';
import '../components/flashcards_view_page/card_front.dart';
import '../data/questions.dart';
import '../models/question.dart';

class FlashcardsViewPage extends StatefulWidget {
  const FlashcardsViewPage({super.key});

  @override
  State<FlashcardsViewPage> createState() => _FlashcardsViewPageState();
}
// Flashcard Page
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

  // Add a new question to the questions list, with this topic
  void _showAddQuestionDialog(BuildContext context) {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  hintText: 'Enter question',
                ),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  hintText: 'Enter answer',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new question to the questions list
                _addNewQuestion(
                  questionController.text,
                  answerController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Add new question to the current topic of flashcards
  void _addNewQuestion(String question, String answer) {
    final flashcardsNotifier = Provider.of<FlashcardsNotifier>(context, listen: false);
    final currentTopic = flashcardsNotifier.topic;

    setState(() {
      questions.add(Question(topic: currentTopic, question: question, answer: answer));
      flashcardsNotifier.generateAllSelectedQuestions();
    });
  }
  
  // Delete Confirmation
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Flashcard'),
          content: const Text('Are you sure you want to delete this flashcard?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteCurrentFlashcard();
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Delete the flashcard that the user is currently viewing
  void _deleteCurrentFlashcard() {
    final flashcardsNotifier = Provider.of<FlashcardsNotifier>(context, listen: false);
    final currentQuestion = flashcardsNotifier.question;

    setState(() {
      questions.removeWhere((question) =>
      question.question == currentQuestion.question &&
          question.answer == currentQuestion.answer);
      flashcardsNotifier.generateAllSelectedQuestions();
      flashcardsNotifier.generateCurrentQuestion();
    });
  }

  // check to see if only one flashcard is left
  // User cannot delete a flashcard if only one is left
  bool _isOnlyOneFlashcardLeft() {
    final flashcardsNotifier = Provider.of<FlashcardsNotifier>(context, listen: false);
    final currentTopic = flashcardsNotifier.topic;
    final questionsForTopic = questions.where((question) => question.topic == currentTopic).toList();
    return questionsForTopic.length == 1;
  }

 @override
Widget build(BuildContext context) {
  // Consumer runs the builder to update the UI, based on value changes in the provider object (FlashcardNotifier)
  return Consumer<FlashcardsNotifier>(
    builder: (_, notifier, __) => Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(),
      ),
      body: IgnorePointer(
        ignoring: notifier.ignoreTouches,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CardBack(answer: ''),
            const CardFront(question: ''),
            Positioned(
              bottom: 50,
              right: 150,
              child: _isOnlyOneFlashcardLeft()
                  ? const AbsorbPointer(
                      child: IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.delete),
                        onPressed: null, // Disable the button
                      ),
                    )
                  : IconButton(
                      iconSize: 50,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                    ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.07, // Adjust the position as needed
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red, // text color
                ),
                onPressed: () {
                  // Navigate to the quiz screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizModePage(),
                    ),
                  );
                },
                child: const Text('Quiz Yourself', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addQuestion',
        onPressed: () {
          _showAddQuestionDialog(context); // add question, dialog pop up.
        },
        child: const Icon(Icons.add),
        ),
      ),
    );
  }
}