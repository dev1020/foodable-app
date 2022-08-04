import 'package:flutter/material.dart';
import 'package:foodable/models/order_details_model.dart';
import 'package:foodable/utils/network_utils.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderDetailsModel> _orderDetails = [];
  String _saleno = '';
  String _customerContact = '';
  String _customerName = '';
  String _saleStatus = '';
  double _total_amount = 0;
  double _sub_total = 0;
  double _tds_amount = 0;
  double _discount_percent = 0;
  double _discount_total = 0;
  String _paytype = 'cash';

  String get getSaleNo => _saleno;
  String get getCustomerContact => _customerContact;
  String get getCustomerName => _customerName;
  String get getSaleStatus => _saleStatus;
  double get getTotalAmount => _total_amount;
  double get getSubTotal => _sub_total;
  double get getTaxAmount => _tds_amount;
  double get getDiscountPercent => _discount_percent;
  double get getDiscountTotal => _discount_total;
  String get getPayType => _paytype;

  List<OrderDetailsModel> get getOrderDetailsList => _orderDetails;

  createOrder(Map<String, dynamic> json) {
    //print(json);
    this._saleno = json['saleno'];
    this._customerContact = json['customerContact'];
    this._customerName = json['customerName'];
    this._saleStatus = json['saleStatus'];
    this._orderDetails = [];
    notifyListeners();
  }

  updateOrder(Map<String, dynamic> json) {
    this._total_amount =
        double.parse(json['sale']['total_amount'].toStringAsFixed(2));

    this._sub_total = (json['sale']['sub_total'] != 0)
        ? double.parse(json['sale']['sub_total'])
        : 0;
    this._tds_amount =
        double.parse(json['sale']['tds_amount'].toStringAsFixed(2));
    this._discount_percent = double.parse(json['sale']['discount_percent']);
    this._discount_total = double.parse(json['sale']['discount_total']);
    this._saleStatus = json['sale']['status'];

    var products = json['saleDetails'];
    _orderDetails = [];
    //print(json['saleDetails'].length);
    for (int i = 0; i < products.length; i++) {
      // print(products[i]);
      var product = OrderDetailsModel.fromJson(products[i]);
      _orderDetails.add(product);
    }
    notifyListeners();
  }

  addDiscountToOrder(discount) {
    this._discount_percent = discount;
    this._discount_total = this._sub_total * discount / 100;
    this._total_amount = this._sub_total - this._discount_total;
    notifyListeners();
  }

  addPayType(pay_type) {
    this._paytype = pay_type;
    notifyListeners();
  }

  addItemToOrder(productId) async {
    if (this._saleStatus == 'draft') {
      var responseJson =
          await NetworkUtils.addItemsToCart(this._saleno, productId);
      // print(responseJson);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  addItemToOrderByBarcode(barcode) async {
    if (this._saleStatus == 'draft') {
      var responseJson =
          await NetworkUtils.addItemsToCartByBarcode(this._saleno, barcode);
      //print(responseJson);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  decreaseItemToOrder(productId) async {
    if (this._saleStatus == 'draft') {
      var responseJson =
          await NetworkUtils.decreaseItemsToCart(this._saleno, productId);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  removeItemToOrder(productId) async {
    if (this._saleStatus == 'draft') {
      var responseJson =
          await NetworkUtils.removeItemsToCart(this._saleno, productId);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  cancelOrder() async {
    await NetworkUtils.cancelOrderPost(this._saleno);
    // this._saleno = '';
    // this._customerContact = '';
    this._saleStatus = 'cancelled';
    notifyListeners();
  }

  generateBill() async {
    var responseJson = await NetworkUtils.generateBillPost(
        saleno: this._saleno,
        subtotal: this._sub_total,
        total: this._total_amount,
        discountpercent: this._discount_percent,
        discounttotal: this._discount_total,
        tdsamount: this._tds_amount,
        pay: this._paytype);
    updateOrder(responseJson);
    notifyListeners();
  }
}
