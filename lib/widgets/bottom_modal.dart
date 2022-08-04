import 'package:flutter/material.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/pages/create_order_form.dart';

class Modal {
  var createOrder = CreateOrderForm();

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        //print(MediaQuery.of(context).size.width);
        return Container(
          padding: (ResponsiveLayout.isComputer(context) ||
                  ResponsiveLayout.isLargeTablet(context))
              ? EdgeInsets.symmetric(horizontal: 300)
              : EdgeInsets.all(5),
          child: Container(
            height: MediaQuery.of(context).size.height - 80,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Positioned(
                  top: MediaQuery.of(context).size.height / 25,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: (ResponsiveLayout.isComputer(context) ||
                            ResponsiveLayout.isLargeTablet(context))
                        ? MediaQuery.of(context).size.width - 600
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(175, 30),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 70),
                  child: createOrder,
                ),
                Positioned(
                  top: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
