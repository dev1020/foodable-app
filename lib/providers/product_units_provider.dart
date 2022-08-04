import 'package:flutter/material.dart';
import 'package:foodable/models/product_unit_model.dart';
import 'package:foodable/utils/network_utils.dart';

class ProductUnitsProvider extends ChangeNotifier {
  List<ProductUnitsModel> productUnitsList = [];

  getProductUnitsList() async {
    var responseJson = await NetworkUtils.fetchProductUnits();
    for (int i = 0; i < responseJson.length; i++) {
      var units = ProductUnitsModel.fromJson(responseJson[i]);
      //print(units.unitLabel);
      productUnitsList.add(units);
    }
    notifyListeners();
  }
}
