// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/drawer_custom.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/models/product_model.dart';
import 'package:foodable/providers/categories_provider.dart';

import 'package:foodable/providers/product_units_provider.dart';
import 'package:foodable/utils/network_utils.dart';
import 'package:foodable/widgets/animated_loader.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ProductsAddEditPage extends StatefulWidget {
  //final ProductsModel? product;
  const ProductsAddEditPage({
    Key? key,
    //required this.product,
  }) : super(key: key);

  @override
  ProductsAddEditPageState createState() => ProductsAddEditPageState();
}

class ProductsAddEditPageState extends State<ProductsAddEditPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProductsModel? product =
        ModalRoute.of(context)?.settings.arguments as ProductsModel?;
    // print(product?.productName);
    //print(widget.product.productPrice);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xfff0fff0),
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 40),
          child: ResponsiveLayout.isTinyLimit(context) ||
                  ResponsiveLayout.isTinyHeightLimit(context)
              ? Container()
              : AppBar(
                  backgroundColor: (Platform.isWindows)
                      ? Color(0xff5D0FD3)
                      : Color(0xff003366),
                  title: buildAppbarTitle(product),
                  centerTitle: true,
                  actions: (Platform.isWindows)
                      ? [
                          MinimizeWindowButton(),
                          MaximizeWindowButton(),
                          CloseWindowButton()
                        ]
                      : [],
                ),
        ),
        body: ResponsiveLayout(
          tiny: Container(),
          phone: buildAddEdit(product),
          tablet: buildAddEdit(product),
          largeTablet: Row(
            children: [
              Expanded(
                flex: 3,
                child: DrawerPage(),
              ),
              Expanded(flex: 10, child: buildAddEdit(product)),
            ],
          ),
          computer: Row(
            children: [
              Expanded(
                flex: 3,
                child: DrawerPage(),
              ),
              Expanded(flex: 10, child: buildAddEdit(product)),
            ],
          ),
        ));
  }

  Future<void> showInformationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
              width: double.infinity,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedLoader(),
                  Text('Submitting  Product.. '),
                ],
              )),
        );
      },
      barrierDismissible: false,
    );
  }

  updateProduct(formValue, product) async {
    //print(formValue['productname']);

    showInformationDialog(context);
    var responseJson = await NetworkUtils.updateProduct(
      productid: product.productId,
      configproductid: product.configProductId,
      productname: formValue['productname'],
      productcategory: formValue['productcategory'],
      productunit: formValue['productunit'],
      productprice: formValue['productprice'],
      productsku: formValue['productsku'],
      producthsncode: formValue['producthsncode'],
      productdescription: formValue['productdescription'],
      productbarcode: formValue['productbarcode'],
    );
    Navigator.of(context).pop();
    //print(responseJson);
    return responseJson;
  }

  createProduct(formValue) async {
    showInformationDialog(context);
    var responseJson = await NetworkUtils.createProduct(
      productname: formValue['productname'],
      productcategory: formValue['productcategory'],
      productunit: formValue['productunit'],
      productprice: formValue['productprice'],
      productsku: formValue['productsku'],
      producthsncode: formValue['producthsncode'],
      productdescription: formValue['productdescription'],
      productbarcode: formValue['productbarcode'],
    );
    Navigator.of(context).pop();
    //print(responseJson);
    return responseJson;
  }

  buildAddEdit(product) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: <Widget>[
                  buildProductName(product),
                  buildProductCategory(product),
                  buildProductUnit(product),
                  buildProductPrice(product),
                  buildProductSku(product),
                  buildProductHsn(product),
                  buildProductBarcode(product),
                  buildProductDesc(product),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // if (_isformsubmit) {
                      //   showInformationDialog(context);
                      // } else {
                      //   Navigator.of(context).pop();
                      // }

                      FocusScope.of(context).requestFocus(FocusNode());

                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        var formValue = _formKey.currentState?.value;
                        // print(formValue!['productname']);

                        if (product != null) {
                          var response =
                              await updateProduct(formValue, product);

                          var editedProduct =
                              ProductsModel.fromJson(response[0]);
                          Navigator.pop(context, editedProduct);
                        } else {
                          var response = await createProduct(formValue);

                          var newProduct = ProductsModel.fromJson(response[0]);
                          Navigator.pop(context, newProduct);
                        }
                      } else {
                        //print('validation failed');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  buildAppbarTitle(product) {
    if (Platform.isWindows) {
      return WindowTitleBarBox(
        child: MoveWindow(
          child: Row(
            children: [
              Text('Foodable Pos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Expanded(
                child: Center(
                  child: Text(
                    (product != null)
                        ? 'Edit Product-${product.productName}'
                        : 'Add Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Text((product != null) ? 'Edit Product' : 'Add Product');
  }
}

Widget buildProductDesc(product) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      FormBuilderTextField(
        initialValue: (product != null) ? product.productDescription : '',
        maxLines: 4,
        name: 'productdescription',
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          icon: Icon(Icons.sticky_note_2),
          floatingLabelStyle:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          label: Text('Product Description'),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          //hintText: 'Product Description',
        ),
        onChanged: (String) {},
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          //FormBuilderValidators.required(errorText:'Category cannot be empty'),
          FormBuilderValidators.max(50),
        ]),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget buildProductHsn(product) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      FormBuilderTextField(
        name: 'producthsncode',
        maxLength: 8,
        initialValue: (product != null) ? product.productHsnCode : '',
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          icon: Icon(FontAwesomeIcons.cog),
          labelText: 'Product HSNcode',
          floatingLabelStyle:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        onChanged: (String) {},
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.maxLength(8),
          FormBuilderValidators.numeric()
        ]),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget buildProductSku(product) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      FormBuilderTextField(
        name: 'productsku',
        initialValue: (product != null) ? product.productSku : '',
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          icon: Icon(FontAwesomeIcons.bars),
          labelText: 'Product Sku',
          floatingLabelStyle:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        onChanged: (String) {},
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Product sku is required'),
          FormBuilderValidators.maxLength(10),
        ]),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget buildProductPrice(product) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      FormBuilderTextField(
        name: 'productprice',
        initialValue: (product != null) ? product.productPrice.toString() : '',
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
        ],
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          icon: Icon(
            FontAwesomeIcons.rupeeSign,
          ),
          labelText: 'Product Price',
          floatingLabelStyle:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        onChanged: (String) {},
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
              errorText: 'Product Price cannot be empty'),
          FormBuilderValidators.maxLength(8),
          (val) {
            var number = int.tryParse(val ?? '');
            if (number != null && number <= 0)
              return 'Price cannot be zero or negative';
            return null;
          }
        ]),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget buildProductName(product) {
  return Column(children: [
    SizedBox(
      height: 10,
    ),
    FormBuilderTextField(
      name: 'productname',
      initialValue: (product != null) ? product.productName : '',
      style: TextStyle(fontSize: 20),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(10),
        icon: Icon(FontAwesomeIcons.productHunt),
        labelText: 'Product Name',
        floatingLabelStyle:
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      onChanged: (String) {},
      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText: 'Product name cannot be empty'),
        FormBuilderValidators.maxLength(50),
      ]),
    ),
    SizedBox(
      height: 10,
    ),
  ]);
}

