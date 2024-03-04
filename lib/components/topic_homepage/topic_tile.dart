
import 'package:flashcard_quiz_game/util/methods.dart';
import 'package:flutter/material.dart';


class TopicTile extends StatelessWidget {
  const TopicTile({
    super.key,
    required this.topic,
  });

  final String topic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('tile was tapped $topic');
        loadSession(context: context, topic: topic);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
        ),
        child: Center(
            child: Text(
                topic,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),
        ),
      ),
    );
  }
}