import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database? _db ;

  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
  }

  initDatabase() async{

  }
}