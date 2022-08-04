import 'package:foodable/utils/network_utils.dart';

class CustomerModel {
  CustomerModel(this._contact, this._name);
  late String _name;
  late String _contact;
  late String _label;

  List usersSuggestion = [];

  String get name => _name;
  String get contact => _contact;
  String get label => _label;

  set contact(String contact) {
    this._contact = contact;
  }

  set name(String name) {
    this._name = name;
  }

  set label(String label) {
    this._label = label;
  }

  CustomerModel.fromJson(Map<String, dynamic> json) {
    this._contact = json['contact'].toString();
    this._name = json['name'];
    this._label = json['label'].toString();
  }

  static getCustomerSuggestions(String query) async {
    List<CustomerModel> searchedCustomersList = [];
    if (query.length > 3) {
      var responseJson =
          await NetworkUtils.getCustomerSuggestions(queryString: query);
      //print(responseJson);

      for (int i = 0; i < responseJson.length; i++) {
        var Customer = CustomerModel.fromJson(responseJson[i]);
        //print(responseJson[i]['contact']);
        searchedCustomersList.add(Customer);
      }
    }
    // return searchedCustomersList
    //       .map((responseJson) => CustomerModel.fromJson(responseJson))
    //       .toList();
    return searchedCustomersList;
  }
}
