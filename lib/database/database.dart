import 'package:sqflite/sqflite.dart';

import 'database_fields.dart';
import 'model.dart';

/// resource:
/// https://blog.logrocket.com/flutter-sqlite-how-to-persist-data/

class DataBaseHelper {
  DataBaseHelper._();
  static final DataBaseHelper _dataBaseHelper = DataBaseHelper._();
  factory DataBaseHelper(){
    return _dataBaseHelper;
  }
  late Database db;

  Future<void> initDB() async {
    String dbPath = await getDatabasesPath();
    db = await openDatabase(
      "$dbPath/user_demo.db",
      onCreate: (dataBase, version) async {
        await dataBase.execute('''
          CREATE TABLE ${UserFields.tableName} (
            ${UserFields.id} ${UserFields.idType},
            ${UserFields.name} ${UserFields.textType},
            ${UserFields.age} ${UserFields.intType},
            ${UserFields.email} ${UserFields.textType}
          )
        ''');
      },
      version: 1,
    );
  }

  // create
  Future<int> insertUser(User user) async {
    int result = await db.insert(UserFields.tableName, user.toMap());
    return result;
  }

  // update
  Future<int> updateUser(User user) async {
    int result = await db.update(UserFields.tableName, user.toMap(), where: "id = ?", whereArgs: [user.id]);
    return result;
  }

  // read
  Future<List<User>> retrieveUsers() async {
    final List<Map<String, dynamic>> queryResult = await db.query(UserFields.tableName);
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  // delete
  Future<void> deleteUser(int id) async {
    await db.delete(UserFields.tableName, where: "id = ?", whereArgs: [id]);
  }

}