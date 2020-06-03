import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import "../models/Token.dart";

class TokenHelper {
  static Database database=null;

  static Future<void> init() async {
    if(database!=null)
    {
      return;
    }
    database = await openDatabase(
      join(await getDatabasesPath(), 'token_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE tokens(id INTEGER PRIMARY KEY,email TEXT,website TEXT,token TEXT)");
      },
      version: 1,
    );
  }

  static Future<void> insertToken(Token token) async {
    
    await database.insert('tokens', token.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Token>> getTokens() async {
    List<Map<String, dynamic>> tokens = await database.query("tokens");
    List<Token> returnTokens = List.generate(tokens.length, (index) {
      return Token(
          email: tokens[index]["email"],
          id: tokens[index]["id"],
          token: tokens[index]["token"],
          website: tokens[index]["website"]);
    });
    return returnTokens;
  }
}
