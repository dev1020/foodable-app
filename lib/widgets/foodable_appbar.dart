import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var buttonColors = WindowButtonColors(
  iconNormal: Colors.white60,
);
bool automaticallyImplyLeading = true;
FoodableAppbar(String title) {
  List<Widget> actions = [];
  if (Platform.isWindows) {
    actions = [
      MinimizeWindowButton(
        colors: buttonColors,
      ),
      MaximizeWindowButton(
        colors: buttonColors,
      ),
      CloseWindowButton(
        colors: buttonColors,
      )
    ];
    automaticallyImplyLeading = false;
  }
  return PreferredSize(
    preferredSize: Size(double.infinity, 40),
    child: AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor:
          (Platform.isWindows) ? Color(0xff5D0FD3) : Color(0xff003366),
      //background color of Appbar to green
      title: buildAppbarTitle(title),
      actions: actions,
      elevation: 1,
    ),
  );
}

buildAppbarTitle(String title) {
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
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  return Center(
    child: Text(title),
  );
}

custAppbar(title) {
  return WindowTitleBarBox(
    child: Row(
      children: [
        Expanded(
          child: Center(
            child: Text(title),
          ),
        ),
        MinimizeWindowButton(),
        MaximizeWindowButton(),
        CloseWindowButton()
      ],
    ),
  );
}
