// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/drawer_custom.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/models/category_model.dart';
import 'package:foodable/utils/network_utils.dart';
import 'package:foodable/widgets/animated_loader.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CategoriesAddEditPage extends StatefulWidget {
  //final ProductsModel? product;
  const CategoriesAddEditPage({
    Key? key,
    //required this.product,
  }) : super(key: key);

  @override
  CategoriesdAddEditPageState createState() => CategoriesdAddEditPageState();
}

class CategoriesdAddEditPageState extends State<CategoriesAddEditPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesModel? category =
        ModalRoute.of(context)?.settings.arguments as CategoriesModel?;
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
                  title: buildAppbarTitle(category),
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
          phone: buildAddEdit(category),
          tablet: buildAddEdit(category),
          largeTablet: Row(
            children: [
              Expanded(
                flex: 3,
                child: DrawerPage(),
              ),
              Expanded(flex: 10, child: buildAddEdit(category)),
            ],
          ),
          computer: Row(
            children: [
              Expanded(
                flex: 3,
                child: DrawerPage(),
              ),
              Expanded(flex: 10, child: buildAddEdit(category)),
            ],
          ),
        ));
  }

  buildAppbarTitle(category) {
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
                    (category != null)
                        ? 'Edit Category-${category.categoryName}'
                        : 'Add Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Text((category != null) ? 'Edit Category' : 'Add Category');
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
                  Text('Submitting  Category.. '),
                ],
              )),
        );
      },
      barrierDismissible: false,
    );
  }

  updateCategory(formValue, category) async {
    showInformationDialog(context);
    var responseJson = await NetworkUtils.updateCategory(
        categoryId: category.categoryId,
        categoryname: formValue['categoryname'],
        status: formValue['categorystatus'],
        description: formValue['categorydescription']);
    Navigator.of(context).pop();
    //print(responseJson);
    return responseJson;
  }

  createCategory(formValue) async {
    showInformationDialog(context);
    var responseJson = await NetworkUtils.createCategory(
        categoryname: formValue['categoryname'],
        status: formValue['categorystatus'],
        description: formValue['categorydescription']);
    Navigator.of(context).pop();
    //print(responseJson);
    return responseJson;
  }

  builda() {
    return Container();
  }

  buildAddEdit(category) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: <Widget>[
                buildCategoryName(category),
                buildCategoryStatus(category),
                buildCategoryDesc(category),
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
                    FocusScope.of(context).requestFocus(FocusNode());

                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      var formValue = _formKey.currentState?.value;
                      // print(formValue!['productname']);
                      if (category != null) {
                        var response =
                            await updateCategory(formValue, category);

                        var editedCategory = CategoriesModel.fromJson(response);
                        Navigator.pop(context, editedCategory);
                      } else {
                        var response = await createCategory(formValue);

                        var newCategory = CategoriesModel.fromJson(response);
                        Navigator.pop(context, newCategory);
                      }
                    } else {
                      print('validation failed');
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
    );
  }
}

Widget buildCategoryDesc(category) {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      FormBuilderTextField(
        initialValue: (category != null) ? category.categoryDescription : '',
        maxLines: 4,
        name: 'categorydescription',
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          icon: Icon(Icons.sticky_note_2),
          floatingLabelStyle:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          label: Text('Category Description'),
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

Widget buildCategoryName(category) {
  return Column(children: [
    SizedBox(
      height: 10,
    ),
    FormBuilderTextField(
      name: 'categoryname',
      initialValue: (category != null) ? category.categoryName : '',
      style: TextStyle(fontSize: 20),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(10),
        icon: Icon(FontAwesomeIcons.productHunt),
        labelText: 'Category Name',
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
            errorText: 'Category name cannot be empty'),
        FormBuilderValidators.max(50),
      ]),
    ),
    SizedBox(
      height: 10,
    ),
  ]);
}

Widget buildCategoryStatus(category) {
  var statusList = ['Active', 'Inactive'];
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      FormBuilderDropdown(
        name: 'categorystatus',
        initialValue: (category != null) ? category.categoryStatus : null,
        dropdownColor: Colors.white,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          icon: Icon(FontAwesomeIcons.balanceScale),
          labelText: 'Status',
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
        hint: const Text('Select Status'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Status cannot be empty')
        ]),
        items: statusList
            .map((statusList) => DropdownMenuItem(
                  value: statusList,
                  child: Text(statusList),
                ))
            .toList(),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}
