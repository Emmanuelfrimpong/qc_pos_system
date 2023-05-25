import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qc_pos_system/core/functions/string_to_title_case.dart';
import 'package:qc_pos_system/presentation/home_page/pages/products/new_product.dart';
import 'package:qc_pos_system/presentation/home_page/pages/products/product_list.dart';
import 'package:qc_pos_system/presentation/home_page/pages/users/edit_user.dart';
import 'package:qc_pos_system/utils/styles.dart';
import '../../core/constants/enums.dart';
import '../../state_manager/data_state.dart';
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
  // widget key
  final GlobalKey _companyKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var company = ref.watch(companyProvider);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: MyAppBar(
            children: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (company.companyLogo != null &&
                    company.companyLogo!.isNotEmpty)
                  InkWell(
                    onTap: () {
                      _showCompanyInfo();
                    },
                    child: Container(
                        key: _companyKey,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: FileImage(File(company.companyLogo!))))),
                  ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: ListTile(
                  title: Text(
                    company.companyName!.toTitleCase(),
                    style: getCustomTextStyle(context,
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${company.companyAddress!['region']} - ${company.companyAddress!['city']}',
                          style: getCustomTextStyle(context, fontSize: 12)),
                      Text('(${company.companyPhoneNumber})',
                          style: getCustomTextStyle(context, fontSize: 12))
                    ],
                  ),
                ))
              ],
            ),
          )),
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
        return const ProductList();
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
      case HomePageItemsList.newProduct:
        return const NewProduct();
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

  void _showCompanyInfo() async {
    final RenderBox renderBox =
        _companyKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(size.width, offset.dy + size.height * 2,
            size.width, offset.dy + size.height),
        items: [
          PopupMenuItem(
              child: Container(
            width: 150,
            height: 150,
            color: Colors.white,
          )),
        ]);
  }
}
