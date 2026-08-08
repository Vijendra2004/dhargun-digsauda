import 'package:adaniwilmar/models/quantity_allocation_model.dart';

class CallToCustomerModel extends BaseModel {
  final String name;
  final String? subName;
  final String? amt;

  CallToCustomerModel({required this.name, this.subName, this.amt});

  @override
  List<Object?> get props => [name, subName, amt];

  Map<String, dynamic> _toMap() {
    return {
      'name': name,
      'subName': subName,
      'amt': amt,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

  static List<CallToCustomerModel> callToCustomer = [
    CallToCustomerModel(
      name: 'Harilal & Sons',
      subName: "91630 72728",
      amt: '102019',
    ),
    CallToCustomerModel(
      name: 'Radhika Emporium Pvt Ltd',
      subName: "91630 72728",
      amt: '102651',
    ),
    CallToCustomerModel(
      name: 'Ace Traders',
      subName: "91630 72728",
      amt: '102147',
    ),
    CallToCustomerModel(
      name: 'Trinath Traders',
      subName: "91630 72728",
      amt: '102019',
    ),
  ];
}

class CallToCustomerList {
  int? dealerId;
  int? bdoId;
  String? dealerCode;
  String? dealerName;
  String? mobileNumber;
  String? additionalMobileNumber;
  String? bdoName;
  String? bdoCode;
  String? callRecordedFileName;
  int? audioFileDetailId;
  String? contactPersonName;
  String? audioFileNameInServerPath;
  String? brokerOrDealer;

  CallToCustomerList(
      {this.dealerId,
        this.bdoId,
        this.dealerCode,
        this.dealerName,
        this.mobileNumber,
        this.additionalMobileNumber,
        this.bdoName,
        this.bdoCode,
        this.callRecordedFileName,
        this.audioFileDetailId,
        this.contactPersonName,
        this.audioFileNameInServerPath,
        this.brokerOrDealer});

  CallToCustomerList.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    bdoId = json['bdoId'];
    dealerCode = json['dealerCode'];
    dealerName = json['dealerName'];
    mobileNumber = json['mobileNumber'];
    additionalMobileNumber = json['additionalMobileNumber'];
    bdoName = json['bdoName'];
    bdoCode = json['bdoCode'];
    callRecordedFileName = json['callRecordedFileName'];
    audioFileDetailId = json['audioFileDetailId'];
    contactPersonName = json['contactPersonName'];
    audioFileNameInServerPath = json['audioFileNameInServerPath'];
    brokerOrDealer = json['brokerOrDealer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dealerId'] = this.dealerId;
    data['bdoId'] = this.bdoId;
    data['dealerCode'] = this.dealerCode;
    data['dealerName'] = this.dealerName;
    data['mobileNumber'] = this.mobileNumber;
    data['additionalMobileNumber'] = this.additionalMobileNumber;
    data['bdoName'] = this.bdoName;
    data['bdoCode'] = this.bdoCode;
    data['callRecordedFileName'] = this.callRecordedFileName;
    data['audioFileDetailId'] = this.audioFileDetailId;
    data['contactPersonName'] = this.contactPersonName;
    data['audioFileNameInServerPath'] = this.audioFileNameInServerPath;
    data['brokerOrDealer'] = this.brokerOrDealer;
    return data;
  }
}
