import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/company_model.dart';
import '../../models/user_model.dart';
import '../authentication/auth_page.dart';
import '../widgets/app_bar.dart';
import '../../repositories/hive_services/hive_services.dart';
import '../../utils/colors.dart';

import '../../state_manager/init_state.dart';
import '../company_setup/setup_main_page.dart';
import '../home_page/home_page.dart';

class InitialPage extends ConsumerStatefulWidget {
  const InitialPage({super.key});

  @override
  ConsumerState<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends ConsumerState<InitialPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configs = ref.watch(configurationsProvider);
    return configs.when(
      loading: () => Scaffold(
        backgroundColor: bgColor,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50), child: MyAppBar()),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
              child: fluent.Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.3),
            ),
            child: const fluent.Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                fluent.ProgressRing(
                  activeColor: Colors.black,
                ),
                SizedBox(height: 10),
                Text(
                  "Loading configurations...",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
      data: (data) {
        final company = data['company'] as CompanyInfoModel;
        final admin = data['admin'] as List<UserModel>;
        if (company.companyName == null || company.companyName!.isEmpty) {
          return const Scaffold(
            backgroundColor: bgColor,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50), child: MyAppBar()),
            body: Padding(
                padding: EdgeInsets.all(15), child: CompanySetupMainPage()),
          );
        } else {
          if (admin.isEmpty) {
            return const Scaffold(
              backgroundColor: bgColor,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50), child: MyAppBar()),
              body: Padding(
                  padding: EdgeInsets.all(15),
                  child: CompanySetupMainPage(
                    isCompanyInfoFilled: true,
                  )),
            );
          } else {
            var loginInfo = HiveApi.getUserLoginInfo();
            if (loginInfo == null || loginInfo.isEmpty) {
              // todo auth page
              return const Scaffold(
                backgroundColor: bgColor,
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(50), child: MyAppBar()),
                body: Padding(padding: EdgeInsets.all(15), child: AuthPage()),
              );
            } else {
              // todo main page
              return const HomePage();
            }
          }
        }
      },
      error: (error, stack) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(50), child: MyAppBar()),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
                child: SizedBox(
              width: 300,
              child: Text(
                "Error occurred while loading company info $error}",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.red,
                ),
                maxLines: 10,
              ),
            )),
          ),
        );
      },
    );
  }
}
