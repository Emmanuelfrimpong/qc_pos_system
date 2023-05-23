import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/global_string.dart';
import '../../../core/widgets/custom_drop_down.dart';
import '../../../models/user_model.dart';
import '../../../state_manager/data_state.dart';
import '../../../core/functions/generate_id.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/smart_dialog.dart';
import '../../../state_manager/init_state.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

class AdminInfo extends ConsumerStatefulWidget {
  const AdminInfo({super.key});

  @override
  ConsumerState<AdminInfo> createState() => _AdminInfoState();
}

class _AdminInfoState extends ConsumerState<AdminInfo> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  File? image;
  String? adminId;
  String? name;
  String? telephone;
  String? gender;
  String? prefix;
  String? password;

  final _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Column(children: [
            Text(
              'Company Administrator'.toUpperCase(),
              style: getCustomTextStyle(context,
                  fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Please fill the Administrator information below',
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
                        child: image != null
                            ? Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(image!))),
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    'Select image',
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
                                  'Select image',
                                  style: getCustomTextStyle(context,
                                      fontSize: 11, color: Colors.black45),
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextFields(
                              label: 'Enter Admin ID',
                              isCapitalized: true,
                              controller: _idController,
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
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: CustomButton(
                              text: 'Generate',
                              color: primaryColor,
                              onPressed: () {
                                generateId();
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDown(
                                onChanged: (pre) {
                                  setState(() {
                                    prefix = pre;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select Name Prefix';
                                  }
                                  return null;
                                },
                                label: 'Prefix *',
                                items: namePrefix
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList()),
                          ),
                          const SizedBox(width: 10),
                          // gender dropdown
                          Expanded(
                              child: CustomDropDown(
                                  onChanged: (gen) {
                                    setState(() {
                                      gender = gen;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select gender';
                                    }
                                    return null;
                                  },
                                  label: 'Gender *',
                                  items: genders
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList()))
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter FullName*',
                        onSaved: (n) {
                          setState(() {
                            name = n;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter admin name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomTextFields(
                        label: 'Enter Telephone*',
                        keyboardType: TextInputType.phone,
                        isDigitOnly: true,
                        max: 10,
                        onSaved: (phone) {
                          setState(() {
                            telephone = phone;
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
                          text: 'Create Admin',
                          onPressed: () {
                            saveAdminInfo();
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

  void generateId() async {
    final id = await Generator.generateUserID();
    setState(() {
      _idController.text = id;
    });
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    //get image path
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  void saveAdminInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CustomDialog.showLoading(message: 'Saving Admin Info');

      String? imagePath;
      if (image != null) {
        //save image
        var path = Directory('${Directory.current.path}/data/images').path;
        if (!Directory(path).existsSync()) {
          Directory(path).createSync(recursive: true);
        }
        var fileName = image!.path.split('/').last;
        //get file extension
        var extension = fileName.split('.').last;
        var newPath = '$path/$adminId.$extension';
        File(image!.path).copySync(newPath);
        image = File(newPath);
        imagePath = image!.path;
      }
      UserModel userModel = UserModel()
        ..id = adminId
        ..createdAt = DateFormat('EE, MMM d yyyy @ HH:mm:ss a')
            .format(DateTime.now().toUtc())
        ..fullName = '$prefix $name'
        ..gender = gender
        ..image = imagePath
        ..password = password
        ..role = 'admin'
        ..status = 'active'
        ..telephone = telephone;
      ref.read(usersProvider.notifier).saveUser(userModel);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
          title: 'Data Saved', message: 'Admin Created successfully');
      //navigate to initial page again
      ref.refresh(configurationsProvider);
    }
  }
}
