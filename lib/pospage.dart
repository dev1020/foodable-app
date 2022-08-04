import 'package:flutter/material.dart';
import 'package:foodable/layout/panel-left/pos_panel_left_lg.dart';
import 'package:foodable/pos_page_phone.dart';
import 'package:foodable/widgets/foodable_appbar.dart';

import 'drawer_custom.dart';
import 'layout/panel_right/panel_right.dart';
import 'layout/responsive_layout.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 40),
        child: ResponsiveLayout.isTinyLimit(context) ||
                ResponsiveLayout.isTinyHeightLimit(context)
            ? Container()
            : FoodableAppbar('POS'),
      ),
      body: ResponsiveLayout(
        tiny: Container(),
        phone: PosPagePhone(),
        tablet: PosPagePhone(),
        largeTablet: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 5, child: PosPanelLeftLgPage()),
            Expanded(flex: 5, child: PanelRightPage()),
          ],
        ),
        computer: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 5, child: PosPanelLeftLgPage()),
            Expanded(flex: 5, child: PanelRightPage()),
          ],
        ),
      ),
      drawer: ResponsiveLayout.isComputer(context) ||
              ResponsiveLayout.isLargeTablet(context)
          ? null
          : DrawerPage(),
    );
  }
}
