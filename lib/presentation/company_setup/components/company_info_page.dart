import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_drop_down.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/smart_dialog.dart';
import '../../../models/company_model.dart';
import '../../../utils/colors.dart';

import '../../../core/constants/enums.dart';
import '../../../core/constants/global_string.dart';
import '../../../state_manager/data_state.dart';
import '../../../state_manager/init_state.dart';
import '../../../utils/styles.dart';

class CompanyInfoPage extends ConsumerStatefulWidget {
  const CompanyInfoPage({super.key});

  @override
  ConsumerState<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends ConsumerState<CompanyInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  File? logo;
  String? companyName;
  String? companyDescription;
  String? companyPhone;
  String? companyLocation;
  String? companyEmail;
  String? addressRegion;
  String? addressCity;
  String? addressStreet;
  String? addressPost;
  String? companyWebsite;

  String? secretQuestion1;
  String? secretQuestion2;
  String? answer1;
  String? answer2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Column(children: [
            Text(
              'Company Information'.toUpperCase(),
              style: getCustomTextStyle(context,
                  fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Please fill the company information to continue.',
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
                      InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: logo != null
                            ? Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(logo!))),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    'Select Company Logo*',
                                    style: getCustomTextStyle(context,
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(
                                width: 150,
                                height: 150,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    border: Border.all(color: primaryColor)),
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Select Company Logo*',
                                  style: getCustomTextStyle(context,
                                      fontSize: 11, color: Colors.black45),
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter Company Name*',
                        onSaved: (name) {
                          setState(() {
                            companyName = name;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter Company Description*',
                        maxLines: 3,
                        onSaved: (description) {
                          setState(() {
                            companyDescription = description;
                          });
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter Company Telephone*',
                        keyboardType: TextInputType.phone,
                        isDigitOnly: true,
                        max: 10,
                        onSaved: (phone) {
                          setState(() {
                            companyPhone = phone;
                          });
                        },
                        validator: (value) {
                          if (value!.length != 10) {
                            return 'Please enter valid phone number (10 digits)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter Company Email',
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (email) {
                          setState(() {
                            companyEmail = email;
                          });
                        },
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              !emailRegEx.hasMatch(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter Company Website',
                        keyboardType: TextInputType.text,
                        onSaved: (website) {
                          setState(() {
                            companyWebsite = website;
                          });
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Company Address',
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
                                child: CustomDropDown(
                                    onChanged: (region) {
                                      setState(() {
                                        addressRegion = region;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select region';
                                      }
                                      return null;
                                    },
                                    label: 'Region *',
                                    items: regions
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList()),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomTextFields(
                                  label: 'City *',
                                  keyboardType: TextInputType.text,
                                  onSaved: (city) {
                                    setState(() {
                                      addressCity = city;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter valid city';
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
                                child: CustomTextFields(
                                  label: 'Street',
                                  keyboardType: TextInputType.text,
                                  onSaved: (street) {
                                    setState(() {
                                      addressStreet = street;
                                    });
                                  },
                                  validator: (value) {
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomTextFields(
                                  label: 'Post Address',
                                  keyboardType: TextInputType.text,
                                  onSaved: (post) {
                                    setState(() {
                                      addressPost = post;
                                    });
                                  },
                                  validator: (value) {
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
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
                      CustomButton(
                          text: 'Save & Continue',
                          onPressed: () {
                            saveCompanyInfo();
                          }),
                      const SizedBox(height: 10),
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

  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //get image path
    if (image != null) {
      setState(() {
        logo = File(image.path);
      });
    }
  }

  void saveCompanyInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (logo == null) {
        CustomDialog.showError(
            title: 'Incomplete', message: 'Please select company logo');
        return;
      } else {
        try {
          CustomDialog.showLoading(message: 'Saving Company Info');
          // save company logo in a file and get the path
          var path = Directory('${Directory.current.path}/data/images').path;
          if (!Directory(path).existsSync()) {
            Directory(path).createSync(recursive: true);
          }
          var fileName = logo!.path.split('/').last;
          //get file extension
          var extension = fileName.split('.').last;
          var newPath = '$path/logo.$extension';
          File(logo!.path).copySync(newPath);
          logo = File(newPath);

          var companyInfo = CompanyInfoModel(
              companyName: companyName,
              companyDescription: companyDescription,
              companyPhoneNumber: companyPhone,
              companyEmail: companyEmail,
              companyWebsite: companyWebsite,
              companyAddress: {
                'region': addressRegion,
                'city': addressCity,
                'street': addressStreet,
                'post': addressPost
              },
              passwordReset: {
                'question1': secretQuestion1,
                'question2': secretQuestion2,
                'answer1': answer1,
                'answer2': answer2
              },
              companyLogo: logo!.path,
              createdAt: DateFormat('EE, MMM d yyyy @ HH:mm:ss a')
                  .format(DateTime.now().toUtc()));
          ref.read(companyProvider.notifier).saveCompanyInfo(companyInfo);

          CustomDialog.dismiss();
          CustomDialog.showToast(
              message: 'Company Info Saved', type: ToastType.success);
          ref.read(companySetupIndex.notifier).state = 1;
        } catch (e) {
          CustomDialog.dismiss();
          CustomDialog.showError(title: 'Error', message: e.toString());
        }
      }
    }
  }
}
