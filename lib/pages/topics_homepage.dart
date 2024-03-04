
import 'package:flashcard_quiz_game/data/questions.dart';
import 'package:flutter/material.dart';

import '../components/topic_homepage/topic_tile.dart';


class TopicsHomepage extends StatefulWidget {
  const TopicsHomepage({Key? key}) : super(key: key);

  @override
  State<TopicsHomepage> createState() => _TopicsHomepage();
}

// Flashcard Page UI
class _TopicsHomepage extends State<TopicsHomepage> {

  List<String> _topics = [];

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

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        title: Text('Topics Homepage'),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColorLight,
            expandedHeight: size.height * 0.3,
            flexibleSpace: FlexibleSpaceBar(
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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


