//import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/providers/pos_provider.dart';
import 'package:foodable/widgets/bottom_modal.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../pages/create_order_form.dart';
//import '../../providers/order_provider.dart';
//import '../../widgets/bottom_modal.dart';

class PanelRightPage extends StatefulWidget {
  const PanelRightPage({Key? key}) : super(key: key);

  @override
  PanelRightPageState createState() => PanelRightPageState();
}

class PanelRightPageState extends State<PanelRightPage> {
  CreateOrderForm createOrder = CreateOrderForm();
  //late Modal modal;
  final dateOrderStyleLabel =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  final dateOrderStyleValue =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  final tableFooterLabelStyle = TextStyle(
      color: Colors.white,
      fontSize: 15,
      letterSpacing: 1,
      fontWeight: FontWeight.bold);
  final now = DateTime.now();
  final tableTextStyle = TextStyle(fontSize: 13);
  ScrollController _posScrollController = ScrollController();
  //Barcode Scanner
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      //print(barcodeScanRes);
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
      // ignore: use_build_context_synchronously
      _addItemsByBarcode(context, barcodeScanRes);
    } on PlatformException catch (e) {
      barcodeScanRes = 'Failed to get platform version.Unknown error: $e';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
  }

  _addItemsByBarcode(context, barcode) async {
    var sale_status =
        Provider.of<PosProvider>(context, listen: false).saleStatus;
    if (sale_status == 'draft') {
      await Provider.of<PosProvider>(context, listen: false)
          .addItemToOrderByBarcode(barcode);
      toastwidget('Item Added');
    } else {
      toastwidget('Item cannot be added');
    }
  }

  _addItems(context, id) {
    var sale_status =
        Provider.of<PosProvider>(context, listen: false).saleStatus;
    if (sale_status == 'draft') {
      Provider.of<PosProvider>(context, listen: false).addItemToOrder(id);
      toastwidget('Item Added');
    } else {
      toastwidget('Item cannot be added');
    }
  }

  _decreaseItem(context, id) {
    var sale_status =
        Provider.of<PosProvider>(context, listen: false).saleStatus;
    if (sale_status == 'draft') {
      Provider.of<PosProvider>(context, listen: false).decreaseItemToOrder(id);
      toastwidget('Item decreased');
    } else {
      toastwidget('Item cannot be decreased');
    }
  }

  _removeItem(context, id) {
    var sale_status =
        Provider.of<PosProvider>(context, listen: false).saleStatus;
    if (sale_status == 'draft') {
      Provider.of<PosProvider>(context, listen: false).removeItemToOrder(id);
      toastwidget('Item Removed');
    } else {
      toastwidget('Item cannot be Removed');
    }
  }

  _cancelOrder() {
    Provider.of<PosProvider>(context, listen: false).cancelOrder();
  }

  toastwidget(String msg) {
    showToastWidget(
      Container(
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
            )),
        width: 200.0,
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box_rounded,
              size: 30.0,
              color: Colors.white,
            ),
            Text(msg),
          ],
        ),
      ),
      duration: const Duration(milliseconds: 3500),
      position: ToastPosition.top,
    );
  }

  @override
  void initState() {
    //modal = Modal(createOrder);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffcee6ff),
      body: Container(
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
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          'Date-',
                          style: dateOrderStyleLabel,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(DateFormat('d-M-y').format(now),
                            style: dateOrderStyleValue,
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue, shadowColor: Colors.transparent),
                    onPressed: () {
                      var sale_status =
                          Provider.of<PosProvider>(context, listen: false)
                              .saleStatus;
                      if (sale_status == 'draft') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Warning',
                                style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                  'Please cancel or complete this live order?'),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue.shade500,
                                        shadowColor: Colors.transparent),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok')),
                              ],
                            );
                          },
                        );
                      } else {
                        // showMaterialModalBottomSheet(
                        //   context: context,
                        //   builder: (context) => SingleChildScrollView(
                        //     controller: ModalScrollController.of(context),
                        //     child:
                        //         CreateOrderForm(),
                        //   ),
                        // );
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            constraints: BoxConstraints(
                              maxWidth: 600,
                              maxHeight: (ResponsiveLayout.isComputer(
                                          context) ||
                                      ResponsiveLayout.isLargeTablet(context))
                                  ? MediaQuery.of(context).size.height * 0.8
                                  : MediaQuery.of(context).size.height * 0.8,
                            ),
                            builder: (context) => SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: CreateOrderForm(),
                                ));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'New Order  ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Color(0xff777777)),
            Consumer<PosProvider>(
              builder: (context, PosProvider, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesomeIcons.userAlt, size: 20),
                              Text(
                                ' Customer1 -',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Flexible(
                                child: Text(
                                  PosProvider.customerName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.phoneAlt, size: 20),
                              Text(' '),
                              Text(PosProvider.customerContact)
                            ],
                          ))
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 2,
            ),
            Consumer<PosProvider>(builder: (context, PosProvider, child) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(FontAwesomeIcons.fileInvoice, size: 20),
                            Text(
                              ' Order -',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Flexible(
                              child: Text(
                                PosProvider.saleNo,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(FontAwesomeIcons.infoCircle, size: 20),
                            Text(
                              ' Status - ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Flexible(
                              child: Text(
                                PosProvider.saleStatus.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              );
            }),
            if (Platform.isWindows)
              SizedBox(
                height: 5,
              ),
            //Divider(),
            if (Platform.isAndroid)
              Container(
                //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade700),
                    onPressed: () {
                      //_scan();
                      scanBarcodeNormal();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 2, 5, 10),
                          child: Icon(
                            FontAwesomeIcons.barcode,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Barcode/QrCode Scan',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text('Click here for camera scan',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DataTable(
                  headingRowHeight: 30,
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) {
                      return Color(0xff121212);
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
                        width: 100,
                        child: Text(
                          'Item',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        width: 90,
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
                    DataColumn(
                      label: Expanded(
                        flex: 1,
                        child: Text(
                          'Act',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  rows: []),
            ),
            SizedBox(height: 2),
            Container(
              height: 220,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                controller: _posScrollController,
                child: Consumer<PosProvider>(
                    builder: (context, PosProvider, child) {
                  var getOrderDetailsList = PosProvider.orderDetailsList;
                  return DataTable(
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
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: getOrderDetailsList
                        .map(
                          (element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Container(
                                  width: 110,
                                  child: Text(
                                    element.getProductName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 13),
                                  ))),
                              DataCell(Row(
                                children: [
                                  Container(
                                      height: 25,
                                      width: 25,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              padding: EdgeInsets.all(0)),
                                          onPressed: () {
                                            _decreaseItem(
                                                context, element.getProductId);
                                          },
                                          child: Icon(FontAwesomeIcons.minus,
                                              size: 14))),
                                  Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      child: Text(
                                          '${element.getProductQuantity}')),
                                  Container(
                                      height: 25,
                                      width: 25,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              padding: EdgeInsets.zero),
                                          onPressed: () {
                                            _addItems(
                                                context, element.getProductId);
                                          },
                                          child: Icon(FontAwesomeIcons.plus,
                                              size: 14))),
                                ],
                              )),
                              DataCell(Text(
                                element.getPrice.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                              )),
                              DataCell(Text(
                                element.getAmount.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                              )),
                              DataCell(Container(
                                  height: 25,
                                  width: 25,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          padding: EdgeInsets.all(0)),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Remove this Item',
                                                style: TextStyle(
                                                    color: Colors.red.shade700,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                  'Would you like to remove this item from order?'),
                                              actions: [
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors.red,
                                                            shadowColor: Colors
                                                                .transparent),
                                                    onPressed: () {
                                                      _removeItem(context,
                                                          element.getProductId);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Yes')),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors
                                                                .blue.shade500,
                                                            shadowColor: Colors
                                                                .transparent),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('No')),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(FontAwesomeIcons.times,
                                          size: 14)))),
                            ],
                          ),
                        )
                        .toList(),
                    // Loops through dataColumnText, each iteration assigning the value to element
                  );
                }),
              ),
            ),
            SizedBox(height: 5),
            Consumer<PosProvider>(builder: (context, PosProvider, child) {
              return Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
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
                      PosProvider.subTotal.toStringAsFixed(2),
                      style: tableFooterLabelStyle,
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
              );
            }),
            Consumer<PosProvider>(builder: (context, PosProvider, child) {
              return Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        'TAX ',
                        style: tableFooterLabelStyle,
                        textAlign: TextAlign.right,
                      )),
                  Expanded(
                    child: Text(
                      PosProvider.taxAmount.toStringAsFixed(2),
                      style: tableFooterLabelStyle,
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
              );
            }),

            Consumer<PosProvider>(builder: (context, PosProvider, child) {
              return Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Discount(${PosProvider.discountPercent} %) ',
                        style: tableFooterLabelStyle,
                        textAlign: TextAlign.right,
                      )),
                  Expanded(
                    child: Text(
                      PosProvider.discountTotal.toStringAsFixed(2),
                      style: tableFooterLabelStyle,
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
              );
            }),
            Consumer<PosProvider>(builder: (context, PosProvider, child) {
              return Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Total ',
                        style: tableFooterLabelStyle,
                        textAlign: TextAlign.right,
                      )),
                  Expanded(
                    child: Text(
                      PosProvider.totalAmount.toStringAsFixed(2),
                      style: tableFooterLabelStyle,
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
              );
            }),

            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red, shadowColor: Colors.transparent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Cancel this order',
                              style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                                'Would you like to cancel this live order?'),
                            actions: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shadowColor: Colors.transparent),
                                  onPressed: () {
                                    _cancelOrder();
                                    Navigator.pop(context);
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
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Cancel Order  ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            FontAwesomeIcons.timesCircle,
                            color: Colors.white,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff008000),
                        shadowColor: Colors.transparent),
                    onPressed: () {
                      Navigator.pushNamed(context, '/generatebill');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Generate Bill  ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            FontAwesomeIcons.fileDownload,
                            color: Colors.white,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
