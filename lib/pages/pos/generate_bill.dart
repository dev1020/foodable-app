import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/drawer_custom.dart';
import 'package:foodable/layout/panel-left/pos_panel_left_lg.dart';
import 'package:foodable/layout/responsive_layout.dart';
//import 'package:foodable/providers/order_provider.dart';
import 'package:foodable/providers/pos_provider.dart';
import 'package:foodable/widgets/custom_divider.dart';
import 'package:foodable/widgets/item_listtable.dart';
import 'package:provider/provider.dart';

class GenerateBill extends StatefulWidget {
  const GenerateBill({Key? key}) : super(key: key);

  @override
  GenerateBillState createState() => GenerateBillState();
}

class GenerateBillState extends State<GenerateBill> {
  _generateBill() async {
    Provider.of<PosProvider>(context, listen: false).generateBill();
  }

  ScrollController _generateBillScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffcee6ff),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 40),
        child: ResponsiveLayout.isComputer(context) ||
                ResponsiveLayout.isLargeTablet(context)
            ? AppBar(
                backgroundColor: (Platform.isWindows)
                    ? Color(0xff5D0FD3)
                    : Color(0xff003366),
                title: Text('Generate Bill'),
                centerTitle: true,
                actions: (Platform.isWindows)
                    ? [
                        MinimizeWindowButton(),
                        MaximizeWindowButton(),
                        CloseWindowButton()
                      ]
                    : [],
              )
            : Container(),
      ),
      body: ResponsiveLayout(
        tiny: Container(),
        phone: buildGenarateBill(),
        tablet: buildGenarateBill(),
        largeTablet: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 5, child: PosPanelLeftLgPage()),
            Expanded(flex: 5, child: buildGenarateBill()),
          ],
        ),
        computer: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 5, child: PosPanelLeftLgPage()),
            Expanded(flex: 5, child: buildGenarateBill()),
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
                    'Generate Bill',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Text('Genarate Bill');
  }

  buildGenarateBill() {
    return SingleChildScrollView(
      controller: _generateBillScrollController,
      child: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/bgpart2.jpg'),
          //   fit: BoxFit.cover,
          // ),
          color: Color(0xffcee6ff),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5),
            Text(
              'Generate Bill',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            CustomDivider(
              height: 2,
              color: Color(0xff121212),
            ),
            SizedBox(height: 5),
            if (Provider.of<PosProvider>(context, listen: false).saleNo ==
                '') ...[
              AlertDialog(
                title: Text(
                  'No order is found',
                  style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                content: const Text('Please swipe left to create an order'),
                actions: [],
              )
            ],
            if (Provider.of<PosProvider>(context, listen: false).saleNo != '' &&
                Provider.of<PosProvider>(context, listen: false)
                    .orderDetailsList
                    .isNotEmpty) ...[
              ItemListTable(),
              CustomDivider(
                height: 2,
                color: Color(0xff121212),
              ),
              SizedBox(
                height: 5,
              ),
              Consumer<PosProvider>(builder: (context, PosProvider, child) {
                String sale_status = PosProvider.saleStatus;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade800,
                            shadowColor: Colors.transparent),
                        onPressed: sale_status == 'draft'
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Confirm this order',
                                        style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: const Text(
                                          'Would you like to generate bill of this live order?'),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                shadowColor:
                                                    Colors.transparent),
                                            onPressed: () {
                                              _generateBill();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Yes')),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue.shade500,
                                                shadowColor:
                                                    Colors.transparent),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('No')),
                                      ],
                                    );
                                  },
                                );
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.checkDouble,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Confirm Order  ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue.shade800,
                            shadowColor: Colors.transparent),
                        onPressed: sale_status == 'invoiced' ? () {} : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.print,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Print ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
            if (Provider.of<PosProvider>(context, listen: false).saleNo != '' &&
                Provider.of<PosProvider>(context, listen: false)
                    .orderDetailsList
                    .isEmpty) ...[
              AlertDialog(
                title: Text(
                  'No items in the order',
                  style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                content: const Text('Please add items to the order'),
                actions: [],
              )
            ]
          ],
        ),
      ),
    );
  }
}
