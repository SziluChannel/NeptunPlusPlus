import 'package:neptun_app/data/local/database.dart';
import 'package:neptun_app/data/models/personal_data.dart';
import 'package:sqflite/sqflite.dart';

class PersonalDatabaseService {
  void insertPersonalData(PersonalData personalData) async {
    Database db = await NeptunDatabase().database;

    await db.insert(
      "personals",
      personalData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PersonalData>> getPersonalData() async {
    Database db = await NeptunDatabase().database;

    var maps = await db.query(
      "personals",
    );

    return List.generate(maps.length, (index) {
      return fromMap(maps[index]);
    });
  }

  PersonalData fromMap(Map<String, dynamic> map) {
    return PersonalData(
      map["neptunCode"],
      map["preName"],
      map["firstName"],
      map["lastName"],
      map["fullName"],
      DateTime.fromMillisecondsSinceEpoch(map["birthDate"]),
      map["birthCountry"],
      map["birthCounty"],
      map["birthPlace"],
      map["gender"],
      map["eduId"],
      map["mothersName"],
      map["tajNumber"],
      map["taxNumber"],
      map["omNumber"],
      map["examId"],
    );
  }
}
