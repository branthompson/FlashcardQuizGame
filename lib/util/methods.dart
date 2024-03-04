import 'package:flashcard_quiz_game/notifiers/flashcards_notifier.dart';
import 'package:flashcard_quiz_game/pages/flashcards_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

loadSession({ required BuildContext context, required String topic}) {

  // pushReplacement removes the previous page (no back button) so maybe use push, idk
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FlashcardsViewPage()));

  // Access Flashcards notifier which accesses the topic and sets it for that specific session
  Provider.of<FlashcardsNotifier>(context, listen: false).setTopic(topic: topic);

}