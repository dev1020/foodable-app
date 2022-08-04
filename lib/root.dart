import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodable/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'utils/auth_utils.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RootPageState();
  }
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class RootPageState extends State<RootPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late SharedPreferences _sharedPreferences;
  bool isLoading = true;
  @override
  void initState() {
    _fetchAuthToken();
    super.initState();
  }

  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchAuthToken();
  }

  _fetchAuthToken() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        if (authToken == '') {
          authStatus = AuthStatus.notSignedIn;
        } else {
          authStatus = AuthStatus.signedIn;
        }
      });
    });
    //print(authStatus);
  }

  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context, width: 750, height: 1334);
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginPage();
      case AuthStatus.signedIn:
        return Dashboard();
    }
  }

  Widget _buildWaitingScreen() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(
          image: AssetImage('assets/bgpart1.jpg'),
          fit: BoxFit.cover,
          // color:Colors.black87,
          // colorBlendMode: BlendMode.darken,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(
              image: AssetImage('assets/logo.png'),
              fit: BoxFit.contain,
              height: 180,
              width: 180,
            ),
            Center(
              child: Container(
                width: 100,
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    // Center(
                    //   child: ColorizeAnimatedTextKit(
                    //     text: [
                    //       'Loading..',
                    //     ],
                    //     textStyle: TextStyle(
                    //       decoration: TextDecoration.none,
                    //       fontSize: 20,
                    //       fontStyle: FontStyle.italic,
                    //     ),
                    //     colors: [
                    //       Colors.purple,
                    //       Colors.blue,
                    //       Colors.yellow,
                    //       Colors.red,
                    //     ],
                    //     textAlign: TextAlign.start,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
