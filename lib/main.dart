import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodable/dashboard.dart';
import 'package:foodable/pages/categories/categories.dart';
import 'package:foodable/pages/categories/categories_add_edit.dart';
import 'package:foodable/pages/pos/generate_bill.dart';
import 'package:foodable/pages/products/products.dart';
import 'package:foodable/pages/products/products_add_edit.dart';
import 'package:foodable/pages/sales/sales.dart';
import 'package:foodable/pospage.dart';
import 'package:foodable/providers/categories_provider.dart';
//import 'package:foodable/providers/order_provider.dart';
import 'package:foodable/providers/pos_provider.dart';
import 'package:foodable/providers/product_units_provider.dart';
import 'package:foodable/root.dart';
import 'package:form_builder_validators/localization/l10n.dart';
//import 'package:hive/hive.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:foodable/utils/constants.dart';

import 'package:oktoast/oktoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

//import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //await Hive.initFlutter();

  runApp(
    // You can wrap multiple providers
    MultiProvider(
      providers: [
        //ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
        ChangeNotifierProvider<CategoriesProvider>(
            create: (_) => CategoriesProvider()),
        ChangeNotifierProvider<ProductUnitsProvider>(
            create: (_) => ProductUnitsProvider()),
        ChangeNotifierProvider<PosProvider>(create: (_) => PosProvider())
      ],
      child: Foodable(),
    ),
  );
  doWhenWindowReady(() {
    final initialSize = Size(1000, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Foodable Pos';
    appWindow.show();
  });
}

class Foodable extends StatefulWidget {
  const Foodable({Key? key}) : super(key: key);

  @override
  FoodableState createState() => FoodableState();
}

class FoodableState extends State<Foodable> {
  //late int _userId;

  @override
  void initState() {
    super.initState();
    //_fetchSharedPreffernces();
  }

  // _fetchSharedPreffernces() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     this._userId = (prefs.getInt('userId'))!;
  //     print(_userId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(milliseconds: 500);
    if (Platform.isWindows) {
      duration = Duration(milliseconds: 10);
    }
    return OKToast(
      child: MaterialApp(
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Foodable Pos',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
          canvasColor: Color(0xff003366),
          highlightColor: Colors.black,
        ),
        // routes: {
        //   // When navigating to the "/" route, build the FirstScreen widget.
        //   '/': (context) => RootPage(),
        //   '/home': (context) => Dashboard(),
        //   //'/pos': (context) => SecondScreen(),
        //   //'/orders': (context) => SalesScreen(),
        //   '/products': (context) => ProductsScreen(),
        //   // When navigating to the "/second" route, build the SecondScreen widget.
        // },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return PageTransition(
                child: RootPage(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/home':
              return PageTransition(
                child: Dashboard(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/pos':
              return PageTransition(
                child: SecondScreen(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/orders':
              return PageTransition(
                child: SalesScreen(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/products':
              return PageTransition(
                child: ProductsScreen(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/productaddedit':
              return PageTransition(
                child: ProductsAddEditPage(
                    //product: null,
                    ),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/categories':
              return PageTransition(
                child: CategoriesScreen(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/categoriesaddedit':
              return PageTransition(
                child: CategoriesAddEditPage(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            case '/generatebill':
              return PageTransition(
                child: GenerateBill(),
                type: PageTransitionType.rightToLeft,
                settings: settings,
                duration: duration,
                reverseDuration: duration,
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
