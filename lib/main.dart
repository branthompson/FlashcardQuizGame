
import 'package:flashcard_quiz_game/configs/themes.dart';
import 'package:flashcard_quiz_game/notifiers/flashcards_notifier.dart';
import 'package:flashcard_quiz_game/pages/topics_homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(MultiProvider(
    providers: [
      // Any widget in the widget tree an now access FlashcardsNotifier to read/update/listen to values
      ChangeNotifierProvider(create: (_) => FlashcardsNotifier())
    ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard and Quiz Game',
      theme: appTheme,
      home: const TopicsHomepage(),
    );
  }
}


