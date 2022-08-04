import 'package:flutter/material.dart';
import 'package:foodable/models/category_model.dart';
import 'package:foodable/utils/network_utils.dart';

class CategoriesProvider extends ChangeNotifier {
  List<CategoriesModel> categoriesList = [];
  int _activeCategoryId = 0;
  String _activeCategoryName = '';

  int get activeCategoryId => _activeCategoryId;
  String get activeCategoryName => _activeCategoryName;

  getCategoriesList() async {
    categoriesList = [];
    var responseJson = await NetworkUtils.fetchPosCategories();
    var activeCategory = CategoriesModel.fromJson(responseJson[0]);
    for (int i = 0; i < responseJson.length; i++) {
      var category = CategoriesModel.fromJson(responseJson[i]);
      //print(category.categoryName);
      categoriesList.add(category);
    }
    _activeCategoryId = activeCategory.categoryId;
    //print(_activeCategoryId);
    _activeCategoryName = activeCategory.categoryName;
    notifyListeners();
  }

  setActiveCategory(categoryId) {
    _activeCategoryId = categoryId;
    // print(_activeCategoryId);
    notifyListeners();
  }
}
