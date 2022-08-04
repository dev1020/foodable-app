import 'package:foodable/models/order_details_model.dart';

class OrderModel {
  OrderModel();
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

  List<OrderDetailsModel> _orderDetails = [];

  String get saleNo => _saleno;
  String get customerContact => _customerContact;
  String get customerName => _customerName;
  String get saleStatus => _saleStatus;
  double get totalAmount => _total_amount;
  double get subTotal => _sub_total;
  double get taxAmount => _tds_amount;
  double get discountPercent => _discount_percent;
  double get discountTotal => _discount_total;
  String get payType => _paytype;
  List<OrderDetailsModel> get orderDetails => _orderDetails;

  set saleNo(String saleNo) {
    this._saleno = saleNo;
  }

  set customerContact(String customerContact) {
    this._customerContact = customerContact;
  }

  set customerName(String customerName) {
    this._customerName = customerName;
  }

  set saleStatus(String saleStatus) {
    this._saleStatus = saleStatus;
  }

  set totalAmount(double totalAmount) {
    this._total_amount = totalAmount;
  }

  set subTotal(double subTotal) {
    this._sub_total = subTotal;
  }

  set taxAmount(double taxAmount) {
    this._tds_amount = taxAmount;
  }

  set discountPercent(double discountPercent) {
    this._discount_percent = discountPercent;
  }

  set discountTotal(double discountTotal) {
    this._discount_total = discountTotal;
  }

  set payType(String payType) {
    this._paytype = payType;
  }

  set orderDetails(List<OrderDetailsModel> orderDetails) {
    this._orderDetails = orderDetails;
  }

  OrderModel.fromJson(Map<String, dynamic> json) {
    this.saleNo = json['sale_no'];
    this.customerContact = json['cust']['contact'];
    this.customerName = json['cust']['name'];
    this.saleStatus = json['status'];
    this.totalAmount = double.parse(json['total_amount']);
    this.subTotal = double.parse(json['sub_total']);
    this.taxAmount = double.parse(json['tds_amount']);
    this.discountPercent = double.parse(json['discount_percent']);
    this.discountTotal = double.parse(json['discount_total']);
    this.payType = (json['pay_by'] != null) ? json['pay_by'] : '';
    List details = json['saleToOrderServices'];
    orderDetails = [];

    for (int i = 0; i < details.length; i++) {
      var orderList =
          OrderDetailsModel.fromJsonForOrderWithProductApi(details[i]);
      orderDetails.add(orderList);
    }
    // print(details);
    // print(details.length);
  }
}
