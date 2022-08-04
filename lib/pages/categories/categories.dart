//import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodable/drawer_custom.dart';
import 'package:foodable/layout/responsive_layout.dart';
import 'package:foodable/models/category_model.dart';
import 'package:foodable/providers/categories_provider.dart';
import 'package:foodable/utils/constants.dart';
import 'package:foodable/utils/network_utils.dart';
import 'package:foodable/widgets/animated_loader.dart';
import 'package:foodable/widgets/foodable_appbar.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  List categoriesList = [];
  int totalNoOfcategories = 0;
  int pageNo = 1;
  bool isLoadMore = false;
  late ScrollController controller;
  var searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //late ProductsModel? newproduct;

  fetchCategories() async {
    var responseJson = await NetworkUtils.getCategories(pageNo);
    var allCategories = json.decode(responseJson.body);

    var headerData = responseJson.headers;
    var noOfCategories = int.parse(headerData['x-pagination-total-count']);

    categoriesList = [];
    for (int i = 0; i < allCategories.length; i++) {
      var product = CategoriesModel.fromJson(allCategories[i]);
      categoriesList.add(product);
    }
    if (mounted) {
      setState(() {
        categoriesList = categoriesList;
        totalNoOfcategories = noOfCategories;
      });
    }
  }

  loadMoreCategories() async {
    if (controller.position.pixels == controller.position.maxScrollExtent &&
        (totalNoOfcategories / 20).ceil() > pageNo) {
      //print('loadmore');
      setState(() {
        isLoadMore = true;
      });
      pageNo = pageNo + 1;
      // print(pageNo);
      var responseJson = await NetworkUtils.getCategories(pageNo);
      var allProducts = json.decode(responseJson.body);

      if (allProducts.isNotEmpty) {
        for (int i = 0; i < allProducts.length; i++) {
          var product = CategoriesModel.fromJson(allProducts[i]);
          categoriesList.add(product);
        }
      }
      setState(() {
        isLoadMore = false;
        categoriesList = categoriesList;
      });
      //print(productsList.length);
    }
  }

  categoryCallback(CategoriesModel? category) async {
    //print('callback called');
    var index = categoriesList
        .indexWhere((element) => element.categoryId == category?.categoryId);
    if (index != -1) {
      setState(() {
        categoriesList[index] = category;
      });
    } else {
      setState(() {
        categoriesList.insert(0, category);
        totalNoOfcategories = totalNoOfcategories + 1;
      });
    }
    Provider.of<CategoriesProvider>(context, listen: false).getCategoriesList();
  }

  categoryDelete(CategoriesModel category) async {
    var response =
        await NetworkUtils.deleteCategory(categoryid: category.categoryId);

    if (response.statusCode == 200 || response.statusCode == 204) {
      // ignore: use_build_context_synchronously
      Provider.of<CategoriesProvider>(context, listen: false)
          .getCategoriesList();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();

    controller = ScrollController()..addListener(loadMoreCategories);
  }

  @override
  void dispose() {
    controller.removeListener(loadMoreCategories);
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
            : FoodableAppbar('Categories'),
      ),
      body: ResponsiveLayout(
        tiny: Container(),
        phone: buildCategoryPage(),
        tablet: buildCategoryPage(),
        largeTablet: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: buildCategoryPage()),
          ],
        ),
        computer: Row(
          children: [
            Expanded(
              flex: 3,
              child: DrawerPage(),
            ),
            Expanded(flex: 10, child: buildCategoryPage()),
          ],
        ),
      ),
      drawer: DrawerPage(),
    );
  }

  CategoryWidget(category) {
    return Card(
      margin: EdgeInsets.only(bottom: 2, left: 3, right: 3, top: 2),
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '${category.categoryName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                )),
            Expanded(
              //height: 27,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 5)),

                    //waiting for the edit screen to send updated result
                    onPressed: () async {
                      CategoriesModel? editedCategory =
                          await Navigator.pushNamed(
                              context, '/categoriesaddedit',
                              arguments: category) as CategoriesModel?;
                      //Send the updated product back to parent via callback
                      if (editedCategory != null) {
                        categoryCallback(editedCategory);
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
            ),
          ],
        ),
      ),
    );
  }

  buildCategoryPage() {
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
                      '$totalNoOfcategories Categories',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange, padding: EdgeInsets.all(0)),
                      onPressed: () async {
                        CategoriesModel? category = await Navigator.pushNamed(
                            context, '/categoriesaddedit') as CategoriesModel?;
                        if (category != null) {
                          categoryCallback(category);
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
                                  hintText: 'Search Categories',
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
          child: categoriesList.isNotEmpty
              ? ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  controller: controller,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: EdgeInsets.fromLTRB(3, 2, 3, 0),
                        height: 50,
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
                                    title: Text(
                                      (categoriesList[index].productsCount > 0)
                                          ? 'Warning ! ${categoriesList[index].productsCount} products associated'
                                          : 'Warning !',
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Color(0xffb71c1c)),
                                    ),
                                    content: Text(
                                        'Are you sure you wish to delete this category?'),
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
                              var category = categoriesList[index];
                              var result =
                                  await categoryDelete(categoriesList[index]);
                              if (result) {
                                categoriesList.removeAt(index);
                                setState(() {
                                  categoriesList = categoriesList;
                                  totalNoOfcategories = totalNoOfcategories - 1;
                                });
                                if (!mounted) {
                                  return;
                                }
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  content: Text(
                                    'Category ${category.categoryName} Deleted',
                                    textAlign: TextAlign.center,
                                  ),
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
                            // child: ProductsCardWidget(
                            //   product: productsList[index],
                            //   editedproductfunction: productCallback,
                            // )
                            child: CategoryWidget(categoriesList[index])));
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
