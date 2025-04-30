import 'dart:ffi';

import 'package:absenpraujk/model/AbsenModel.dart';
import 'package:absenpraujk/model/UserModel.dart';
import 'package:absenpraujk/service/pref_handler.dart';
import 'package:absenpraujk/service/query/AbsenQuery.dart';
import 'package:absenpraujk/service/query/UserQuery.dart';
import 'package:absenpraujk/utils/toast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  List<String> dataQuery = [
    'CREATE TABLE IF NOT EXISTS ${UserQuery.tableName}(${UserQuery.id} ${UserQuery.idType}, ${UserQuery.name} ${UserQuery.textType}, ${UserQuery.email} ${UserQuery.textType}, ${UserQuery.password} ${UserQuery.textType})',
    'CREATE TABLE IF NOT EXISTS ${Absenquery.tableName}(${Absenquery.id} ${Absenquery.idType}, ${Absenquery.userid} ${Absenquery.intType}, ${Absenquery.masukLat} ${Absenquery.realType}, ${Absenquery.masukLong} ${Absenquery.realType}, ${Absenquery.masukAddress} ${Absenquery.textType}, ${Absenquery.masukDateTime} ${Absenquery.textType}, ${Absenquery.pulangLat} ${Absenquery.realType}, ${Absenquery.pulangLong} ${Absenquery.realType}, ${Absenquery.pulangAddress} ${Absenquery.textType}, ${Absenquery.pulangDateTime} ${Absenquery.textType})',
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
            showToast('Error Membuat table: $e', success: false);
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
      showToast('Error memasukkan user: $e', success: false);
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
      // showToast('Error saat login: $e', success: false);
      return "Error saat login: $e";
    }
  }

  Future<UserModel> getUser() async {
    final db = await openNewDatabase();
    var idUser = await PreferenceHandler.getId();
    try {
      // Query the database for a user with the given email and password
      final List<Map<String, dynamic>> result = await db.query(
        UserQuery.tableName,
        where: '${UserQuery.id} = ? ',
        whereArgs: [idUser],
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

  Future<String> insertAbsenMasuk({required Map<String, dynamic> data}) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    final db = await openNewDatabase();

    try {
      // Check if the data already exists
      final List<Map<String, dynamic>> existingData = await db.query(
        Absenquery.tableName,
        where:
            '${Absenquery.userid} = ? AND ${Absenquery.masukDateTime} LIKE ?',
        whereArgs: [
          data[Absenquery.userid],
          '%${dateFormat.format(DateTime.parse(data[Absenquery.masukDateTime])).toString()} %',
        ],
      );

      if (existingData.isNotEmpty) {
        return 'Anda Sudah Absen Hari Ini';
      } else {
        await db.insert(Absenquery.tableName, data);

        return 'Absen Masuk berhasil ditambahkan';
      }
    } catch (e) {
      showToast('Error memasukkan absen: $e', success: false);
      return 'Error memasukkan absen: $e';
    }
  }

  Future<String> insertAbsenPulang({
    required Map<String, dynamic> data,
    required int userId,
  }) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    final db = await openNewDatabase();

    try {
      final List<Map<String, dynamic>> existingData = await db.query(
        Absenquery.tableName,
        where:
            '${Absenquery.userid} = ? AND ${Absenquery.masukDateTime} LIKE ?',
        whereArgs: [
          userId,
          '%${dateFormat.format(DateTime.parse(data[Absenquery.pulangDateTime])).toString()} %',
        ],
      );

      if (existingData.isEmpty) {
        return 'Anda Blm Absen Hari Ini';
      } else if (existingData.first[Absenquery.pulangDateTime] != null) {
        return 'Anda Sudah Absen Pulang Hari Ini';
      } else {
        await db.update(
          Absenquery.tableName,
          data,
          where: '${Absenquery.id} = ?',
          whereArgs: [existingData.first[Absenquery.id]],
        );
        return 'Absen Pulang berhasil';
      }
    } catch (e) {
      showToast('Error memasukkan absen: $e', success: false);
      return 'Error memasukkan absen: $e';
    }
  }

  Future<List<AbsenModel>> getRiwayat() async {
    final db = await openNewDatabase();
    var idUser = await PreferenceHandler.getId();
    try {
      final List<Map<String, dynamic>> result = await db.query(
        Absenquery.tableName,
        where: '${Absenquery.userid} = ?',
        whereArgs: [idUser],
      );
      // print(result);
      return result.map((data) => AbsenModel.fromJson(data)).toList();
    } catch (e) {
      showToast('Error saat login: $e', success: false);
      return [];
    }
  }

  Future<List<AbsenModel>> getRiwayatbyFilter({
    required DateTime filterDate,
  }) async {
    final db = await openNewDatabase();
    var idUser = await PreferenceHandler.getId();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    try {
      final List<Map<String, dynamic>> result = await db.query(
        Absenquery.tableName,
        where:
            '${Absenquery.userid} = ? AND ${Absenquery.masukDateTime} LIKE ?',
        whereArgs: [idUser, '%${dateFormat.format(filterDate).toString()} %'],
      );
      print(result);
      return result.map((data) => AbsenModel.fromJson(data)).toList();
    } catch (e) {
      print('Error saat Menerapkan filter: $e');
      showToast('Error saat Menerapkan filter: $e', success: false);
      return [];
    }
  }

  Future<bool> updateUserProfile({required Map<String, dynamic> data}) async {
    final db = await openNewDatabase();
    var idUser = await PreferenceHandler.getId();

    try {
      // Update the user's profile in the database
      int count = await db.update(
        UserQuery.tableName,
        data,
        where: '${UserQuery.id} = ?',
        whereArgs: [idUser],
      );

      if (count > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Log the error for debugging purposes
      print('Error memperbarui profil: $e');
      return false;
    }
  }
}
