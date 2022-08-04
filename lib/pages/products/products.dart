import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/drawer_custom.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/models/product_model.dart';
//import 'package:foodable/pages/products/products_add_edit.dart';
import 'package:foodable/utils/constants.dart';
import 'package:foodable/utils/network_utils.dart';
import 'package:foodable/widgets/foodable_appbar.dart';
import 'package:foodable/widgets/products_card.dart';
//import 'package:page_transition/page_transition.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> {
  List productsList = [];
  int totalNoOfProducts = 0;
  int pageNo = 1;
  bool isLoadMore = false;
  bool isDeleting = false;
  late ScrollController controller;
  var searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //late ProductsModel? newproduct;
  double dismissibleContainerHeight = 100;

  fetchAndStoreProducts() async {
    var responseJson = await NetworkUtils.getAllProducts(pageNo);
    //var responseJsonProducts = responseJson.body;
    var allProducts = json.decode(responseJson.body);

    var headerData = responseJson.headers;
    var noOfProducts = int.parse(headerData['x-pagination-total-count']);

    productsList = [];
    for (int i = 0; i < allProducts.length; i++) {
      var product = ProductsModel.fromJson(allProducts[i]);
      productsList.add(product);
    }
    if (mounted) {
      setState(() {
        productsList = productsList;
        totalNoOfProducts = noOfProducts;
      });
    }
  }

  loadMoreProducts() async {
    if (controller.position.pixels == controller.position.maxScrollExtent &&
        (totalNoOfProducts / 20).ceil() > pageNo) {
      //print('loadmore');
      setState(() {
        isLoadMore = true;
      });
      pageNo = pageNo + 1;
      // print(pageNo);
      var responseJson = await NetworkUtils.getAllProducts(pageNo);
      var allProducts = json.decode(responseJson.body);

      if (allProducts.isNotEmpty) {
        for (int i = 0; i < allProducts.length; i++) {
          var product = ProductsModel.fromJson(allProducts[i]);
          productsList.add(product);
        }
      }
      setState(() {
        isLoadMore = false;
        productsList = productsList;
      });
      //print(productsList.length);
    }
  }

  productCallback(ProductsModel? product) {
    var index = productsList.indexWhere(
        (element) => element.configProductId == product?.configProductId);
    if (index != -1) {
      setState(() {
        productsList[index] = product;
      });
    } else {
      setState(() {
        productsList.insert(0, product);
        totalNoOfProducts = totalNoOfProducts + 1;
      });
    }
  }

  productDelete(ProductsModel product) async {
    var response = await NetworkUtils.deleteProduct(
        configproductid: product.configProductId);
    if (response.statusCode == 200) {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndStoreProducts();

    controller = ScrollController()..addListener(loadMoreProducts);
  }

  @override
  void dispose() {
    controller.removeListener(loadMoreProducts);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isComputer(context) ||
        ResponsiveLayout.isLargeTablet(context)) {
      dismissibleContainerHeight = 70;
    }
    return Scaffold(
      backgroundColor: Color(0xffcee6ff),
      appBar: ResponsiveLayout.isTinyLimit(context) ||
              ResponsiveLayout.isTinyHeightLimit(context)
          ? Container()
          : FoodableAppbar('Dashboard'),
      body: ResponsiveLayout(
        tiny: Container(),
        phone: buildProductPage(),
        tablet: buildProductPage(),
        largeTablet: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: buildProductPage()),
          ],
        ),
        computer: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: buildProductPage()),
          ],
        ),
      ),
      drawer: DrawerPage(),
    );
  }

  buildProductPage() {
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
                      '$totalNoOfProducts Products',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange, padding: EdgeInsets.all(0)),
                      onPressed: () async {
                        ProductsModel? newProduct = await Navigator.pushNamed(
                            context, '/productaddedit') as ProductsModel?;
                        if (newProduct != null) {
                          productCallback(newProduct);
                        }
                      },
                      child: Text('Add'),
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
                                  hintText: 'Search The Items',
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
          child: productsList.isNotEmpty
              ? ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: EdgeInsets.fromLTRB(3, 2, 3, 0),
                        height: dismissibleContainerHeight,
                        width: double.maxFinite,
                        child: Dismissible(
                            dismissThresholds: {
                              DismissDirection.endToStart: 0.8
                            },
                            //crossAxisEndOffset: -1,
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (DismissDirection direction) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Warning !',
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Color(0xffb71c1c)),
                                    ),
                                    content: const Text(
                                        'Are you sure you wish to delete this item?',
                                        style: TextStyle(fontSize: 19)),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red.shade700,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5)),
                                          onPressed: () => {
                                                Navigator.of(context).pop(true),
                                              },
                                          child: Container(
                                            width: 60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FaIcon(
                                                  Icons.delete,
                                                  size: 12,
                                                ),
                                                Text('Delete')
                                              ],
                                            ),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue.shade700,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5)),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Container(
                                            width: 60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.timesCircle,
                                                  size: 12,
                                                ),
                                                Text('Cancel')
                                              ],
                                            ),
                                          )),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) async {
                              var product = productsList[index];
                              var result =
                                  await productDelete(productsList[index]);
                              if (result) {
                                productsList.removeAt(index);
                                setState(() {
                                  productsList = productsList;
                                  totalNoOfProducts = totalNoOfProducts - 1;
                                });
                                if (!mounted) {
                                  return;
                                }
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  content: Text(
                                      'Product ${product.productName} Deleted'),
                                ));
                              }
                            },
                            key: UniqueKey(),
                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Swipe Left To Delete',
                                      style: TextStyle(color: Colors.white)),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            child: ProductsCardWidget(
                              product: productsList[index],
                              editedproductfunction: productCallback,
                            )));
                  })
              : Center(
                  child: CircularProgressIndicator(
                  color: Constants.darkRed,
                )),
        ),
        if (isLoadMore == true)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Center(
              child: CircularProgressIndicator(
                color: Constants.darkRed,
              ),
            ),
          ),
      ],
    );
  }
}
