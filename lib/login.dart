// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/dashboard.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './utils/auth_utils.dart';
import './utils/network_utils.dart';

//import './dashboard.dart';
//import './nodelist.dart';
//import './sosType.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;
  // final Map<String, dynamic> _formData = {
  //   'contact': null,
  //   'password': null,
  //   'rememberme': false
  // };
  //DataConnectionStatus intenetConnectionStatus;
  bool _isLoading = false;
  bool screenloader = true;
  bool obscureText = true;
  //bool keyboardOpen = false;
  var passwordError = '';
  var contactError = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences _sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormBuilderState>();

  var enabledBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );
  var focussedBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.green),
  );
  var errorFocussedBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurple),
  );
  @override
  void initState() {
    super.initState();
    _fetchSharedPreffernces();
    _logoAnimationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 2000,
        ));
    _logoAnimation = CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.bounceOut,
    );
    _logoAnimation.addListener(() => this.setState(() {}));
    _logoAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    super.dispose();
  }

  _fetchSharedPreffernces() async {
    _sharedPreferences = await _prefs;
  }

  _showLoading() {
    setState(() {
      this._isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      this._isLoading = false;
    });
  }

  _authenticateUser(contact, password) async {
    _showLoading();
    // this.intenetConnectionStatus =
    //     await DataConnectionChecker().connectionStatus;
    // if (this.intenetConnectionStatus == DataConnectionStatus.connected) {
    var responseJson = await NetworkUtils.authenticateUser(contact, password);

    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!', context);
    } else if (responseJson['password'] != null) {
      NetworkUtils.showSnackBar(
          _scaffoldKey, responseJson['password'], context);
    } else if (responseJson['msg'] != null) {
      NetworkUtils.showSnackBar(_scaffoldKey, responseJson['msg'], context);
    } else {
      AuthUtils.insertDetails(_sharedPreferences, responseJson);
      /**
				 * Removes stack and start with the new page.
				 * In this case on press back on HomePage app will exit.
				 * **/
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
      );
      /*Navigator.of(_scaffoldKey.currentContext)
					.pushReplacementNamed(SosType.routeName);
        */
    }
    // } else {
    //   NetworkUtils.showSnackBar(
    //       _scaffoldKey, 'Please Check Your Internet Connection.', context);
    // }

    _hideLoading();
  }

  Widget _loginScreen() {
    var containerWidth = double.infinity;
    if (ResponsiveLayout.isComputer(context) ||
        ResponsiveLayout.isLargeTablet(context)) {
      containerWidth = MediaQuery.of(context).size.width * 0.6;
    }
    if (ResponsiveLayout.isTablet(context)) {
      containerWidth = MediaQuery.of(context).size.width * 0.7;
    }
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('assets/bgpart1.jpg'))),
        ),
        if (Platform.isWindows)
          Positioned(
              top: 0,
              width: MediaQuery.of(context).size.width,
              child: WindowTitleBarBox(
                child: MoveWindow(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MinimizeWindowButton(),
                      MaximizeWindowButton(),
                      CloseWindowButton()
                    ],
                  ),
                ),
              )),
        Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 250,
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.contain,
                        height: _logoAnimation.value * 150,
                        width: _logoAnimation.value * 150,
                      ),
                    ],
                  ),
                ),
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Container(
                    width: containerWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        buildLoginContact(),
                        buildLoginPassword(),
                        if (_isLoading)
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white60,
                          ),
                        SizedBox(
                          height: 5,
                        ),
                        MaterialButton(
                          elevation: 0,
                          minWidth: containerWidth + 10,
                          padding: EdgeInsets.all(15),
                          color: Colors.redAccent,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());

                            _formKey.currentState!.save();

                            if (_formKey.currentState!.validate()) {
                              var formvalue = _formKey.currentState!.value;
                              print(formvalue['contact']);
                              _authenticateUser(
                                  formvalue['contact'], formvalue['password']);
                            } else {
                              print('validation failed');
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Colors.black45,
                                height: 8.0,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black45,
                                height: 8.0,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    // TODO Social Icons
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //double screenwidth = MediaQuery.of(context).size.width;

    //print(screenwidth);
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.blue,
      body: _loginScreen(),
    );
  }
}

Widget buildLoginContact() {
  return Column(
    children: [
      SizedBox(
        height: 5,
      ),
      FormBuilderTextField(
        cursorColor: Colors.white,
        keyboardType: TextInputType.number,
        maxLength: 10,
        name: 'contact',
        style: TextStyle(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
            counterText: '',
            prefixIcon: Icon(
              FontAwesomeIcons.phoneAlt,
              color: Colors.white,
              size: 15,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            border:
                OutlineInputBorder(borderSide: BorderSide.none, gapPadding: 2),
            hintStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.black45,
            hintText: 'Contact'),
        onChanged: (String) {},
        // valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: 'Contact cannot be empty'),
          FormBuilderValidators.maxLength(10),
        ]),
      ),
      SizedBox(
        height: 5,
      ),
    ],
  );
}

Widget buildLoginPassword() {
  return Column(children: [
    SizedBox(
      height: 5,
    ),
    FormBuilderTextField(
      cursorColor: Colors.white,
      maxLength: 10,
      name: 'password',
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(fontSize: 20, color: Colors.white),
      decoration: InputDecoration(
          counterText: '',
          prefixIcon: Icon(
            FontAwesomeIcons.lock,
            color: Colors.white,
            size: 15,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          border:
              OutlineInputBorder(borderSide: BorderSide.none, gapPadding: 2),
          hintStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black45,
          hintText: 'Password'),
      onChanged: (String) {},
      // valueTransformer: (text) => num.tryParse(text),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Password cannot be empty'),
      ]),
    ),
    SizedBox(
      height: 14,
    ),
  ]);
}
