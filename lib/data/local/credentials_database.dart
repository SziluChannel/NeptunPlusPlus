import 'package:neptun_app/data/local/database.dart';
import 'package:sqflite/sqflite.dart';
import '../models/credential.dart';

class CredentialsDatabaseService {
  void insertCredential(Credential credential) async {
    Database db = await NeptunDatabase().database;

    await db.insert(
      "credentials",
      credential.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateCredential(Credential credential) async {
    Database db = await NeptunDatabase().database;

    await db.update(
      "credentials",
      credential.toMap(),
      where: "id = ?",
      whereArgs: [0],
    );
  }

  void deleteCredentials() async {
    Database db = await NeptunDatabase().database;
    db.delete("credentials");
  }

  Future<List<Credential>> getCredentials() async {
    Database db = await NeptunDatabase().database;

    final List<Map<String, dynamic>> maps = await db.query(
      "credentials",
    );

    return List.generate(maps.length, (index) {
      return Credential(
        maps[index]["username"],
        maps[index]["password"],
        maps[index]["hash"],
      );
    });
  }
}
