import 'package:neptun_app/data/local/database.dart';
import 'package:neptun_app/data/models/event.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class EventsDatabaseService {
  void insertEvents(List<Event> events) {
    for (Event event in events) {
      insertEvent(event);
    }
  }

  void deleteAll() async {
    Database db = await NeptunDatabase().database;

    await db.delete("events");
  }

  void insertEvent(Event event) async {
    Database db = await NeptunDatabase().database;
    await db.insert(
      "events",
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Event>> getEvents() async {
    Database db = await NeptunDatabase().database;

    final List<Map<String, dynamic>> maps =
        await db.query("events", orderBy: "events.startDate DESC");

    return List.generate(maps.length, (index) {
      return fromMap(maps[index]);
    });
  }

  Event fromMap(Map<String, dynamic> e) {
    return Event(
      DateTime.fromMillisecondsSinceEpoch(e["startDate"]),
      DateTime.fromMillisecondsSinceEpoch(e["endDate"]),
      e["title"] as String,
      e["location"] as String,
    );
  }
}
