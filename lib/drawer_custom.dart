// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'layout/responsive_layout.dart';

import 'root.dart';
import 'utils/constants.dart';
import 'utils/network_utils.dart';
import 'widgets/custom_shape_clipper.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  DrawerPageState createState() => DrawerPageState();
}

class ButtonsInfo {
  ButtonsInfo({required this.title, required this.icon, required this.page});
  String title;
  IconData icon;
  String page;
}

int _currentIndex = 0;
List<ButtonsInfo> _buttonNames = [
  ButtonsInfo(title: 'Home', icon: Icons.home, page: '/home'),
  ButtonsInfo(
      title: 'Pos', icon: Icons.add_shopping_cart_rounded, page: '/pos'),
  ButtonsInfo(title: 'Orders', icon: Icons.access_alarm, page: '/orders'),
  ButtonsInfo(title: 'Products', icon: Icons.ad_units, page: '/products'),
  ButtonsInfo(
      title: 'Categories',
      icon: Icons.crop_square_outlined,
      page: '/categories'),
];

class DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    // START Set the active index in case of back press android
    var route = ModalRoute.of(context);
    if (route != null) {
      // print(route.settings.name);
      _currentIndex = _buttonNames.indexWhere(
          (element) => element.page.contains('${route.settings.name}'));
      //print(active);
    }
    // END

    return Drawer(
        child: ListView(
      children: [
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Color(0xff5D0FD3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    //fit: BoxFit.contain,
                    width: 80,
                  ),
                ),
                if (ResponsiveLayout.isComputer(context) ||
                    ResponsiveLayout.isLargeTablet(context))
                  Container()
                else
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        ...List.generate(
            _buttonNames.length,
            (index) => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        decoration: index == _currentIndex
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                    colors: [Constants.darkPink, Colors.red]))
                            : null,
                        child: GFListTile(
                          title: Text(
                            _buttonNames[index].title,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          avatar: Icon(
                            _buttonNames[index].icon,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          margin: (ResponsiveLayout.isComputer(context) ||
                                  ResponsiveLayout.isLargeTablet(context))
                              ? EdgeInsets.symmetric(horizontal: 8, vertical: 5)
                              : EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                              Navigator.pop(context);
                              var routename =
                                  ModalRoute.of(context)?.settings.name;
                              if (routename != _buttonNames[index].page) {
                                Navigator.pushNamed(
                                    context, _buttonNames[index].page);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 0.1,
                      height: (ResponsiveLayout.isComputer(context) ||
                              ResponsiveLayout.isLargeTablet(context))
                          ? 8
                          : 16,
                    )
                  ],
                )),
        Column(
          children: [
            GFListTile(
              avatar: Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Do you want to Log out from this application?',
                        style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      content: const Text('We hate to see you leave...'),
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shadowColor: Colors.transparent),
                            onPressed: () {
                              _signOut(context);
                            },
                            child: Text('Yes')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue.shade500,
                                shadowColor: Colors.transparent),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No')),
                      ],
                    );
                  },
                );
              },
              padding: EdgeInsets.zero,
            ),
            const Divider(
              color: Colors.white,
              thickness: 0.1,
            )
          ],
        )
      ],
    ));
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences sharedPrefernce = await _prefs;
      await NetworkUtils.logoutUser(context, sharedPrefernce);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => RootPage()),
        ModalRoute.withName('/'),
      );
    } catch (e) {
      //print(e);
    }
  }
}
