import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:foodable/providers/order_provider.dart';
import 'package:foodable/providers/pos_provider.dart';
import 'package:foodable/utils/constants.dart';
import 'package:oktoast/oktoast.dart';

import 'package:provider/provider.dart';

import 'custom_shape_clipper.dart';

class ItemCardWidget extends StatelessWidget {
  final int id;
  final String name;
  final double price;

  ItemCardWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
  }) : super(key: key);

  _addItems(context, id) async {
    var sale = Provider.of<PosProvider>(context, listen: false).saleStatus;
    var toastMsg = '';
    if (sale == 'draft') {
      Provider.of<PosProvider>(context, listen: false)
          .addItemToOrder(id); //advancedPlayer.play('beep.mp3');
      toastMsg = 'Item Added';
    } else {
      toastMsg = 'Item cannot be added';
    }

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
            Text(toastMsg),
          ],
        ),
      ),
      duration: const Duration(milliseconds: 3500),
      position: ToastPosition.top,
    );
  }

  @override
  Widget build(BuildContext context) {
    //return Card(child: FlutterLogo());
    return Consumer(builder: (context, PosProvider, child) {
      return Container(
        padding: EdgeInsets.all(2),
        //position: DecorationPosition.background,
        decoration: BoxDecoration(
          //border: Border.all(color: Color(0xff023020)),
          borderRadius: BorderRadius.circular(8),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   //stops: [0.0, 1.0],
          //   colors: [Color(0xffffffff), Color(0xffa0a0a0)],
          // ),
          //color: Color(0xffffffff),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color(0xffffffff), //shadowColor: Colors.transparent
              padding: EdgeInsets.all(1)),
          onPressed: () {
            _addItems(context, id);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(name,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 1,
                            color: Color(0xffffffff))),
                  ),
                ),
              ),
              Positioned(
                  bottom: 5,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: FaIcon(
                            FontAwesomeIcons.rupeeSign,
                            size: 14,
                            color: Constants.darkRed,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                            text: price.toString(),
                            style: TextStyle(
                              color: Constants.darkRed,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
