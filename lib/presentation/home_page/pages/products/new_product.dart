import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qc_pos_system/core/widgets/custom_input.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/functions/generate_id.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../state_manager/init_state.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';

class NewProduct extends ConsumerStatefulWidget {
  const NewProduct({super.key});

  @override
  ConsumerState<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends ConsumerState<NewProduct> {
  String? productId;
  String? productName;
  String? productDescription;
  File? productImage;
  String? barcode;
  String? unitOfMeasurement;
  String? sku;
  double? inStock;
  double? minimumStock;
  double? sellingPricePerUnit;
  List<String> tags = [];
  List<String> variants = [];

  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();

  @override
  void initState() {
    getId();
    super.initState();
  }

  getId() async {
    _productIdController.text = await Generator.generateProductId();
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            .setItem(HomePageItemsList.products)
                      },
                      icon: Icons.arrow_back,
                      text: "Back",
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'New Product'.toUpperCase(),
                        style: getCustomTextStyle(context,
                            fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Please all the required fields to create new product',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
                  //titleText(context, 'New User', fontSize: 40),
                ],
              ),
              const Divider(
                thickness: 2,
                height: 20,
              )
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(25),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                onTap: () {
                  pickImage();
                },
                child: productImage != null
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(productImage!))),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            'Select Product image',
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
                          'Select Product image',
                          style: getCustomTextStyle(context,
                              fontSize: 11, color: Colors.black45),
                        ),
                      ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  flex: 2,
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: CustomTextFields(
                              controller: _productIdController,
                              label: 'Product ID',
                              isCapitalized: true,
                              isReadOnly: true,
                              onSaved: (id) {
                                setState(() {
                                  productId = id;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomTextFields(
                              label: 'Barcode',
                              onSaved: (barcode) {
                                setState(() {
                                  this.barcode = barcode;
                                });
                              },
                              validator: (barcode) {
                                if (barcode!.isEmpty) {
                                  return 'Barcode is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomTextFields(
                        label: 'Product Name',
                        onSaved: (name) {
                          setState(() {
                            productName = name;
                          });
                        },
                        validator: (name) {
                          if (name!.isEmpty) {
                            return 'Product name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomTextFields(
                        label: 'Product Description',
                        maxLines: 3,
                        onSaved: (description) {
                          setState(() {
                            productDescription = description;
                          });
                        },
                        validator: (description) {
                          if (description!.isEmpty) {
                            return 'Product description is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ]),
                  ))
            ]),
          ),
        ));
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //get image path
    if (image != null) {
      setState(() {
        productImage = File(image.path);
      });
    }
  }
}
