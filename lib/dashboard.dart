import 'package:flutter/material.dart';
import 'package:foodable/drawer_custom.dart';
import 'package:foodable/layout/panel-center/panel_center.dart';
import 'package:foodable/layout/panel-left/panel_left.dart';
import 'package:foodable/layout/panel_right/panel_right.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/pages/dashboard/dashboard_large.dart';
import 'package:foodable/pages/dashboard/dashboard_mobile.dart';
import 'package:foodable/widgets/foodable_appbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 40),
        child: ResponsiveLayout.isTinyLimit(context) ||
                ResponsiveLayout.isTinyHeightLimit(context)
            ? Container()
            : FoodableAppbar('Dashboard'),
      ),
      body: ResponsiveLayout(
        tiny: Container(),
        phone: DashboardMobile(),
        tablet: DashboardMobile(),
        largeTablet: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: DashboardLarge()),
          ],
        ),
        computer: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: DashboardLarge()),
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
