class ProductsWithAttributeModel {
  ProductsWithAttributeModel(this._productName);

  late int _configProductId;
  late String _productName;
  late double _productPrice;
  late int _categoryId;
  late String _categoryName;

// Getters

  int get configProductId => _configProductId;
  String get productName => _productName;
  double get productPrice => _productPrice;
  int get categoryId => _categoryId;
  String get categoryName => _categoryName;

// Setters

  set configProductId(int configProductId) {
    this._configProductId = configProductId;
  }

  set productName(String productName) {
    this._productName = productName;
  }

  set productPrice(double productPrice) {
    this._productPrice = productPrice;
  }

  set categoryId(int categoryId) {
    this._categoryId = categoryId;
  }

  set categoryName(String categoryName) {
    this._categoryName = categoryName;
  }

// Products from Json//
  ProductsWithAttributeModel.fromJson(Map<String, dynamic> json) {
    this._configProductId = (json['config_product_id'] != null)
        ? int.parse(json['config_product_id'])
        : 0;
    this._productName = (json['name'] != null) ? json['name'] : '';
    this._productPrice =
        (json['price'] != null) ? double.parse(json['price']) : 0;
    this._categoryId = (json['category_id'] != null) ? json['category_id'] : 0;
    this._categoryName =
        (json['category_name'] != null) ? json['category_name'] : '';
  }
}
