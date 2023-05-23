import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/widgets/smart_dialog.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key, this.children});
  final List<Widget>? children;

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> with WindowListener {
  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: SizedBox(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: widget.children ?? const [],
            )),
            const SizedBox(
              width: 40,
            ),
            //* create action buttons
            InkWell(
              onTap: () {
                WindowManager.instance.minimize();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const CircleAvatar(
                radius: 8,
                backgroundColor: Colors.green,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const CircleAvatar(
                radius: 8,
                backgroundColor: Colors.yellow,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                WindowManager.instance.close();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
              ),
            )
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResized() {
    super.onWindowResized();
    WindowManager.instance.getSize().then((value) {
      if (value.width < 1000) {
        // ref.read(sideBarWidth.notifier).state = 60;
      }
    });
  }

  @override
  void onWindowUnmaximize() {
    WindowManager.instance.getSize().then((value) {
      if (value.width < 1000) {
        //ref.read(sideBarWidth.notifier).state = 60;
      }
    });
  }

  //on window close show dialog
  @override
  void onWindowClose() {
    CustomDialog.showInfo(
        title: 'Close Application',
        message: 'Are you sure you want to close the application?',
        onConfirm: () {
          windowManager.destroy();
        },
        onConfirmText: 'Yes | Close');
  }
}
