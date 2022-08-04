//import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:foodable/providers/categories_provider.dart';
import 'package:foodable/providers/product_units_provider.dart';
import 'package:foodable/widgets/animated_loader.dart';
//import 'package:foodable/widgets/loader_path.dart';
//import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

//import 'package:google_fonts/google_fonts.dart';

class DashboardLarge extends StatefulWidget {
  DashboardLarge({Key? key}) : super(key: key);

  @override
  State<DashboardLarge> createState() => _DashboardLargeState();
}

class _DashboardLargeState extends State<DashboardLarge> {
  _fetchCategoriesAndUnits() async {
    Provider.of<CategoriesProvider>(context, listen: false).getCategoriesList();
    Provider.of<ProductUnitsProvider>(context, listen: false)
        .getProductUnitsList();
  }

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndUnits();
  }

  final Items item1 = Items(
      title: "Today's Orders",
      subtitle: '250',
      event: '3 Events',
      img: 'assets/images/order.png');

  final Items item4 = Items(
    title: "Today's Sale",
    subtitle: 'Rose favirited your Post',
    event: 'Rs. 20000',
    img: 'assets/images/festival.png',
  );

  final Items item2 = Items(
    title: 'Items',
    subtitle: 'Bocali, Apple',
    event: '56 Items',
    img: 'assets/images/products.png',
  );

  final Items item3 = Items(
    title: 'Categories',
    subtitle: 'Lucy Mao going to Office',
    event: '47',
    img: 'assets/images/map.png',
  );

  final Items item5 = Items(
    title: 'Monthly Order',
    subtitle: 'Homework, Design',
    event: '3000',
    img: 'assets/images/todo.png',
  );

  final Items item6 = Items(
    title: 'Monthly Sale',
    subtitle: '',
    event: 'Rs 150000',
    img: 'assets/images/setting.png',
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item4,
      item5,
      item6,
      item3,
      item2,
    ];
    var color = 0xff453658;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 550,
            child: GridView.count(
              //physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              padding: EdgeInsets.all(20),
              crossAxisCount: 4,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              children: myList.map((data) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(data.img, width: 50),
                      SizedBox(height: 10),
                      Text(
                        data.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        data.event,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: double.maxFinite,
                          color: Colors.white54,
                          height: 25,
                          child: ElevatedButton(
                            child: Text('Go To >>'),
                            onPressed: () {},
                          ))
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: 70,
            height: 70,
            // color: Colors.blue,
            child: AnimatedLoader(),
          ),
        ],
      ),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items(
      {required this.title,
      required this.subtitle,
      required this.event,
      required this.img});
}
