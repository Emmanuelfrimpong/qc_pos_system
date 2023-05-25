import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:qc_pos_system/core/functions/string_to_title_case.dart';
import 'package:qc_pos_system/core/widgets/smart_dialog.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/global_string.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_drop_down.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../state_manager/data_state.dart';
import '../../../../state_manager/init_state.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class EditUser extends ConsumerStatefulWidget {
  const EditUser({super.key});

  @override
  ConsumerState<EditUser> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  final _formKey = GlobalKey<FormState>();
  File? profileImage;
  String? userName, userPhone, userRole, userId;
  String? gender;
  String? prefix;

  final _userIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    // check if ui is being built for the first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.watch(selectedUserProvider);
      if (user.id != null) {
        _userIdController.text = user.id!;
        _fullNameController.text = user.fullName!.split('.')[1];
        _phoneController.text = user.telephone!;
        prefix = namePrefix
            .where((element) => element
                .toLowerCase()
                .contains(user.fullName!.split('.')[0].toLowerCase()))
            .first;
        gender = user.gender;
        userRole = user.role!.toTitleCase();
        if (user.image != null && user.image!.isNotEmpty) {
          profileImage = File(user.image!);
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(0),
        child: ListTile(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  //create a back button
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: CustomButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      onPressed: () => {
                        ref
                            .read(homePageItemsProvider.notifier)
                            .setItem(HomePageItemsList.user)
                      },
                      icon: Icons.arrow_back,
                      text: "Back",
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'Edit User'.toUpperCase(),
                        style: getCustomTextStyle(context,
                            fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Please note that user id can not be changed',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
                ],
              ),
              const Divider(
                thickness: 2,
                height: 20,
              )
            ],
          ),
          subtitle: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width >= 1000 ? size.width * 0.1 : 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: _buildPictureSection()),
                  const VerticalDivider(
                    thickness: 5,
                    width: 20,
                    color: Colors.black45,
                  ),
                  Expanded(flex: 2, child: _buildForm()),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ));
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextFields(
                  controller: _userIdController,
                  isReadOnly: true,
                  label: 'Enter User ID*',
                  isCapitalized: true,
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
              ),
              SizedBox(
                width: 140,
                child: CustomButton(
                  text: 'Auto Generate',
                  color: Colors.black45,
                  onPressed: () {
                    CustomDialog.showToast(
                        message: 'User id can not be changed');
                  },
                ),
              )
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomDropDown(
                    value: prefix,
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
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList()),
              ),
              const SizedBox(width: 10),
              // gender dropdown
              Expanded(
                  child: CustomDropDown(
                      value: gender,
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
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList())),
              const SizedBox(width: 10),
              Expanded(
                child: CustomDropDown(
                    label: 'Select User Role*',
                    value: userRole,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a user role';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        userRole = value;
                      });
                    },
                    onChanged: (value) {},
                    items: ['Admin', 'Sales', 'Manager'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: getCustomTextStyle(context, fontSize: 16),
                        ),
                      );
                    }).toList()),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextFields(
            label: 'Enter User name*',
            controller: _fullNameController,
            validator: (p0) {
              if (p0!.isEmpty) {
                return 'Please enter a valid name';
              }
              return null;
            },
            onSaved: (name) {
              setState(() {
                userName = name;
              });
            },
          ),
          const SizedBox(
            height: 24,
          ),
          CustomTextFields(
            label: 'Enter User Phone Number*',
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            isDigitOnly: true,
            onSaved: (phone) {
              setState(() {
                userPhone = phone;
              });
            },
            validator: (value) {
              if (value!.length != 10) {
                return 'Please enter a valid phone number (10 digits)';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          CustomButton(text: 'Update User', onPressed: () => updateUser()),
        ],
      ),
    );
  }

  Widget _buildPictureSection() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            pickImage();
          },
          child: profileImage != null
              ? Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: FileImage(profileImage!))),
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
                  decoration:
                      BoxDecoration(border: Border.all(color: primaryColor)),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Select image',
                    style: getCustomTextStyle(context,
                        fontSize: 11, color: Colors.black45),
                  ),
                ),
        ),
        const SizedBox(
          height: 20,
        ),
        for (String e in editUserInstruction)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: fluent.InfoBar(
                    title: Text(e.contains('*') ? 'Warning' : 'Note:'),
                    content: Text(e),
                    severity: e.contains('*')
                        ? fluent.InfoBarSeverity.warning
                        : fluent.InfoBarSeverity.warning,
                    isLong: true,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 50,
        ),
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
        profileImage = File(image.path);
      });
    }
  }

  updateUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String? imagePath;
        if (profileImage != null) {
          var path = Directory('${Directory.current.path}/data/images').path;
          if (!Directory(path).existsSync()) {
            Directory(path).createSync(recursive: true);
          }
          var fileName = profileImage!.path.split('/').last;
          //get file extension
          var extension = fileName.split('.').last;
          var newPath = '$path/$userId.$extension';
          File(profileImage!.path).copySync(newPath);
          profileImage = File(newPath);
          imagePath = profileImage!.path;
        }
        final data = modify
            .set('fullName', '$prefix $userName'.toTitleCase())
            .set('gender', gender)
            .set('telephone', userPhone)
            .set('role', userRole)
            .set('image', imagePath);
        ref.read(usersProvider.notifier).updateUser(userId, data);
        //clear form
        setState(() {
          _formKey.currentState!.reset();
          _userIdController.clear();
          profileImage = null;
          userRole = null;
        });
        //show success message
        CustomDialog.dismiss();
        //show success message and navigate to login page
        CustomDialog.showSuccess(
            title: 'Success', message: 'User updated successfully');
        //navigate back to user list
        ref
            .read(homePageItemsProvider.notifier)
            .setItem(HomePageItemsList.user);
      } catch (e) {
        CustomDialog.dismiss();
        CustomDialog.showError(
            title: 'Data Saving Error',
            message: 'Something went Wrong, Please try again later');
      }
    }
  }
}
