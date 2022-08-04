// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/models/customer_model.dart';
//import 'package:foodable/providers/order_provider.dart';
import 'package:foodable/providers/pos_provider.dart';
import 'package:foodable/utils/network_utils.dart';
import 'package:foodable/widgets/animated_loader.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
//import 'package:intl/intl.dart';

class CreateOrderForm extends StatefulWidget {
  const CreateOrderForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateOrderFormState();
  }
}

class CreateOrderFormState extends State<CreateOrderForm> {
  late String orderDate;

  var _formKey = GlobalKey<FormBuilderState>();
  bool _isFormSubmitting = false;
  //var myFormat = DateFormat('yyyy-MM-dd');

  // This list holds all the suggestions

  final TextEditingController _typeAheadController = TextEditingController();
  TextEditingController _nameTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: MediaQuery.of(context).viewInsets,
        height: MediaQuery.of(context).size.height - 50,
        margin: EdgeInsets.only(top: 0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    TypeAheadFormField<CustomerModel>(
                      hideOnEmpty: true,
                      keepSuggestionsOnLoading: false,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            icon: Icon(FontAwesomeIcons.mobileAlt),
                            labelText: 'Contact Number',
                            floatingLabelStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          )),
                      suggestionsCallback: (pattern) async {
                        var list =
                            await CustomerModel.getCustomerSuggestions(pattern);
                        return list;
                      },
                      itemBuilder: (context, suggestion) {
                        //print(suggestion);
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xffe0e0e0), width: 1))),
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            minVerticalPadding: 4,
                            //contentPadding: EdgeInsets.all(4),
                            title: Text(suggestion.label),
                          ),
                        );
                      },
                      loadingBuilder: (context) {
                        return Container(
                          height: 100,
                          color: Colors.white,
                          child: Center(
                              // child: CircularProgressIndicator(
                              //     color: Color(0xffe0e0e0)),
                              child: AnimatedLoader()),
                        );
                      },
                      noItemsFoundBuilder: (context) {
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                              title: Text('No Existing Contact found')),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        this._typeAheadController.text = suggestion.contact;
                        _nameTextEditingController.text = suggestion.name;
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Contact cannot be empty'),
                        FormBuilderValidators.maxLength(10),
                        (String? value) {
                          String pattern = r'^[6-9]\d{9}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value!)) {
                            return 'Please provide a valid number';
                          }
                          return null;
                        }
                      ]),
                      //onSaved: (value) => this._selectedCity = value,
                    ),
                    buildFormName(),
                  ],
                ),
              ),
              if (_isFormSubmitting)
                // Container(
                //     height: 40,
                //     child: CircularProgressIndicator(
                //       strokeWidth: 6,
                //       backgroundColor: Colors.deepPurple.shade400,
                //       valueColor: AlwaysStoppedAnimation(Colors.blue.shade300),
                //       //color: Color(0xffff0000),
                //     ))
                AnimatedLoader()
              else
                SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.secondary,
                          shadowColor: Colors.transparent),
                      //color: Theme.of(context).colorScheme.secondary,
                      onPressed: _isFormSubmitting == false
                          ? () async {
                              FocusScope.of(context).requestFocus(FocusNode());

                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isFormSubmitting = true;
                                });
                                var responseJson =
                                    await NetworkUtils.createOrderPost(
                                        _typeAheadController.text,
                                        _nameTextEditingController.text);
                                if (!mounted) {
                                  return;
                                }
                                context
                                    .read<PosProvider>()
                                    .createOrder(responseJson);
                                setState(() {
                                  _isFormSubmitting = false;
                                });
                                Navigator.pop(context);
                              } else {
                                print('validation failed');
                              }
                            }
                          : null,
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade400,
                          shadowColor: Colors.transparent),
                      onPressed: _isFormSubmitting == false
                          ? () {
                              _formKey.currentState!.reset();
                              _typeAheadController.clear();
                            }
                          : null,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  buildFormName() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      FormBuilderTextField(
        controller: _nameTextEditingController,
        // focusNode: fieldFocusNode,
        name: 'name',
        maxLength: 25,
        //onEditingComplete: onFieldSubmitted,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
        ],
        //keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          icon: Icon(FontAwesomeIcons.userAlt),
          labelText: 'Name',
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
          FormBuilderValidators.maxLength(25),
        ]),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }

  // createOrder(contact, name) async {
  //   var responseJson = await NetworkUtils.createOrderPost(contact, name);
  //   //print(responseJson);
  //   if (!mounted) {
  //     return;
  //   }
  //   Provider.of<OrderProvider>(
  //     context,
  //     listen: false,
  //   ).createOrder(responseJson);

  //   Navigator.pop(context);
  // }

  // Future _selectDate() async {
  //   DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: new DateTime.now(),
  //       firstDate: new DateTime(2016),
  //       lastDate: DateTime.now().add(Duration(days: 365)));
  //   if (picked != null)
  //     setState(() => orderdatew.text = myFormat.format(picked));
  // }
}
