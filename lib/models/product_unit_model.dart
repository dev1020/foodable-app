//import 'package:foodable/models/product_model.dart';

class ProductUnitsModel {
  ProductUnitsModel(this._unitId, this._unitShortForm, this._unitLabel);
  late int _unitId;
  late String _unitShortForm;
  late String _unitLabel;

  int get unitId => _unitId;
  String get unitShortForm => _unitShortForm;
  String get unitLabel => _unitLabel;

  set unitId(int unitId) {
    this._unitId = unitId;
  }

  set unitShortForm(String unitShortForm) {
    this._unitShortForm = unitShortForm;
  }

  set unitLabel(String unitLabel) {
    this._unitLabel = unitLabel;
  }

  ProductUnitsModel.fromJson(Map<String, dynamic> json) {
    this._unitId = json['id'];
    this._unitShortForm = json['short_form'];
    this._unitLabel = json['label'];
  }
}
