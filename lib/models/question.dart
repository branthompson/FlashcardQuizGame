class Question {
  int? id; // Adding an ID field
  final String topic;
  final String question;
  final String answer;

  Question({this.id, required this.topic, required this.question, required this.answer});

 Map<String, dynamic> toMap() {
  return {
    'id': id,
    'topic': topic,
    'question': question,
    'answer': answer,
  };
}

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      topic: map['topic'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}
