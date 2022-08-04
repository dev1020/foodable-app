import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/models/product_model.dart';

class ProductsCardWidget extends StatefulWidget {
  ProductsCardWidget(
      {Key? key, required this.product, required this.editedproductfunction})
      : super(key: key);
  ProductsModel product;
  late Function(ProductsModel) editedproductfunction;
  @override
  State<ProductsCardWidget> createState() => _ProductsCardWidgetState();
}

class _ProductsCardWidgetState extends State<ProductsCardWidget> {
  double containerHeight = 60;
  double productTextSize = 20;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isComputer(context) ||
        ResponsiveLayout.isLargeTablet(context)) {
      containerHeight = 30;
      productTextSize = 16;
    }
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    height: containerHeight,
                    child: Image(
                      image: AssetImage('assets/no-image.png'),
                      fit: BoxFit.cover,
                      // color:Colors.black87,
                      // colorBlendMode: BlendMode.darken,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 25,
                      color: Color(0xffff0000),
                      width: double.infinity,
                      child: Text(
                        widget.product.unitShortForm,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: containerHeight,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '${widget.product.productName}-${widget.product.productSku}',
                        style: TextStyle(
                            fontSize: productTextSize,
                            fontWeight: (ResponsiveLayout.isComputer(context) ||
                                    ResponsiveLayout.isLargeTablet(context))
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: Color(0xff472406)),
                        maxLines: 3,
                        textAlign: (ResponsiveLayout.isComputer(context) ||
                                ResponsiveLayout.isLargeTablet(context))
                            ? TextAlign.left
                            : TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 25,
                        color: Color(0xffcccccc),
                        width: double.infinity,
                        child: Text(
                          widget.product.categoryName,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            fontWeight: (ResponsiveLayout.isComputer(context) ||
                                    ResponsiveLayout.isLargeTablet(context))
                                ? FontWeight.bold
                                : FontWeight.w400,
                          ),
                          textAlign: (ResponsiveLayout.isComputer(context) ||
                                  ResponsiveLayout.isLargeTablet(context))
                              ? TextAlign.right
                              : TextAlign.center,
                        ),
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Expanded(
                      //   //height: 27,
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           primary: Color(0xff236bb2),
                      //           padding: EdgeInsets.symmetric(horizontal: 5)),
                      //       onPressed: () {},
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           FaIcon(
                      //             FontAwesomeIcons.solidEye,
                      //             size: 12,
                      //           ),
                      //           Text('View')
                      //         ],
                      //       )),
                      // ),
                      // SizedBox(height: 2),
                      Expanded(
                        //height: 27,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green.shade700,
                                padding: EdgeInsets.symmetric(horizontal: 5)),

                            //waiting for the edit screen to send updated result
                            onPressed: () async {
                              ProductsModel? editedProduct =
                                  await Navigator.pushNamed(
                                          context, '/productaddedit',
                                          arguments: widget.product)
                                      as ProductsModel?;
                              // Send the updated product back to parent via callback
                              if (editedProduct != null) {
                                widget.editedproductfunction(editedProduct);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.edit,
                                  size: 12,
                                ),
                                Text('Edit')
                              ],
                            )),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
