import 'package:neptun_app/data/local/database.dart';
import 'package:neptun_app/data/models/message.dart';
import 'package:sqflite/sqflite.dart';

class MessagesDatabaseService {
  void insertMessages(List<Message> messages) {
    for (Message message in messages) {
      insertMessage(message);
    }
  }

  void insertMessage(Message message) async {
    Database db = await NeptunDatabase().database;
    await db.insert(
      "messages",
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void deleteAll() async {
    Database db = await NeptunDatabase().database;

    await db.delete("messages");
  }

  Future<List<Message>> getMessages() async {
    Database db = await NeptunDatabase().database;

    final List<Map<String, dynamic>> maps = await db.query(
      "messages",
      orderBy: "messages.date DESC",
    );

    return List.generate(maps.length, (index) {
      return fromMap(maps[index]);
    });
  }

  Message fromMap(Map<String, dynamic> e) {
    return Message(
      id: e["id"],
      date: DateTime.fromMillisecondsSinceEpoch(e["date"]),
      title: e["title"],
      body: e["body"],
      sender: e["sender"],
    );
  }
}
