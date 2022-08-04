import 'package:flutter/material.dart';
import 'package:foodable/models/order_details_model.dart';
import 'package:foodable/models/order_model.dart';
import 'package:foodable/utils/network_utils.dart';

class PosProvider extends ChangeNotifier {
  OrderModel _order = OrderModel();

  String get saleNo => _order.saleNo;
  String get customerContact => _order.customerContact;
  String get customerName => _order.customerName;
  String get saleStatus => _order.saleStatus;
  double get totalAmount => _order.totalAmount;
  double get subTotal => _order.subTotal;
  double get taxAmount => _order.taxAmount;
  double get discountPercent => _order.discountPercent;
  double get discountTotal => _order.discountTotal;
  String get payType => _order.payType;

  List<OrderDetailsModel> get orderDetailsList => _order.orderDetails;

  createOrder(Map<String, dynamic> json) {
    this._order.saleNo = json['saleno'];
    this._order.customerContact = json['customerContact'];
    this._order.customerName = json['customerName'];
    this._order.saleStatus = json['saleStatus'];
    this._order.orderDetails = [];
    // print(json);
    // print(this._order.customerName);
    notifyListeners();
  }

  updateOrder(Map<String, dynamic> json) {
    this._order.totalAmount =
        double.parse(json['sale']['total_amount'].toStringAsFixed(2));

    this._order.subTotal = (json['sale']['sub_total'] != 0)
        ? double.parse(json['sale']['sub_total'])
        : 0;
    this._order.taxAmount =
        double.parse(json['sale']['tds_amount'].toStringAsFixed(2));
    this._order.discountPercent =
        double.parse(json['sale']['discount_percent']);
    this._order.discountTotal = double.parse(json['sale']['discount_total']);
    this._order.saleStatus = json['sale']['status'];

    var details = json['saleDetails'];
    _order.orderDetails = [];
    //print(json['saleDetails'].length);
    for (int i = 0; i < details.length; i++) {
      // print(products[i]);
      var product = OrderDetailsModel.fromJson(details[i]);
      _order.orderDetails.add(product);
    }
    addDiscountToOrder(this._order.discountPercent);
    notifyListeners();
  }

  addItemToOrder(productId) async {
    if (this._order.saleStatus == 'draft') {
      var responseJson =
          await NetworkUtils.addItemsToCart(this._order.saleNo, productId);
      // print(responseJson);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  addItemToOrderByBarcode(barcode) async {
    if (this._order.saleStatus == 'draft') {
      var responseJson = await NetworkUtils.addItemsToCartByBarcode(
          this._order.saleNo, barcode);
      //print(responseJson);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  decreaseItemToOrder(productId) async {
    if (this._order.saleStatus == 'draft') {
      var responseJson =
          await NetworkUtils.decreaseItemsToCart(this._order.saleNo, productId);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  removeItemToOrder(productId) async {
    if (this._order.saleStatus == 'draft') {
      var responseJson =
          await NetworkUtils.removeItemsToCart(this._order.saleNo, productId);
      updateOrder(responseJson);
      notifyListeners();
    }
  }

  cancelOrder() async {
    await NetworkUtils.cancelOrderPost(this._order.saleNo);
    // this._saleno = '';
    // this._customerContact = '';
    this._order.saleStatus = 'cancelled';
    notifyListeners();
  }

  generateBill() async {
    var responseJson = await NetworkUtils.generateBillPost(
        saleno: this._order.saleNo,
        subtotal: this._order.subTotal,
        total: this._order.totalAmount,
        discountpercent: this._order.discountPercent,
        discounttotal: this._order.discountTotal,
        tdsamount: this._order.taxAmount,
        pay: this._order.payType);
    updateOrder(responseJson);
    notifyListeners();
  }

  addDiscountToOrder(discount) {
    this._order.discountPercent = discount;
    this._order.discountTotal = this._order.subTotal * discount / 100;
    this._order.totalAmount = this._order.subTotal - this._order.discountTotal;
    notifyListeners();
  }

  addPayType(pay_type) {
    this._order.payType = pay_type;
    notifyListeners();
  }

  loadOrder(OrderModel order) {
    this._order = order;
    notifyListeners();
  }
}
