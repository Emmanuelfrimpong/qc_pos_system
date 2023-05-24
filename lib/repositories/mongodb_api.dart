import 'package:mongo_dart/mongo_dart.dart';
import '../models/company_model.dart';
import '../models/user_model.dart';

import 'db_connection.dart';

class MongodbAPI {
  // TODO: Implement MongodbAPI
  //* First we create connection to the database
  //* Then check if the connection is successful then we open the database or show error

  static Db? db;
  static Future<void> openConnection() async {
    try {
      db = await DBConnection().getConnection();
    } catch (e) {
      print(e);
    }
  }

  // return db
  static Db getDatabase() => db!;
  //! check if the database has collections
  static Future<bool> hasCollections() async {
    try {
      final collections = await db!.getCollectionNames();
      if (collections.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //! Functions for settings===============================================
  //* Get settings from database
  static Future<CompanyInfoModel?> getCompanyInfo() async {
    final company = await db!.collection('company').findOne();
    return company != null
        ? CompanyInfoModel.fromMap(company)
        : CompanyInfoModel.empty();
  }

  //* Save settings to database
  //? return true if settings saved successfully
  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      await db!.collection('settings').insertOne(settings);
      return true;
    } catch (e) {
      return false;
    }
  }

  //* Update settings in database by dropping the old one and inserting the new one
  //? return true if settings updated successfully
  static Future<bool> updateSettings(Map<String, dynamic> settings) async {
    try {
      await db!.collection('settings').drop();
      await db!.collection('settings').insertOne(settings);
      return true;
    } catch (e) {
      return false;
    }
  }

  //! End of settings function================================================================

  //! User functions===========================================================================
  //* Get all users from database
  static Future<List<UserModel>> getUsers() async {
    final users = await db!.collection('users').find().toList();
    return users.map((e) => UserModel.fromMap(e)).toList();
  }

  //* Get user by id from database
  static Future<Map<String, dynamic>?> getUserById(String id) async {
    final user = await db!.collection('users').findOne(where.eq('id', id));
    return user;
  }

  //* Get user by id and password from database
  static Future<Map<String, dynamic>?> getUserByIdAndPassword(
      String id, String password) async {
    final user = await db!
        .collection('users')
        .findOne(where.eq('id', id).and(where.eq('userPassword', password)));
    return user;
  }

  //* Save user to database
  //? return true if user saved successfully
  static Future<bool> saveUser(Map<String, dynamic> user) async {
    try {
      //? first delete the old one
      await db!.collection('users').deleteOne(where.eq('id', user['id']));
      await db!.collection('users').insertOne(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  //* Update user in database by deleting the old user and inserting the new one
  //? return true if user updated successfully
  static Future<bool> updateUserStatus(String status, String id) async {
    try {
      //find document and update it
      await db!
          .collection('users')
          .updateOne(where.eq('id', id), modify.set('status', status));
      return true;
    } catch (e) {
      return false;
    }
  }

  //* Update only user last login in database
  //? return true if user last login updated successfully
  static Future<bool> updateUserLastLogin(String id, String lastLogin) async {
    try {
      await db!
          .collection('users')
          .updateOne(where.eq('id', id), modify.set('lastLogin', lastLogin));
      return true;
    } catch (e) {
      return false;
    }
  }

  //* Delete user from database
  //? return true if user deleted successfully
  static Future<bool> deleteUser(String id) async {
    try {
      await db!.collection('users').deleteOne(where.eq('id', id));
      return true;
    } catch (e) {
      return false;
    }
  }

  // //* save user login
  // static Future<bool> saveUserLogin(UserModel userLogin) async {
  //   try {
  //     //? first delete the old one
  //     await db.collection('userLogin').deleteOne(where.eq('_id', 'login'));
  //     //? then insert the new one
  //     await db.collection('userLogin').insertOne({
  //       '_id': 'login',
  //       'user': userLogin.toMap(),
  //     });
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  //* get user login by id
  static Future<Map<String, dynamic>?> getUserLoggedIn() async {
    final userLogin =
        await db!.collection('userLogin').findOne(where.eq('_id', 'login'));
    return userLogin;
  }

  static Future<String> saveCompanyInfo(CompanyInfoModel companyInfo) {
    try {
      db!.collection('company').insertOne(companyInfo.toMap());
      return Future.value('success');
    } catch (e) {
      return Future.value('error');
    }
  }

  static Future<List<UserModel>> getAdmins() async {
    try {
      final admins = await db!
          .collection('users')
          .find(where.eq('role', 'admin'))
          .toList();
      return admins.map((e) => UserModel.fromMap(e)).toList();
    } catch (e) {
      return Future.value([]);
    }
  }

  static updateUser({required String id, required ModifierBuilder data}) {
    try {
      db!.collection('users').updateOne(where.eq('id', id), data);
      return Future.value('success');
    } catch (e) {
      return Future.value('error');
    }
  }
}
