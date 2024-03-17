import 'dart:math';
import 'package:flashcard_quiz_game/configs/constants.dart';
import 'package:flashcard_quiz_game/data/questions.dart';
import 'package:flashcard_quiz_game/models/db_helper.dart';
import 'package:flashcard_quiz_game/enums/slide_direction.dart';
import 'package:flashcard_quiz_game/models/question.dart';
import 'package:flutter/material.dart';

// can call the notifierListeners() method to dispatch change notifications
class FlashcardsNotifier extends ChangeNotifier {

  String topic = "";
  Question question = Question(topic: "", question: "", answer: "");
  Question answer = Question(topic: "", question: "", answer: ""); // represents what on card back
  List<Question> selectedQuestions = [];

  // Wanna communicate what topic was selected when navigating to the new page
  setTopic({required String topic}) {
    this.topic = topic;
    notifyListeners();
  }

  generateAllSelectedQuestions(){
    selectedQuestions.clear();
    selectedQuestions = questions.where((element) => element.topic == topic).toList();
  }

  generateCurrentQuestion(){

    if(selectedQuestions.isNotEmpty){
      final randomQuestion = Random().nextInt(selectedQuestions.length);
      question = selectedQuestions[randomQuestion];
      selectedQuestions.removeAt(randomQuestion); // remove question after swiping
    }
    else {
      print('all words selected');
    }

    // So Question does not change when the card is flipped. Delaying issue
    Future.delayed(const Duration(milliseconds: kSlideAwayDuration), () {
      answer = question;
    });

  }

  ///////////////ANIMATION STUFF//////////////////////////////////////

  bool ignoreTouches = true;

  setIgnoreTouch({required bool ignore}){
    ignoreTouches = ignore;
    notifyListeners();
  }

  SlideDirection swipedDirection = SlideDirection.none;

  bool flipCard1 = false;
  bool flipCard2 = false;
  bool swipeCard2 = false;
  bool swipeCard1 = false;

  bool resetSwipeCard1 = false, resetSwipeCard2 = false, resetFlipCard1 = false, resetFlipCard2 = false;

  runSwipeCard1(){
    resetSwipeCard1 = false;
    swipeCard1 = true;
    notifyListeners();
  }

  runFlipCard1() {
    resetFlipCard1 = false;
    flipCard1 = true;
    notifyListeners();
  }

  resetCard1(){
    resetSwipeCard1 = true;
    resetFlipCard1 = true;
    swipeCard1 = false;
    flipCard1 = false;
  }

  runFlipCard2() {
    resetFlipCard2 = false;
    flipCard2 = true;
    notifyListeners();
  }

  runSwipeCard2({required SlideDirection direction}){
    swipedDirection = direction;
    resetSwipeCard2 = false;
    swipeCard2 = true;
    // print(swipedDirection);
    notifyListeners();
  }

  resetCard2(){
    resetSwipeCard2 = true;
    resetFlipCard2 = true;
    swipeCard2 = false;
    flipCard2 = false;
  }

  void updateAllFlashcards(List<Flashcard> allFlashcards) {}
  void flipCard() {}

}