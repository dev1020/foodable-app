//import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/drawer_custom.dart';
import 'package:foodable/layout/responsive_layout.dart';
//import 'package:foodable/models/category_model.dart';
import 'package:foodable/models/order_model.dart';
import 'package:foodable/providers/pos_provider.dart';
import 'package:foodable/utils/network_utils.dart';
import 'package:foodable/widgets/animated_loader.dart';
import 'package:foodable/widgets/custom_divider.dart';
import 'package:foodable/widgets/foodable_appbar.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  SalesScreenState createState() => SalesScreenState();
}

class SalesScreenState extends State<SalesScreen> {
  List salesList = [];
  int totalNoOfsales = 0;
  int pageNo = 1;
  bool isLoadMore = false;
  late ScrollController controller;
  var searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final tableFooterLabelStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  fetchCategories() async {
    var responseJson = await NetworkUtils.getSalesList(pageNo);
    var allSales = json.decode(responseJson.body);

    var headerData = responseJson.headers;
    var noOfCategories = int.parse(headerData['x-pagination-total-count']);

    salesList = [];
    for (int i = 0; i < allSales.length; i++) {
      var product = OrderModel.fromJson(allSales[i]);
      salesList.add(product);
    }
    if (mounted) {
      setState(() {
        salesList = salesList;
        totalNoOfsales = noOfCategories;
      });
    }
  }