Widget buildProductBarcode(product) {
  return Column(children: [
    SizedBox(
      height: 0,
    ),
    FormBuilderTextField(
      name: 'productbarcode',
      maxLength: 13,
      keyboardType: TextInputType.number,
      initialValue: (product != null) ? product.barcode : '',
      style: TextStyle(fontSize: 20),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(10),
        icon: Icon(FontAwesomeIcons.barcode),
        labelText: 'Product Barcode',
        floatingLabelStyle:
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      onChanged: (String) {},
      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.maxLength(13),
      ]),
    ),
    SizedBox(
      height: 0,
    ),
  ]);
}

Widget buildProductUnit(product) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Consumer<ProductUnitsProvider>(builder: (context, provider, child) {
        var unitsList =
            Provider.of<ProductUnitsProvider>(context, listen: false)
                .productUnitsList;

        return FormBuilderDropdown(
          name: 'productunit',
          initialValue: (product != null) ? product.unitId : null,
          dropdownColor: Colors.white,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            icon: Icon(FontAwesomeIcons.balanceScale),
            labelText: 'Unit',
            floatingLabelStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          // initialValue: 'Male',

          allowClear: true,
          hint: const Text('Select Unit'),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Unit cannot be empty')
          ]),
          items: unitsList
              .map((unitsList) => DropdownMenuItem(
                    value: unitsList.unitId,
                    child: Text(
                        '${unitsList.unitLabel}-${unitsList.unitShortForm}'),
                  ))
              .toList(),
        );
      }),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget buildProductCategory(product) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Consumer<CategoriesProvider>(builder: (context, provider, child) {
        var categoriesList =
            Provider.of<CategoriesProvider>(context, listen: false)
                .categoriesList;

        return FormBuilderDropdown(
          name: 'productcategory',
          initialValue: (product != null && product.categoryId != 0)
              ? product.categoryId
              : null,
          dropdownColor: Colors.white,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            icon: Icon(FontAwesomeIcons.tag),
            labelText: 'Category',
            floatingLabelStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          // initialValue: 'Male',
          allowClear: true,
          hint: const Text('Select Category'),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: 'Category cannot be empty')
          ]),
          items: categoriesList
              .map((categoriesList) => DropdownMenuItem(
                    value: categoriesList.categoryId,
                    child: Text(categoriesList.categoryName),
                  ))
              .toList(),
        );
      }),
      SizedBox(
        height: 10,
      ),
    ],
  );
}
