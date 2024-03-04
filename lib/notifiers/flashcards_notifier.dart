import 'package:flutter/material.dart';

// can call the notifierListeners() method to dispatch change notifications
class FlashcardsNotifier extends ChangeNotifier {

  String topic = "";

  // Wanna communicate what topic was selected when navigating to the new page
  setTopic({required String topic}) {
    this.topic = topic;
    notifyListeners();
  }

}