  loadMoreSales() async {
    if (controller.position.pixels == controller.position.maxScrollExtent &&
        (totalNoOfsales / 20).ceil() > pageNo) {
      //print('loadmore');
      setState(() {
        isLoadMore = true;
      });
      pageNo = pageNo + 1;
      // print(pageNo);
      var responseJson = await NetworkUtils.getSalesList(pageNo);
      var allSales = json.decode(responseJson.body);

      if (allSales.isNotEmpty) {
        for (int i = 0; i < allSales.length; i++) {
          var product = OrderModel.fromJson(allSales[i]);
          salesList.add(product);
        }
      }
      setState(() {
        isLoadMore = false;
        salesList = salesList;
      });
      //print(productsList.length);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();

    controller = ScrollController()..addListener(loadMoreSales);
  }

  @override
  void dispose() {
    controller.removeListener(loadMoreSales);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcee6ff),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 40),
        child: ResponsiveLayout.isTinyLimit(context) ||
                ResponsiveLayout.isTinyHeightLimit(context)
            ? Container()
            : FoodableAppbar('Sales'),
      ),
      body: ResponsiveLayout(
        tiny: Container(),
        phone: buildSalesPage(),
        tablet: buildSalesPage(),
        largeTablet: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: buildSalesPage()),
          ],
        ),
        computer: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: buildSalesPage()),
          ],
        ),
      ),
      drawer: DrawerPage(),
    );
  }

  SalesWidget(OrderModel order, index) {
    Color badgeColor = Colors.green.shade600;

    if (order.saleStatus == 'invoiced') {
      badgeColor = Colors.blue.shade800;
    }
    if (order.saleStatus == 'cancelled') {
      badgeColor = Colors.red;
    }
    return Card(
      child: ExpansionTile(
        collapsedBackgroundColor: Color(0xffe0e0e0),
        backgroundColor: Color(0xffc0c0c0),
        textColor: Colors.black,
        //maintainState: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              order.saleNo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.rupeeSign,
                  size: 14,
                ),
                Text(
                  order.totalAmount.toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: badgeColor,
              ),
              child: Text(
                order.saleStatus,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12),
              ),
            ),
            Text('Pay By-${order.payType}')
          ],
        ),

        children: <Widget>[
          CustomDivider(
            height: 2,
            color: Color(0xff121212),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                //color: Color(0xfff0f0f0),
                ),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: DataTable(
                headingRowHeight: 30,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) {
                    return Colors.black;
                  },
                ),
                headingTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                horizontalMargin: 10,
                columnSpacing: 10,
                dataRowHeight: 40,
                columns: <DataColumn>[
                  DataColumn(
                    label: Container(
                      width: 140,
                      child: Text(
                        'Item',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 30,
                      child: Text(
                        'Qty.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      flex: 1,
                      child: Text(
                        'Price',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      flex: 2,
                      child: Text(
                        'Total',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: []),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DataTable(
              headingRowHeight: 0.0,
              horizontalMargin: 10,
              columnSpacing: 10,
              dataRowHeight: 40,
              dataRowColor: MaterialStateColor.resolveWith(
                (states) {
                  return Colors.white;
                },
              ),
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(''),
                  ),
                ),
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(
                  label: Text(''),
                ),
              ],
              rows: order.orderDetails
                  .map(
                    (element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Container(
                          width: 150,
                          child: Text(
                            element.getProductName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(fontSize: 13),
                          ),
                        )),
                        DataCell(Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: 30,
                                child: Text('${element.getProductQuantity}')),
                          ],
                        )),
                        DataCell(Text(
                          element.getPrice.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                        )),
                        DataCell(Text(
                          element.getAmount.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.red.shade500,
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  )
                  .toList(),
              // Loops through dataColumnText, each iteration assigning the value to element
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xffa0a0a0),
              //borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Text(
                    'Subtotal',
                    style: tableFooterLabelStyle,
                    textAlign: TextAlign.right,
                  )),
              Expanded(
                child: Text(
                  order.subTotal.toStringAsFixed(2),
                  style: tableFooterLabelStyle,
                  textAlign: TextAlign.right,
                ),
              )
            ]),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xffa0a0a0),
              //borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Text(
                    'Discount %-${order.discountPercent}',
                    style: tableFooterLabelStyle,
                    textAlign: TextAlign.right,
                  )),
              Expanded(
                child: Text(
                  order.discountTotal.toStringAsFixed(2),
                  style: tableFooterLabelStyle,
                  textAlign: TextAlign.right,
                ),
              )
            ]),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xff000000),
              //borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Text(
                    'Total ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.right,
                  )),
              Expanded(
                child: Text(
                  order.totalAmount.toStringAsFixed(2),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              )
            ]),
          ),
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue.shade800,
                      shadowColor: Colors.transparent),
                  onPressed: order.saleStatus == 'invoiced' ? () {} : null,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade800,
                      shadowColor: Colors.transparent),
                  onPressed: order.saleStatus == 'draft'
                      ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Load this order',
                                  style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                    'Would you like to load this order to Pos panel?'),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          shadowColor: Colors.transparent),
                                      onPressed: () {
                                        Provider.of<PosProvider>(context,
                                                listen: false)
                                            .loadOrder(order);
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context, '/pos');
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
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.spinner,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Load',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSalesPage() {
    return Column(
      children: [
        Container(
          height: 90,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20.0)),
                  color: Color(0xff003366),
                ),
                height: 70,
              ),
              Positioned(
                  left: 20,
                  right: 20,
                  top: 0,
                  child: ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.boxes,
                      color: Colors.white,
                    ),
                    title: Text(
                      '$totalNoOfsales Sales Order',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Positioned(
                top: 42,
                left: 10,
                right: 10,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 35,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Icon(
                            Icons.search,
                            color: Colors.red.shade800,
                          ),
                        ),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextField(
                              controller: searchController,
                              maxLength: 25,
                              decoration: InputDecoration(
                                  hintText: 'Search Sales',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  //contentPadding: EdgeInsets.fromLTRB(0, 5, 10, 15),
                                  border: InputBorder.none,
                                  counterText: '',
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Icon(
                            FontAwesomeIcons.solidTimesCircle,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        Container(color: Colors.white, height: 30, child: Row()),
        Expanded(
          child: salesList.isNotEmpty
              ? ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  itemCount: salesList.length,
                  itemBuilder: (context, index) {
                    return SalesWidget(salesList[index], index);
                  })
              : Center(child: AnimatedLoader()),
        ),
        if (isLoadMore == true)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Center(
              child: AnimatedLoader(),
            ),
          ),
      ],
    );
  }
}
