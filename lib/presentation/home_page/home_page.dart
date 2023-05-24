import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qc_pos_system/presentation/home_page/pages/edit_user.dart';
import '../../core/constants/enums.dart';
import 'pages/users/new_user.dart';
import 'pages/users/users_list.dart';
import 'widgets/side_bar.dart';
import '../../state_manager/init_state.dart';
import 'package:window_manager/window_manager.dart';
import '../../core/widgets/smart_dialog.dart';
import '../../utils/colors.dart';
import '../widgets/app_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with WindowListener {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50), child: MyAppBar()),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Row(children: [
          SizedBox(
            height: size.height,
            child: SideBar(),
          ),
          Expanded(
              child: Card(
                  color: backColor,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        fluent.SizedBox(height: size.height, child: _child()),
                  ))),
        ]),
      ),
    );
  }

  Widget _child() {
    HomePageItemsList item = ref.watch(homePageItemsProvider);
    switch (item) {
      case HomePageItemsList.user:
        return const UsersListPage();
      case HomePageItemsList.products:
        return const Text('Products');
      case HomePageItemsList.sales:
        return const Text('Sales');
      case HomePageItemsList.report:
        return const Text('Reports');
      case HomePageItemsList.settings:
        return const Text('Settings');
      case HomePageItemsList.newUser:
        return const NewUsers();
      case HomePageItemsList.editUser:
        return const EditUser();
      default:
        return const Text('Home');
    }
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
