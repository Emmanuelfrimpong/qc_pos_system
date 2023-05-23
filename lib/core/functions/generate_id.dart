import 'dart:math';

import 'package:mongo_dart/mongo_dart.dart';
import '../../repositories/mongodb_api.dart';

class Generator {
  static Future<String> generateUserID() async {
    var db = MongodbAPI.getDatabase();
    final collection = db.collection('users');
    while (true) {
      const alphabet = 'abcdefghijklmnopqrstuvwxyz';
      final rand = Random();
      final alphaChars =
          List.generate(2, (_) => alphabet[rand.nextInt(alphabet.length)]);
      final numChars = List.generate(3, (_) => rand.nextInt(10));
      final idChars = [...alphaChars, ...numChars];
      String id = idChars.join().toUpperCase();
      final count = await collection.count(where.eq('_id', id));
      if (count == 0) {
        return id;
      }
    }
  }

  static Future<String> generateCompanyID() async {
    var db = MongodbAPI.getDatabase();
    final collection = db.collection('company');
    while (true) {
      const alphabet = 'abcdefghijklmnopqrstuvwxyz';
      final rand = Random();
      final alphaChars =
          List.generate(3, (_) => alphabet[rand.nextInt(alphabet.length)]);
      final numChars = List.generate(4, (_) => rand.nextInt(10));
      final idChars = [...alphaChars, ...numChars];
      String id = idChars.join().toUpperCase();
      final count = await collection.count(where.eq('_id', id));
      if (count == 0) {
        return id;
      }
    }
  }

  static Future<bool> checkIfUserExist(userId) async {
    var db = MongodbAPI.getDatabase();
    final collection = db.collection('users');
    final count = await collection.count(where.eq('_id', userId));
    if (count == 0) {
      return false;
    }
    return true;
  }
}
