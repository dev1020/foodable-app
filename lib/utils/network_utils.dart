// ignore_for_file: prefer_single_quotes

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_utils.dart';
//import 'auth_utils.dart';

class NetworkUtils {
  static const String host = productionHost;
  static const String productionHost = 'https://foodable.co.in/pos/api/web/v1/';

  static dynamic authenticateUser(String contact, String password) async {
    var uri = host + AuthUtils.endPoint;
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonBody = '{"username": "$contact", "password": "$password"}';
    // print(contact);
    // print(password);
    // print(jsonBody);

    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final Map<String, dynamic> responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static logoutUser(BuildContext context, SharedPreferences prefs) {
    prefs.setString(AuthUtils.authTokenKey, '');
    prefs.setInt(AuthUtils.userIdKey, 0);
    prefs.setString(AuthUtils.userContact, '');
    prefs.setString(AuthUtils.userEmail, '');
    prefs.setString(AuthUtils.userName, '');
    prefs.setString(AuthUtils.userProfilePic, '');
    return null;
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message,
      BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Container(
          alignment: Alignment.bottomCenter,
          height: 35.0,
          child: Center(child: Text(message))),
    ));
  }

  static fetch(var endPoint) async {
    //var uri = host + endPoint+'access-token=$authToken';
    var uri = host + endPoint;
    //print(uri);
    try {
      final response = await http.get(Uri.parse(uri));

      //final responseJson = json.decode(response.body);
      //final responseJsonhead = (response.headers['x-pagination-page-count']);

      return response;
    } catch (exception) {
      // print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static fetchPosCategories() async {
    //print(1);
    var endPoint = 'pos';
    var responseJson = await NetworkUtils.fetch(endPoint);
    var responseJsonBody = json.decode(responseJson.body);
    //print(responseJsonBody);
    return responseJsonBody['categories'];
  }

  static fetchDefaultItems() async {
    //print(1);
    var endPoint = 'pos';
    var responseJson = await NetworkUtils.fetch(endPoint);
    var responseJsonBody = json.decode(responseJson.body);
    //print(responseJsonBody);
    return responseJsonBody['defaultItems'];
  }

  static fetchProductsByCategory(categoryId) async {
    var endPoint = 'pos/getitems/$categoryId';
    //print(endPoint);
    var responseJson = await NetworkUtils.fetch(endPoint);
    var responseJsonBody = json.decode(responseJson.body);
    return responseJsonBody['items'];
  }

  static createOrderPost(String contact, String name) async {
    var uri = '${host}pos/create-order';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '{"customer_no": "$contact", "customer_name": "$name"}';
    //print(contact);
    //print(name);
    //print(jsonBody);
    // try {
    final response =
        await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

    final Map<String, dynamic> responseJson = json.decode(response.body);
    //print(responseJson);
    return responseJson;
    // } catch (exception) {
    //   // print(exception);
    //   if (exception.toString().contains('SocketException')) {
    //     return 'NetworkError';
    //   } else {
    //     return null;
    //   }
    // }
  }

  static addItemsToCart(String saleNo, int productId) async {
    var uri = '${host}pos/add-items-list';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '{"saleNo": "$saleNo", "itemId": "$productId"}';
    //print(saleNo);
    //print(productId);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final Map<String, dynamic> responseJson = json.decode(response.body);
      //print(response.body);
      return responseJson;
    } catch (exception) {
      // print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static addItemsToCartByBarcode(String saleNo, String barcode) async {
    var uri = '${host}pos/add-items-list-barcode';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '{"saleNo": "$saleNo", "barcode": "$barcode"}';
    //print(saleNo);
    //print(productId);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final Map<String, dynamic> responseJson = json.decode(response.body);
      //print(response.body);
      return responseJson;
    } catch (exception) {
      // print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static decreaseItemsToCart(String saleNo, int productId) async {
    var uri = '${host}pos/decrease-items-list';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '{"saleNo": "$saleNo", "itemId": "$productId"}';
    //print(saleNo);
    //print(productId);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final Map<String, dynamic> responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static removeItemsToCart(String saleNo, int productId) async {
    var uri = '${host}pos/delete-items-list';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '{"saleNo": "$saleNo", "itemId": "$productId"}';
    //print(saleNo);
    //print(productId);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final Map<String, dynamic> responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static cancelOrderPost(String saleNo) async {
    var uri = '${host}pos/cancel-order';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '{"saleno": "$saleNo"}';
    //print(saleNo);
    //print(productId);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final Map<String, dynamic> responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static generateBillPost(
      {required String saleno,
      required double subtotal,
      required double tdsamount,
      required double total,
      required double discounttotal,
      required double discountpercent,
      required String pay}) async {
    var uri = '${host}pos/generate-bill';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '''
        {"saleno": "$saleno",
        "subtotal":$subtotal,
        "tdsamount":$tdsamount,
        "total":$total,
        "discounttotal":$discounttotal,
        "discountpercent":$discountpercent,
        "pay":"$pay"}
        ''';
    //print(saleNo);
    //print(productId);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final Map<String, dynamic> responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static getAllProducts(page_no) async {
    var endPoint = 'products?page=$page_no';
    //print(endPoint);
    var responseJson = await NetworkUtils.fetch(endPoint);
    //var responseJsonBody = json.decode(responseJson.body);
    //final responseJsonhead = responseJson.headers['x-pagination-page-count'];
    //print(responseJsonhead);
    return responseJson;
  }

  static fetchProductUnits() async {
    //print(1);
    var endPoint = 'product-units';
    var responseJson = await NetworkUtils.fetch(endPoint);
    var responseJsonBody = json.decode(responseJson.body);
    //print(responseJsonBody);
    return responseJsonBody;
  }

  static updateProduct(
      {required int productid,
      required int configproductid,
      required String productname,
      required int productcategory,
      required int productunit,
      required String productprice,
      required String productsku,
      required String producthsncode,
      required String productdescription,
      String? productbarcode}) async {
    var uri = '${host}products/$productid';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '''
    {
      "configproductid":"$configproductid",
      "name":"$productname",
      "price":"$productprice",
      "sku":"$productsku",
      "category":"$productcategory",
      "description":"$productdescription",
      "product_hsncode":"$producthsncode",
      "product_unit":"$productunit",
      "barcode":"$productbarcode"
    }
    ''';
    //print(jsonBody);
    try {
      final response =
          await http.put(Uri.parse(uri), headers: headers, body: jsonBody);

      final responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static createProduct(
      {required String productname,
      required int productcategory,
      required int productunit,
      required String productprice,
      required String productsku,
      required String producthsncode,
      required String productdescription,
      String? productbarcode}) async {
    var uri = '${host}products';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '''
    {
      "name":"$productname",
      "price":"$productprice",
      "sku":"$productsku",
      "category":"$productcategory",
      "description":"$productdescription",
      "product_hsncode":"$producthsncode",
      "product_unit":"$productunit",
      "barcode":"$productbarcode"
    }
    ''';
    //print(jsonBody);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static deleteProduct({required int configproductid}) async {
    var uri = '${host}products/$configproductid';
    Map<String, String> headers = {'Content-type': 'application/json'};
    try {
      final response = await http.delete(Uri.parse(uri), headers: headers);
      //print(responseJson);
      return response;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static getCategories(page_no) async {
    var endPoint = 'categories?page=$page_no';
    //print(endPoint);
    var responseJson = await NetworkUtils.fetch(endPoint);
    //var responseJsonBody = json.decode(responseJson.body);
    //final responseJsonhead = responseJson.headers['x-pagination-page-count'];
    //print(responseJsonhead);
    return responseJson;
  }

  static createCategory({
    required String categoryname,
    required String status,
    String description = '',
  }) async {
    var uri = '${host}categories';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '''
    {
      "categoryname":"$categoryname",
      "status":"$status",
      "description":"$description"
    }
    ''';
    //print(jsonBody);
    try {
      final response =
          await http.post(Uri.parse(uri), headers: headers, body: jsonBody);

      final responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static updateCategory({
    required int categoryId,
    required String categoryname,
    required String status,
    String description = '',
  }) async {
    var uri = '${host}categories/$categoryId';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String jsonBody = '''
    {
      "categoryname":"$categoryname",
      "status":"$status",
      "description":"$description"
    }
    ''';
    //print(jsonBody);
    try {
      final response =
          await http.put(Uri.parse(uri), headers: headers, body: jsonBody);

      final responseJson = json.decode(response.body);
      //print(responseJson);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static deleteCategory({required int categoryid}) async {
    var uri = '${host}categories/$categoryid';
    Map<String, String> headers = {'Content-type': 'application/json'};
    try {
      final response = await http.delete(Uri.parse(uri), headers: headers);
      //print(response.statusCode);
      return response;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static getCustomerSuggestions({required String queryString}) async {
    var uri = '${host}pos/get-customer-suggestions/$queryString';
    Map<String, String> headers = {'Content-type': 'application/json'};
    try {
      final response = await http.get(Uri.parse(uri), headers: headers);
      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      //print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static getSalesList(page_no) async {
    var endPoint =
        'orders?expand=saleToOrderServices,cust,saleToOrderServices.product&page=$page_no';
    //print(endPoint);
    var responseJson = await NetworkUtils.fetch(endPoint);
    var responseJsonBody = json.decode(responseJson.body);
    //final responseJsonhead = responseJson.headers['x-pagination-page-count'];
    //print(responseJsonBody);
    return responseJson;
  }
}
