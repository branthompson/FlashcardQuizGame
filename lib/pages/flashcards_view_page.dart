
import 'package:flashcard_quiz_game/animations/half_flip_animation.dart';
import 'package:flashcard_quiz_game/components/flashcards_view_page/card_back.dart';
import 'package:flashcard_quiz_game/notifiers/flashcards_notifier.dart';
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

  //ADD QUESTION////////////////
  // Add a new question to the questions list, with this topic
  void _showAddQuestionDialog(BuildContext context) {
    TextEditingController _questionController = TextEditingController();
    TextEditingController _answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _questionController,
                decoration: InputDecoration(
                  hintText: 'Enter question',
                ),
              ),
              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  hintText: 'Enter answer',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new question to the questions list
                _addNewQuestion(
                  _questionController.text,
                  _answerController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
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

  //DELETE//////////////////////
  // Delete Confirmation
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Flashcard'),
          content: Text('Are you sure you want to delete this flashcard?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteCurrentFlashcard();
                Navigator.pop(context);
              },
              child: Text('Yes'),
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
            child: CustomAppBar()),
        body: IgnorePointer(
          ignoring: notifier.ignoreTouches,
          child: Stack(
            children: [
              CardBack(),
              CardFront(),
              Positioned( // DELETE ICON
                bottom: 50,
                right: 150,
                child: _isOnlyOneFlashcardLeft()
                    ? AbsorbPointer( // If only one left,
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.delete),
                    onPressed: null, // Disable the button
                  ),
                )
                    : IconButton( // otherwise show delete button
                  iconSize: 50,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                ),
              ),
            ],
          ),
        ), // Front of Flashcard
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddQuestionDialog(context); // add question, dialog pop up.
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}




