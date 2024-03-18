import 'package:flashcard_quiz_game/data/questions.dart';
import 'package:flutter/material.dart';
import '../components/topic_homepage/topic_tile.dart';
import '../models/question.dart';

class TopicsHomepage extends StatefulWidget {
  const TopicsHomepage({super.key});

  @override
  State<TopicsHomepage> createState() => _TopicsHomepage();
}
// Topics Page UI
class _TopicsHomepage extends State<TopicsHomepage> {

  final List<String> _topics = [];

  @override
  void initState() {
    // populate the _topics list with the topics
    for(var t in questions){
      if(!_topics.contains(t.topic)) {
        _topics.add(t.topic);
      }
      // if wanna make alphabetical
      // _topics.sort();

    }
    super.initState();
  }
  // CREATE A NEW TOPIC//////////////////////////
  void _showCreateTopicDialog(BuildContext context) {
    TextEditingController topicController = TextEditingController();
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Topic'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: topicController,
                decoration: const InputDecoration(
                  hintText: 'Enter topic name',
                ),
              ),
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
                  topicController.text,
                  questionController.text,
                  answerController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
  // Add a new Question to the questions List
  void _addNewQuestion(String topic, String question, String answer) {
    setState(() {
      questions.add(Question(topic: topic, question: question, answer: answer));
    });
  }
  //UI//
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        title: const Text('Topics Homepage'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog or navigate to a new page to create a new topic
          _showCreateTopicDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColorLight,
            expandedHeight: size.height * 0.3,
            flexibleSpace: const FlexibleSpaceBar(
              background: Center(
                child: Text('Topics',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w400,
                    decoration:
                    TextDecoration.underline),
                ),
              ),
            ),
          ),
          SliverGrid( // Building Topic Tiles
            delegate: SliverChildBuilderDelegate(
              childCount: _topics.length,
              (context, index) => TopicTile(topic: _topics[index]),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 7, // spacing
              mainAxisSpacing: 7, // spacing
            ),
          ),
        ],
      ),
    );
  }
}
