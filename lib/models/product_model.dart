class ProductsModel {
  ProductsModel(
    this._productId,
    this._productName,
  );
  late int _productId;
  late int _configProductId;
  late String _productName;
  late String _productDescription;
  late double _productPrice;
  late double _productCgst;
  late double _productSgst;
  late double _productIgst;
  late String _productHsnCode;
  late String _productSku;
  late int _categoryId;
  late String _categoryName;
  late int _unitId;
  late String _unitShortForm;
  late String _barcode;

// Getters
  int get productId => _productId;
  int get configProductId => _configProductId;
  String get productName => _productName;
  String get productDescription => _productDescription;
  double get productPrice => _productPrice;
  double get productIgst => _productIgst;
  double get productCgst => _productCgst;
  double get productSgst => _productSgst;
  String get productHsnCode => _productHsnCode;
  String get productSku => _productSku;
  int get categoryId => _categoryId;
  String get categoryName => _categoryName;
  int get unitId => _unitId;
  String get unitShortForm => _unitShortForm;
  String get barcode => _barcode;

// Setters
  set productId(int productId) {
    this._productId = productId;
  }

  set configProductId(int configProductId) {
    this._configProductId = configProductId;
  }

  set productName(String productName) {
    this._productName = productName;
  }

  set productDescription(String productDescription) {
    this._productDescription = productDescription;
  }

  set productPrice(double productPrice) {
    this._productPrice = productPrice;
  }

  set productIgst(double productIgst) {
    this._productIgst = productIgst;
  }

  set productCgst(double productCgst) {
    this._productCgst = productCgst;
  }

  set productSgst(double productSgst) {
    this._productSgst = productSgst;
  }

  set productHsnCode(String productHsnCode) {
    this._productHsnCode = productHsnCode;
  }

  set productSku(String productSku) {
    this._productSku = productSku;
  }

  set categoryId(int categoryId) {
    this._categoryId = categoryId;
  }

  set categoryName(String categoryName) {
    this._categoryName = categoryName;
  }

  set unitId(int unitId) {
    this._unitId = unitId;
  }

  set unitShortForm(String unitShortForm) {
    this._unitShortForm = unitShortForm;
  }

  set barcode(String barcode) {
    this._barcode = barcode;
  }

// Products from Json//
  ProductsModel.fromJson(Map<String, dynamic> json) {
    this._productId =
        (json['product_id'] != null) ? int.parse(json['product_id']) : 0;
    this._configProductId = (json['config_product_id'] != null)
        ? int.parse(json['config_product_id'])
        : 0;
    this._productName = (json['name'] != null) ? json['name'] : '';
    this._productDescription =
        (json['description'] != null) ? json['description'] : '';
    this._productPrice =
        (json['price'] != null) ? double.parse(json['price']) : 0;
    this._productIgst =
        (json['product_igst'] != null) ? double.parse(json['product_igst']) : 0;
    this._productCgst =
        (json['product_cgst'] != null) ? double.parse(json['product_cgst']) : 0;
    this._productSgst =
        (json['product_sgst'] != null) ? double.parse(json['product_sgst']) : 0;
    this._productHsnCode =
        (json['product_hsncode'] != null) ? json['product_hsncode'] : '';
    this._productSku = (json['sku'] != null) ? json['sku'] : '';
    this._categoryId =
        (json['category_id'] != null) ? int.parse(json['category_id']) : 0;
    this._categoryName =
        (json['category_name'] != null) ? json['category_name'] : '';
    this._unitId = (json['unit_id'] != null) ? int.parse(json['unit_id']) : 0;
    this._unitShortForm =
        (json['unit_short'] != null) ? json['unit_short'] : '';
    this._barcode = (json['barcode'] != null) ? json['barcode'] : '';
  }
}
