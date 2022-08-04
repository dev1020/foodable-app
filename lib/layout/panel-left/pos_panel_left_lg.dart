import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/models/category_model.dart';
import 'package:foodable/models/product_model.dart';
import 'package:foodable/providers/categories_provider.dart';
//import 'package:foodable/providers/order_provider.dart';
import 'package:foodable/utils/constants.dart';
import 'package:foodable/utils/network_utils.dart';
import 'package:foodable/widgets/animated_loader.dart';
import 'package:foodable/widgets/item_card_widget.dart';
import 'package:provider/provider.dart';

final bucketGlobal = PageStorageBucket();

class PosPanelLeftLgPage extends StatefulWidget {
  const PosPanelLeftLgPage({Key? key}) : super(key: key);

  @override
  PosPanelLeftPageLgState createState() => PosPanelLeftPageLgState();
}

class PosPanelLeftPageLgState extends State<PosPanelLeftLgPage> {
  late ScrollController _scrollController = ScrollController();
  late ScrollController _scrollControllerItem = ScrollController();
  List<CategoriesModel> categoriesList = [];
  List<ProductsModel> productsList = [];
  List<ProductsModel> productsListCopy = [];
  List<ProductsModel> searchedProductsList = [];
  bool isloading = false;
  var activeCategoryName = '';

  fetchDefaults() async {
    var categoriesNumber =
        Provider.of<CategoriesProvider>(context, listen: false)
            .categoriesList
            .length;

    if (categoriesNumber == 0) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .getCategoriesList();
    }
    var activeCategoryId =
        Provider.of<CategoriesProvider>(context, listen: false)
            .activeCategoryId;
    var productsData = [];
    if (activeCategoryId != 0) {
      productsData =
          await NetworkUtils.fetchProductsByCategory(activeCategoryId);
    } else {
      productsData = await NetworkUtils.fetchDefaultItems();
    }

