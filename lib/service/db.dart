import 'package:absenpraujk/model/UserModel.dart';
import 'package:absenpraujk/service/pref_handler.dart';
import 'package:absenpraujk/service/query/AbsenQuery.dart';
import 'package:absenpraujk/service/query/UserQuery.dart';
import 'package:absenpraujk/utils/toast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  List<String> dataQuery = [
    'CREATE TABLE IF NOT EXISTS ${UserQuery.tableName}(${UserQuery.id} ${UserQuery.idType}, ${UserQuery.name} ${UserQuery.textType}, ${UserQuery.email} ${UserQuery.textType}, ${UserQuery.password} ${UserQuery.textType})',
    'CREATE TABLE IF NOT EXISTS ${Absenquery.tableName}(${Absenquery.id} ${Absenquery.idType}, ${Absenquery.userid} ${Absenquery.intType}, ${Absenquery.masukLat} ${Absenquery.realType}, ${Absenquery.masukLong} ${Absenquery.realType}, ${Absenquery.masukAddress} ${Absenquery.textType}, ${Absenquery.masukDate} ${Absenquery.dateType}, ${Absenquery.masukDateTime} ${Absenquery.datetimeType}, ${Absenquery.pulangLat} ${Absenquery.realType}, ${Absenquery.pulangLong} ${Absenquery.realType}, ${Absenquery.pulangAddress} ${Absenquery.textType}, ${Absenquery.pulangDate} ${Absenquery.dateType}, ${Absenquery.pulangDateTime} ${Absenquery.datetimeType})',
    //'CREATE TABLE IF NOT EXISTS ${Absenquery.tableName}(${Absenquery.id} ${Absenquery.idType}, FOREIGN KEY (${Absenquery.userid}) REFERENCES ${UserQuery.tableName} (${UserQuery.id}) ON CASCADE, ${Absenquery.masukLat} ${Absenquery.doubleType}, ${Absenquery.masukLong} ${Absenquery.doubleType}, ${Absenquery.masukAddress} ${Absenquery.textType}, ${Absenquery.masukDate} ${Absenquery.dateType}, ${Absenquery.masukDateTime} ${Absenquery.datetimeType}, ${Absenquery.pulangLat} ${Absenquery.doubleType}, ${Absenquery.pulangLong} ${Absenquery.doubleType}, ${Absenquery.pulangAddress} ${Absenquery.textType}, ${Absenquery.pulangDate} ${Absenquery.dateType}, ${Absenquery.pulangDateTime} ${Absenquery.datetimeType})',
  ];

  Future<Database> openNewDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'absenpraujk.db'),
      version: 1,
      onCreate: (db, version) async {
        for (String query in dataQuery) {
          try {
            await db.execute(query);
          } catch (e) {
            // Log the error for debugging purposes
            print('Error Membuat table: $e');
          }
        }
      },
    );
  }

  Future<String> insertUser({required Map<String, dynamic> data}) async {
    final db = await openNewDatabase();

    try {
      await db.insert(
        UserQuery.tableName,
        data,
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Replace if the user already exists
      );
      return 'User berhasil ditambahkan';
    } catch (e) {
      // Log the error for debugging purposes
      print('Error memasukkan user: $e');
      return 'Error memasukkan user: $e';
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    final db = await openNewDatabase();
    try {
      // Query the database for a user with the given email and password
      final List<Map<String, dynamic>> result = await db.query(
        UserQuery.tableName,
        where: '${UserQuery.email} = ? AND ${UserQuery.password} = ?',
        whereArgs: [email, password],
      );

      Map<String, dynamic> userData = result.first;
      UserModel userModel = UserModel.fromJson(userData);
      PreferenceHandler.saveId(userModel.id.toString());

      if (result.isNotEmpty) {
        return "Login Berhasil";
      } else {
        return "Login Gagal";
      }
    } catch (e) {
      // print('Error saat login: $e');
      return "Error saat login: $e";
    }
  }

  Future<UserModel> getUser({required String id}) async {
    final db = await openNewDatabase();
    try {
      // Query the database for a user with the given email and password
      final List<Map<String, dynamic>> result = await db.query(
        UserQuery.tableName,
        where: '${UserQuery.id} = ? ',
        whereArgs: [id],
      );

      Map<String, dynamic> userData = result.first;
      UserModel userModel = UserModel.fromJson(userData);

      if (result.isNotEmpty) {
        return userModel;
      } else {
        return UserModel.fromJson({});
      }
    } catch (e) {
      showToast('Error saat login: $e', success: false);
      return UserModel.fromJson({});
    }
  }

  Future<String> insertAbsen({required Map<String, dynamic> data}) async {
    final db = await openNewDatabase();

    try {
      // Check if the data already exists
      final List<Map<String, dynamic>> existingData = await db.query(
        Absenquery.tableName,
        where: '${Absenquery.masukDate} = ? AND ${Absenquery.userid} = ?',
        whereArgs: [data[Absenquery.masukDate], data[Absenquery.userid]],
      );

      if (existingData.isNotEmpty) {
        return 'Anda Sudah Absen Hari Ini';
      }

      // Insert the new data
      await db.insert(Absenquery.tableName, data);
      return 'Absen berhasil ditambahkan';
    } catch (e) {
      // Log the error for debugging purposes
      print('Error memasukkan absen: $e');
      return 'Error memasukkan absen: $e';
    }
  }
}
