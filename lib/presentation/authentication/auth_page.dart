import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import '../../core/constants/global_string.dart';
import '../../state_manager/init_state.dart';
import '../../utils/colors.dart';
import 'components/login_page.dart';
import 'components/reset_admin_pass.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 2,
      color: backColor,
      margin: EdgeInsets.symmetric(
          horizontal: size.width > 950 && size.width <= 1200
              ? size.width * .07
              : size.width > 1200
                  ? size.width * .1
                  : 3,
          vertical: size.height * .06),
      child: fluent.Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Row(children: [
            Expanded(
                child: fluent.Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  //? add company logo
                  Image.asset(
                    'assets/images/logo_new.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  for (String e in loginInfo)
                    fluent.Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: fluent.InfoBar(
                        title: Text(e.contains('*') ? 'Warning' : 'Note:'),
                        content: Text(e),
                        severity: e.contains('*')
                            ? fluent.InfoBarSeverity.warning
                            : fluent.InfoBarSeverity.info,
                        isLong: true,
                      ),
                    ),
                ],
              ),
            )),
            const VerticalDivider(
              color: Colors.black45,
              indent: 40,
              thickness: 2,
            ),
            Expanded(
                child: IndexedStack(
              index: ref.watch(authPageIndex),
              children: const [LoginPage(), ResetAdminPass()],
            )),
          ]),
        ),
      ),
    );
  }
}
