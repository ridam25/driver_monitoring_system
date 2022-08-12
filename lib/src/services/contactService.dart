import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:driver_monitoring/src/models/contact.dart';

class ContactService {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "contacts.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE Contacts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT)""");
    });
  }

  Future<int> addItem(ContactModel item) async {
    final db = await init();
    return db.insert(
      "Contacts",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<ContactModel>> fetchContacts() async {
    final db = await init();
    final maps = await db.query("Contacts");

    return List.generate(maps.length, (i) {
      return ContactModel(
        id: int.parse(maps[i]['id'].toString()),
        name: maps[i]['name'].toString(),
        phone: maps[i]['phone'].toString(),
      );
    });
  }

  Future<int> deleteContact(int id) async {
    final db = await init();

    int result = await db.delete(
      "Contacts",
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }
}
