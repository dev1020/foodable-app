class OrderDetailsModel {
  int _productId = 0;
  String _productName = '';
  int _productQuantity = 0;
  double _amount = 0;
  double _price = 0;

  int get getProductId => _productId;
  String get getProductName => _productName;
  int get getProductQuantity => _productQuantity;
  double get getAmount => _amount;
  double get getPrice => _price;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    this._productId = json['service_id'];
    this._productName = json['service_name'];
    this._productQuantity = json['services_quantity'];
    this._amount = double.parse(json['amount']);
    this._price = double.parse(json['price']);
  }
  OrderDetailsModel.fromJsonForOrderWithProductApi(Map<String, dynamic> json) {
    this._productId = json['service_id'];
    this._productName = json['product']['name'];
    this._productQuantity = json['services_quantity'];
    this._amount = double.parse(json['amount']);
    this._price = double.parse(json['services_price']);
  }
}
