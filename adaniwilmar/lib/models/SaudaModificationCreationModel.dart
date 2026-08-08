import 'OilResponseModel.dart';

class SaudaModificationCreationModel {
  int dealerId;
  int loginUserId;
  int saudaNumber;
  List<OilType> oilTypes;

  SaudaModificationCreationModel({
    required this.dealerId,
    required this.loginUserId,
    required this.saudaNumber,
    required this.oilTypes,
  });

  factory SaudaModificationCreationModel.fromJson(Map<String, dynamic> json) => SaudaModificationCreationModel(
    dealerId: json['DealerId'],
    loginUserId: json['LoginUserId'],
    saudaNumber: json['SaudaNumber'],
    oilTypes: (json['oilTypes'] as List)
        .map((e) => OilType.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'DealerId': dealerId,
    'LoginUserId': loginUserId,
    'SaudaNumber': saudaNumber,
    'oilTypes': oilTypes.map((e) => e.toJson()).toList(),
  };
}

