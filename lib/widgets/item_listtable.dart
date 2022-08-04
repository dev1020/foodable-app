// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:foodable/providers/order_provider.dart';
import 'package:foodable/providers/pos_provider.dart';
import 'package:provider/provider.dart';

class ItemListTable extends StatelessWidget {
  ItemListTable({Key? key}) : super(key: key);
  final tableFooterLabelStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );
  ScrollController itemlisttableScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                          Icon(
                            FontAwesomeIcons.userAlt,
                            size: 20,
                            color: Color(0xffa0a0a0),
                          ),
                          Text(
                            ' Customer -',
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
                          Icon(FontAwesomeIcons.phoneAlt,
                              size: 20, color: Color(0xffa0a0a0)),
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
                        Icon(FontAwesomeIcons.fileInvoice,
                            size: 20, color: Color(0xffa0a0a0)),
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
                        Icon(FontAwesomeIcons.infoCircle,
                            size: 20, color: Color(0xffa0a0a0)),
                        Text(
                          ' Status - ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              PosProvider.saleStatus.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          );
        }),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DataTable(
              headingRowHeight: 30,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) {
                  return Color(0xffa0a0a0);
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
        SizedBox(height: 2),
        Container(
          height: 220,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            controller: itemlisttableScrollController,
            child:
                Consumer<PosProvider>(builder: (context, PosProvider, child) {
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
                ],
                rows: getOrderDetailsList
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
              );
            }),
          ),
        ),
        SizedBox(height: 5),
        Consumer<PosProvider>(builder: (context, PosProvider, child) {
          return Container(
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xffa0a0a0),
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
              color: Color(0xffa0a0a0),
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
          double discount = PosProvider.discountPercent;
          String sale_status = PosProvider.saleStatus;
          return Container(
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xffa0a0a0),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Discount(%) ',
                        style: tableFooterLabelStyle,
                        textAlign: TextAlign.right,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: discount == 0
                                  ? BorderSide(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                  : null,
                              primary:
                                  discount == 0 ? Colors.red.shade700 : null,
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: sale_status == 'draft'
                                ? () {
                                    _addDiscount(context, 0);
                                  }
                                : null,
                            child: Text('0%')),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: discount == 10
                                  ? BorderSide(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                  : null,
                              primary:
                                  discount == 10 ? Colors.red.shade700 : null,
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: sale_status == 'draft'
                                ? () {
                                    _addDiscount(context, 10.0);
                                  }
                                : null,
                            child: Text('10%')),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 40, height: 40),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: discount == 20
                                  ? BorderSide(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                  : null,
                              primary:
                                  discount == 20 ? Colors.red.shade700 : null,
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: sale_status == 'draft'
                                ? () {
                                    _addDiscount(context, 20.0);
                                  }
                                : null,
                            child: Text('20%')),
                      )
                    ],
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
              color: Color(0xffa0a0a0),
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
        Consumer<PosProvider>(builder: (context, PosProvider, child) {
          String pay_type = PosProvider.payType;
          String sale_status = PosProvider.saleStatus;
          return Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Pay By ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                        textAlign: TextAlign.right,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              side: pay_type == 'cash'
                                  ? BorderSide(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                  : null,
                              primary: pay_type == 'cash'
                                  ? Colors.red.shade700
                                  : null),
                          onPressed: sale_status == 'draft'
                              ? () {
                                  _addPayType(context, 'cash');
                                }
                              : null,
                          child: Text('Cash')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              side: pay_type == 'card'
                                  ? BorderSide(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                  : null,
                              primary: pay_type == 'card'
                                  ? Colors.red.shade700
                                  : null),
                          onPressed: sale_status == 'draft'
                              ? () {
                                  _addPayType(context, 'card');
                                }
                              : null,
                          child: Text('Card')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              side: pay_type == 'upi'
                                  ? BorderSide(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                  : null,
                              primary: pay_type == 'upi'
                                  ? Colors.red.shade700
                                  : null),
                          onPressed: sale_status == 'draft'
                              ? () {
                                  _addPayType(context, 'upi');
                                }
                              : null,
                          child: Text('Upi'))
                    ],
                  )),
            ]),
          );
        })
      ],
    );
  }

  _addPayType(context, pay_type) async {
    Provider.of<PosProvider>(context, listen: false).addPayType(pay_type);
  }

  _addDiscount(context, double discount) async {
    Provider.of<PosProvider>(context, listen: false)
        .addDiscountToOrder(discount);
  }
}
