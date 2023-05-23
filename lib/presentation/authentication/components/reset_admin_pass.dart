import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/smart_dialog.dart';
import '../../../state_manager/data_state.dart';
import '../../../state_manager/init_state.dart';

import '../../../core/constants/global_string.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_drop_down.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../repositories/mongodb_api.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

class ResetAdminPass extends ConsumerStatefulWidget {
  const ResetAdminPass({super.key});

  @override
  ConsumerState<ResetAdminPass> createState() => _ResetAdminPassState();
}

class _ResetAdminPassState extends ConsumerState<ResetAdminPass> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  String? secretQuestion1;
  String? secretQuestion2;
  String? answer1;
  String? answer2;
  String? password;
  String? confirmPassword;
  String? adminId;

  @override
  void initState() {
    //ensure widget is build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // //get company info
      // await ref.read(companyProvider.notifier).getCompanyInfo();
      // //get company info
      // var company = ref.watch(companyProvider);
      // print('company ${company!.toMap()}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 120,
            child: Column(children: [
              Text(
                'Admin Password Reset'.toUpperCase(),
                style: getCustomTextStyle(context,
                    fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Note that this is valid for admin only. Any other user should contact the admin to reset their password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
            ]),
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 10,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Secret Questions & Answers *',
                          style: getCustomTextStyle(context,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black45),
                        ),
                        subtitle: Column(children: [
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomDropDown(
                                    onChanged: (value) {
                                      setState(() {
                                        secretQuestion1 = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select question';
                                      }
                                      return null;
                                    },
                                    hintText: 'Select Question',
                                    items: secretQuestion
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList()),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: CustomTextFields(
                                  label: 'Answer *',
                                  keyboardType: TextInputType.text,
                                  onSaved: (answer) {
                                    setState(() {
                                      answer1 = answer;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter answer';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomDropDown(
                                    onChanged: (value) {
                                      setState(() {
                                        secretQuestion2 = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select question';
                                      }
                                      return null;
                                    },
                                    hintText: 'Select Question',
                                    items: secretQuestion
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList()),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: CustomTextFields(
                                  label: 'Answer *',
                                  keyboardType: TextInputType.text,
                                  onSaved: (answer) {
                                    setState(() {
                                      answer2 = answer;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter answer';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),

                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter User ID',
                        isCapitalized: true,
                        max: 5,
                        onSaved: (id) {
                          setState(() {
                            adminId = id;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 5) {
                            return 'Admin ID can not be less than 5 characters';
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
                      CustomTextFields(
                        label: 'Confirm Password*',
                        keyboardType: TextInputType.text,
                        onSaved: (pass) {
                          setState(() {
                            confirmPassword = pass;
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
                          text: 'Reset Password',
                          onPressed: () {
                            resetPassword();
                          }),
                      const SizedBox(height: 24),
                      //back to login page
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'Back to ',
                                  style: getCustomTextStyle(context,
                                      fontSize: 16, color: Colors.black),
                                  children: [
                                TextSpan(
                                  text: 'Login',
                                  style: getCustomTextStyle(context,
                                      fontSize: 16,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      ref.read(authPageIndex.notifier).state =
                                          0;
                                    },
                                ),
                              ])),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (password != confirmPassword) {
        CustomDialog.showError(
            title: 'Password Error', message: 'Password does not match');
        return;
      }
      CustomDialog.showLoading(message: 'Resetting Password...');
      //get company info
      final company = await MongodbAPI.getCompanyInfo();
      ref.read(companyProvider.notifier).setCompanyInfo(company!);
      var message = await ref.read(usersProvider.notifier).resetAdminPassword(
          adminId: adminId!,
          question1: secretQuestion1!,
          question2: secretQuestion2!,
          answer1: answer1!,
          answer2: answer2!,
          password: password!,
          company: company);
      if (message.toLowerCase().contains('successfully')) {
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
          title: 'Date Updated',
          message: message,
        );
        _formKey.currentState!.reset();
        //back to login page
        ref.read(authPageIndex.notifier).state = 0;
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(title: 'Update Error', message: message);
      }
    }
  }
}
