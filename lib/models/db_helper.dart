import 'package:flashcard_quiz_game/models/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static final DBHelper _instance = DBHelper._privateConstructor();

  DBHelper._privateConstructor();

  static DBHelper get instance => _instance;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  _initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'flashcard.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int version) async {
    // var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        topic TEXT,
        question TEXT, 
        answer TEXT
      )
    ''');
    
  }

 // Your insertFlashcard method should be expecting a Map<String, dynamic> because that's what toMap() returns.
  Future<int> insertFlashcard(Map<String, dynamic> questionMap) async {
    final db = await database;
    return await db.insert('flashcards', questionMap);
  }

  Future<List<Flashcard>> getFlashcards() async {
  final dbClient = await database;
  final List<Map<String, dynamic>> maps = await dbClient.query('flashcards', columns: ['id', 'topic', 'question', 'answer']);
  final List<Flashcard> flashcards = maps.map((map) => Flashcard.fromMap(map)).toList();
  return flashcards;
}

  
  Future<void> deleteFlashcard(int id) async {
    final dbClient = await database;
    await dbClient.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Add methods for deleting and updating flashcards here.
  // ...

}

class Flashcard {
  int? id;
  String question;
  String answer;
  String topic;

 Flashcard({this.id, required this.topic, required this.question, required this.answer});

  // Add 'topic' to toMap and fromMap as well
  Map<String, dynamic> toMap() {
    return {
      'id': id, // include id in toMap as well, some ORMs require this to be present
      'topic': topic,
      'question': question,
      'answer': answer,
    };
  }

  static Flashcard fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      topic: map['topic'], // Make sure 'topic' is extracted from the map
      question: map['question'],
      answer: map['answer'],
    );
  }
}