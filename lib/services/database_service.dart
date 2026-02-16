import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;

  final String _musicTableName = "music";
  final String _musicId = "id";
  final String _musicTitle = "title";
  final String _musicFilePath = "filePath";
  final String _musicArtistName = "artistName";
  final String _musicAlbumTitle = "albumTitle";
  DatabaseService._constructor();

  Future<Database> get database async{
    if(_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async{
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(databasePath,
      version: 1,
      onCreate: (db, version){
          db.execute('''
          CREATE TABLE $_musicTableName (
              $_musicId INTEGER PRIMARY KEY,
              $_musicTitle TEXT NOT NULL,
              $_musicFilePath TEXT NOT NULL,
              $_musicArtistName TEXT NOT NULL,
              $_musicAlbumTitle TEXT NOT NULL
          )
          ''');
      }

    );
    return database;
  }

  void addMusic(String title, String FilePath, String ArtistName, String AlbumTitle)
  async{
    final db = await database;
    if(db!= null){
      await db.insert(_musicTableName, {
        _musicTitle: title,
        _musicFilePath:FilePath,
        _musicAlbumTitle:AlbumTitle,
        _musicArtistName:ArtistName


      });
    }

  }

}
