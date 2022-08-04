//import 'package:foodable/models/product_model.dart';

class CategoriesModel {
  CategoriesModel(this._categoryId, this._categoryName);
  late int _categoryId;
  late String _categoryName;
  late String _categoryStatus;
  late String _categoryDescription;
  late int _productsCount;

  //List<ProductsModel> productsList = [];

  int get categoryId => _categoryId;
  String get categoryName => _categoryName;
  String get categoryStatus => _categoryStatus;
  String get categoryDescription => _categoryDescription;
  int get productsCount => _productsCount;

  set categoryId(int categoryId) {
    this._categoryId = categoryId;
  }

  set categoryName(String categoryName) {
    this._categoryName = categoryName;
  }

  set categoryStatus(String categoryStatus) {
    this._categoryStatus = categoryStatus;
  }

  set categoryDescription(String categoryDescription) {
    this._categoryDescription = categoryDescription;
  }

  set productsCount(int productsCount) {
    this._productsCount = productsCount;
  }

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    this._categoryId = json['id'];
    this._categoryName = json['categoryname'];
    this._categoryStatus =
        (json['status'] != null) ? json['status'] : 'Inactive';
    this._categoryDescription =
        (json['description'] != null) ? json['description'] : '';
    this._productsCount =
        (json['countproducts'] != null) ? int.parse(json['countproducts']) : 0;
  }
}
