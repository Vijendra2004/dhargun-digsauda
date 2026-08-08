class CustomerAudioFile {
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
  bool? brokerOrDealer;
  int? callDuation;

  CustomerAudioFile(
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
        this.brokerOrDealer,
        this.callDuation});

  CustomerAudioFile.fromJson(Map<String, dynamic> json) {
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
    callDuation = json['callDuation'];
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
    data['callDuation'] = this.callDuation;
    return data;
  }
}

class SaveAudioRequest {
  List<AudioFileDetailIds>? audioFileDetailIds;
  int? dealerId;
  List<String>? imagePaths;
  int? loginUserId;
  int? saudaId;

  SaveAudioRequest(
      {this.audioFileDetailIds,
        this.dealerId,
        this.imagePaths,
        this.loginUserId,
        this.saudaId});

  SaveAudioRequest.fromJson(Map<String, dynamic> json) {
    if (json['audioFileDetailIds'] != null) {
      audioFileDetailIds = <AudioFileDetailIds>[];
      json['audioFileDetailIds'].forEach((v) {
        audioFileDetailIds!.add(new AudioFileDetailIds.fromJson(v));
      });
    }
    dealerId = json['dealerId'];
    imagePaths = json['imagePaths'].cast<String>();
    loginUserId = json['loginUserId'];
    saudaId = json['saudaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.audioFileDetailIds != null) {
      data['audioFileDetailIds'] =
          this.audioFileDetailIds!.map((v) => v.toJson()).toList();
    }
    data['dealerId'] = this.dealerId;
    data['imagePaths'] = this.imagePaths;
    data['loginUserId'] = this.loginUserId;
    data['saudaId'] = this.saudaId;
    return data;
  }
}

class AudioFileDetailIds {
  int? audioFileDetailId;
  int? userId;

  AudioFileDetailIds({this.audioFileDetailId, this.userId});

  AudioFileDetailIds.fromJson(Map<String, dynamic> json) {
    audioFileDetailId = json['audioFileDetailId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audioFileDetailId'] = this.audioFileDetailId;
    data['userId'] = this.userId;
    return data;
  }
}
