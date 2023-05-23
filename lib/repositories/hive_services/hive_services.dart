import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';
import '../mongodb_api.dart';

class HiveApi {
  static Future<void> init() async {
    await WindowManager.instance.ensureInitialized();
    await Hive.initFlutter(Directory('${Directory.current.path}/data').path);
    await MongodbAPI.openConnection();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(900, 700),
      minimumSize: Size(900, 700),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
      //? set window to maximized
      await windowManager.maximize();
      await windowManager.show();
      await windowManager.focus();
    });

    await Hive.initFlutter();
    await Hive.openBox('core');
  }

// save user login info which will save a user model map
  static void saveUserLoginInfo(String userId) {
    Hive.box('core').put('login', userId);
  }

// get user login info which will return a user model map
  static String? getUserLoginInfo() {
    return Hive.box('core').get('login', defaultValue: '');
  }

  static void removeLoginData() {
    Hive.box('core').delete('login');
  }
}
