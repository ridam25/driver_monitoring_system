import 'dart:async';
import 'dart:io';
import 'package:driver_monitoring/src/models/prevLog.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class PrevLogService {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "prevlog.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE PrevLogs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          duration INTEGER)""");
    });
  }

  Future<int> addItem(PrevLog item) async {
    final db = await init();
    return db.insert(
      "PrevLogs",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<PrevLog>> fetchLogs() async {
    final db = await init();
    final maps = await db.query("PrevLogs");

    return List.generate(maps.length, (i) {
      return PrevLog(
        id: int.parse(maps[i]['id'].toString()),
        duration: int.parse(maps[i]['duration'].toString()),
      );
    });
  }
}
