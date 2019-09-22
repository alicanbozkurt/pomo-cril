import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_apps/model/crill_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "crillo_db.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Crills(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(50), count INTEGER, date INTEGER )");
    print("Created tables");
  }

  void saveCrill(CrillModel crill) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Crills(name, count, date ) VALUES(' +
              '\'' +
              crill.crillName +
              '\'' +
              ',' +
              '\'' +
              crill.crilCount.toString() +
              '\'' +
              ',' +
              '\'' +
              crill.date.toString() +
              '\'' +
              ')');
    });
  }

  Future<List<CrillModel>> getCrillsToday() async {
    final now = DateTime.now();
    final today =  DateTime(now.year, now.month, now.day, 0).millisecondsSinceEpoch;
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 12).millisecondsSinceEpoch;
    
    
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Crills WHERE date BETWEEN '+today.toString()+' AND '+tomorrow.toString());
    List<CrillModel> crills = new List();
    for (int i = 0; i < list.length; i++) {
      crills.add(new CrillModel(crillName:list[i]["name"], crilCount:list[i]["count"], date:list[i]["date"]));
    }
    for(final cril in crills){
      print("crill data "+cril.crillName+" : "+cril.crilCount.toString()+" : "+cril.date.toString());
    }
    return crills;
  }

}