import 'package:adaniwilmar/models/plant_list_response.dart';

class DealerSaudaDetail {
  double? totalSaudaLimit;
  double? availableSaudaLimit;
  double? outstandingSaudaLimit;
  int? brokerId;
  String? broker;
  List<IncoTermList>? incoTermList;
  List<BrokerList>? brokerList;
  List<PlanDepotList>? plantDepotList;
  List<PlanDepotList>? plantDepotListNew;
  int? saudaValidityPeriod;
  int? highestBookedPlantId;

  DealerSaudaDetail(
      {this.totalSaudaLimit,
      this.availableSaudaLimit,
      this.outstandingSaudaLimit,
      this.brokerId,
      this.broker,
      this.incoTermList,
      this.brokerList,
      this.saudaValidityPeriod,
      this.plantDepotList,
      this.plantDepotListNew,
      this.highestBookedPlantId});

  DealerSaudaDetail.fromJson(Map<String, dynamic> json) {
    totalSaudaLimit = json['totalSaudaLimit'];
    availableSaudaLimit = json['availableSaudaLimit'];
    outstandingSaudaLimit = json['outstandingSaudaLimit'];
    brokerId = json['brokerId'];
    broker = json['broker'];
    if (json['incoTermList'] != null) {
      incoTermList = <IncoTermList>[];
      json['incoTermList'].forEach((v) {
        incoTermList!.add(IncoTermList.fromJson(v));
      });
    }
    if (json['brokerList'] != null) {
      brokerList = <BrokerList>[];
      json['brokerList'].forEach((v) {
        brokerList!.add(BrokerList.fromJson(v));
      });
    }
    if (json['planDepotList'] != null) {
      plantDepotList = <PlanDepotList>[];
      json['plantDepotList'].forEach((v) {
        plantDepotList!.add(PlanDepotList.fromJson(v));
      });
    }
    if (json['plantDepotListNew'] != null) {
      plantDepotListNew = <PlanDepotList>[];
      json['plantDepotListNew'].forEach((v) {
        plantDepotListNew!.add(PlanDepotList.fromJson(v));
      });
    }
    saudaValidityPeriod = json['saudaValidityPeriod'];
    highestBookedPlantId = json['highestBookedPlantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalSaudaLimit'] = totalSaudaLimit;
    data['availableSaudaLimit'] = availableSaudaLimit;
    data['outstandingSaudaLimit'] = outstandingSaudaLimit;
    data['brokerId'] = brokerId;
    data['broker'] = broker;
    if (incoTermList != null) {
      data['incoTermList'] = incoTermList!.map((v) => v.toJson()).toList();
    }
    if (brokerList != null) {
      data['brokerList'] = brokerList!.map((v) => v.toJson()).toList();
    }
    data['saudaValidityPeriod'] = saudaValidityPeriod;
    return data;
  }
}

class IncoTermList {
  int? id;
  String? name;
  String? code;
  int? type;
  bool? isActive;

  IncoTermList({this.id, this.name, this.code, this.type, this.isActive});

  IncoTermList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['type'] = type;
    data['isActive'] = isActive;
    return data;
  }
}

class BrokerList {
  int? id;
  String? name;
  String? code;
  double? caseToMetricTonValue;

  BrokerList({this.id, this.name, this.code, this.caseToMetricTonValue});

  BrokerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    return data;
  }
}
