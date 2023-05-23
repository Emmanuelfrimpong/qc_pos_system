import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/smart_dialog.dart';
import '../../../models/user_model.dart';
import '../../../repositories/hive_services/hive_services.dart';
import '../../../state_manager/data_state.dart';
import '../../../state_manager/init_state.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? userId;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Column(children: [
              Text(
                'User Login'.toUpperCase(),
                style: getCustomTextStyle(context,
                    fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Please fill the form below to login to the system',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFields(
                  label: 'Enter User ID',
                  isCapitalized: true,
                  max: 5,
                  onSaved: (id) {
                    setState(() {
                      userId = id;
                    });
                  },
                  validator: (value) {
                    if (value!.length < 5) {
                      return 'User ID can not be less than 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextFields(
                  label: 'Enter Your Password*',
                  keyboardType: TextInputType.text,
                  onSaved: (pass) {
                    setState(() {
                      password = pass;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                    text: 'Login',
                    onPressed: () {
                      login();
                    }),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Forgot Admin password? ',
                          style: getCustomTextStyle(context,
                              fontSize: 16, color: Colors.black)),
                      TextSpan(
                          text: 'Reset',
                          style: getCustomTextStyle(context,
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ref.read(authPageIndex.notifier).state = 1;
                            })
                    ])),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CustomDialog.showLoading(message: 'Logging in...');
      UserModel user =
          ref.read(usersProvider.notifier).login(userId!, password!);
      if (user.id == null) {
        CustomDialog.dismiss();
        CustomDialog.showError(
          message: 'Invalid User ID or Password',
          title: 'Login Failed',
        );
      } else {
        HiveApi.saveUserLoginInfo(user.id!);
        CustomDialog.dismiss();
        CustomDialog.showToast(
          message: 'Login Successful',
        );
        if (mounted) {
          ref.read(currentUserProvider.notifier).state = user;
          ref.refresh(configurationsProvider);
        }
      }
    }
  }
}
