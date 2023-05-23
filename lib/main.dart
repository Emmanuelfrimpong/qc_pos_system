import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'presentation/initial_page/initial_page.dart';
import 'repositories/hive_services/hive_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveApi.init();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return fluent.FluentApp(
      title: 'Quick Change POS',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      builder: FlutterSmartDialog.init(),
      darkTheme: fluent.FluentThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.standard,
        focusTheme: fluent.FocusThemeData(
          glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      theme: fluent.FluentThemeData(
        visualDensity: VisualDensity.standard,
        focusTheme: fluent.FocusThemeData(
          glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      home: const InitialPage(),
    );
  }
}
