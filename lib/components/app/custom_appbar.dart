
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/flashcards_notifier.dart';
import '../../pages/topics_homepage.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardsNotifier>(
      builder: (_, notifier, __) => AppBar(
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => TopicsHomepage()),
                        (route) => false);
              },
              icon: const Icon(Icons.clear, color: Colors.white,))
        ],
        title: Text(notifier.topic),
      ),
    );
  }
}