    for (int i = 0; i < productsData.length; i++) {
      var product = ProductsModel.fromJson(productsData[i]);
      productsList.add(product);
    }
    if (this.mounted) {
      setState(() {
        productsList = productsList;
        productsListCopy = productsList;
      });
    }
  }

  fetchProductsByCategory(categoryId) async {
    setState(() {
      isloading = true;
    });
    Provider.of<CategoriesProvider>(context, listen: false)
        .setActiveCategory(categoryId);
    var allProductsData =
        await NetworkUtils.fetchProductsByCategory(categoryId);
    productsList = [];
    for (int i = 0; i < allProductsData.length; i++) {
      var product = ProductsModel.fromJson(allProductsData[i]);
      productsList.add(product);
    }
    if (this.mounted) {
      setState(() {
        productsList = productsList;
        productsListCopy = productsList;
        isloading = false;
      });
    }
  }

  fetchSearchedProducts(queryString) async {
    if (queryString.length > 2) {
      setState(() {
        isloading = true;
      });
      var endPoint = 'pos/search/$queryString';
      //print(endPoint);
      var responseJson = await NetworkUtils.fetch(endPoint);
      var responseJsonBody = json.decode(responseJson.body);
      var allProductsData = responseJsonBody['items'];
      searchedProductsList = [];
      for (int i = 0; i < allProductsData.length; i++) {
        var product = ProductsModel.fromJson(allProductsData[i]);

        searchedProductsList.add(product);
      }
      setState(() {
        productsList = searchedProductsList;
        isloading = false;
      });
    } else {
      setState(() {
        productsList = productsListCopy;
      });
    }
  }

  @override
  void initState() {
    fetchDefaults();
    //fetchDefaultPoducts();
    super.initState();
  }

  //int _currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    int _gridviewCount = 0;

    if (ResponsiveLayout.isPhone(context)) {
      _gridviewCount = 3;
    }
    if (ResponsiveLayout.isTablet(context) ||
        ResponsiveLayout.isLargeTablet(context)) {
      _gridviewCount = 3;
    }
    if (ResponsiveLayout.isComputer(context)) {
      _gridviewCount = 4;
    }
    return PageStorage(
      bucket: bucketGlobal,
      child: Scaffold(
          backgroundColor: Color(0xffcee6ff),
          body: Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/bgpart1.jpg'),
              //   fit: BoxFit.cover,
              // ),
              color: Color(0xffcee6ff),
              border: (ResponsiveLayout.isComputer(context) ||
                      ResponsiveLayout.isTablet(context) ||
                      ResponsiveLayout.isLargeTablet(context))
                  ? Border(
                      right: BorderSide(
                        color: Color(0xfff0f0f0),
                        width: 1.5,
                      ),
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            //color: Color(0xfff0f0f0)
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //print('object');
                          },
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    )),
                Divider(color: Color(0xff777777)),
                Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    height: 70.0,
                    child: Consumer<CategoriesProvider>(
                        builder: (context, p, child) {
                      var activeCategoryId = Provider.of<CategoriesProvider>(
                              context,
                              listen: false)
                          .activeCategoryId;
                      //print(activeCategoryId);
                      var categoriesList = Provider.of<CategoriesProvider>(
                              context,
                              listen: false)
                          .categoriesList;
                      if (categoriesList.isNotEmpty) {
                        return Scrollbar(
                          thickness: 4,
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: ListView.builder(
                              key: PageStorageKey<String>('poscategorylist'),
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: categoriesList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Card(
                                      color: Colors.blue,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: categoriesList[index]
                                                      .categoryId ==
                                                  activeCategoryId
                                              ? Constants.darkRed
                                              : Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              categoriesList[index]
                                                  .categoryName,
                                              style: TextStyle(
                                                  color: categoriesList[index]
                                                              .categoryId ==
                                                          activeCategoryId
                                                      ? Colors.white
                                                      : Constants.darkRed,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              '${categoriesList[index].productsCount}',
                                              style: TextStyle(
                                                color: categoriesList[index]
                                                            .categoryId ==
                                                        activeCategoryId
                                                    ? Colors.white
                                                    : Constants.darkRed,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          fetchProductsByCategory(
                                              categoriesList[index].categoryId);
                                          //print(categoriesList[index].getCategoryId);
                                        },
                                      )),
                                );
                              }),
                        );
                      } else {
                        return Center(
                            //   child: CircularProgressIndicator(
                            // color: Constants.purpleDark,)
                            child: AnimatedLoader());
                      }
                    })),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 35,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Icon(
                          Icons.search,
                          color: Colors.red.shade800,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search The Items',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                            //contentPadding: EdgeInsets.fromLTRB(0, 5, 10, 15),
                            border: InputBorder.none,
                          ),
                          onChanged: (String keyword) {
                            fetchSearchedProducts(keyword);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Items',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //color: Color(0xfff0f0f0)
                      ),
                    )),
                Divider(color: Color(0xff777777)),
                Expanded(
                  child: productsList.isNotEmpty
                      ? (isloading != true)
                          ? Scrollbar(
                              isAlwaysShown: true,
                              thickness: 4,
                              controller: _scrollControllerItem,
                              child: GridView.builder(
                                key: PageStorageKey<String>('positemlist'),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                controller: _scrollControllerItem,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 7,
                                        crossAxisCount: _gridviewCount),
                                itemBuilder: (_, index) => ItemCardWidget(
                                    id: productsList[index].configProductId,
                                    name: productsList[index].productName,
                                    price: productsList[index].productPrice),
                                itemCount: productsList.length,
                              ),
                            )
                          : Center(child: AnimatedLoader())
                      : Center(
                          //   child: CircularProgressIndicator(
                          //   color: Constants.purpleDark,
                          // )
                          child: AnimatedLoader()),
                )
              ],
            ),
          )),
    );
  }
}
