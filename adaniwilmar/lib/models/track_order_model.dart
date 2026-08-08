class TrackOrderModel {
  String? dealerCode;
  String? dealerName;
  List<DoDetails>? doDetails;

  TrackOrderModel({this.dealerCode, this.dealerName, this.doDetails});

  TrackOrderModel.fromJson(Map<String, dynamic> json) {
    dealerCode = json['dealer_code'];
    dealerName = json['dealer_name'];
    if (json['do_details'] != null) {
      doDetails = <DoDetails>[];
      json['do_details'].forEach((v) {
        doDetails!.add(new DoDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dealer_code'] = this.dealerCode;
    data['dealer_name'] = this.dealerName;
    if (this.doDetails != null) {
      data['do_details'] = this.doDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoDetails {
  String? from;
  String? to;
  String? vehicleNumber;
  String? driverName;
  String? driverPhoneNumber;
  String? trackingLink;
  StatusBody? statusBody;
  String? doNumber;
  int? statusCode;
  String? message;
  SalesDataResponse? salesDataList;

  DoDetails(
      {this.from,
        this.to,
        this.vehicleNumber,
        this.driverName,
        this.driverPhoneNumber,
        this.trackingLink,
        this.statusBody,
        this.doNumber,
        this.statusCode,
        this.message,
        this.salesDataList
      });

  DoDetails.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    vehicleNumber = json['vehicle_number'];
    driverName = json['driver_name'];
    driverPhoneNumber = json['driver_phone_number'];
    trackingLink = json['tracking_link'];
    statusBody = json['status_body'] != null
        ? new StatusBody.fromJson(json['status_body'])
        : null;
    doNumber = json['do_number'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['vehicle_number'] = this.vehicleNumber;
    data['driver_name'] = this.driverName;
    data['driver_phone_number'] = this.driverPhoneNumber;
    data['tracking_link'] = this.trackingLink;
    if (this.statusBody != null) {
      data['status_body'] = this.statusBody!.toJson();
    }
    data['do_number'] = this.doNumber;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class StatusBody {
  String? currentStatus;
  String? status;
  String? lastKnownLocation;
  String? latitude;
  String? longitude;
  String? lastKnownDateTime;
  String? distanceCovered;
  String? eta;
  String? arrivedDateTime;
  String? tripClosedDateTime;

  StatusBody(
      {this.currentStatus,
        this.status,
        this.lastKnownLocation,
        this.latitude,
        this.longitude,
        this.lastKnownDateTime,
        this.distanceCovered,
        this.eta,
        this.arrivedDateTime,
        this.tripClosedDateTime});

  StatusBody.fromJson(Map<String, dynamic> json) {
    currentStatus = json['current_status'];
    status = json['status'];
    lastKnownLocation = json['last_known_location'];
    latitude = (json['latitude']??"").toString();
    longitude = (json['longitude']??"").toString();
    lastKnownDateTime = json['last_known_date_time'];
    distanceCovered = (json['distance_covered']??"").toString();
    eta = json['eta'];
    arrivedDateTime = json['arrived_date_time'];
    tripClosedDateTime = json['trip_closed_date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_status'] = this.currentStatus;
    data['status'] = this.status;
    data['last_known_location'] = this.lastKnownLocation;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['last_known_date_time'] = this.lastKnownDateTime;
    data['distance_covered'] = this.distanceCovered;
    data['eta'] = this.eta;
    data['arrived_date_time'] = this.arrivedDateTime;
    data['trip_closed_date_time'] = this.tripClosedDateTime;
    return data;
  }
}

class DoMaterial {
  int? skuId;
  String? skuName;
  double? quantity;
  double? quantityCase;
  String? oilTypeName;

  DoMaterial(
      {this.skuId,
        this.skuName,
        this.quantity,
        this.quantityCase,
        this.oilTypeName});

  DoMaterial.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    skuName = json['skuName'];
    quantity = json['quantity'];
    quantityCase = json['quantityCase'];
    oilTypeName = json['oilTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
    data['quantity'] = this.quantity;
    data['quantityCase'] = this.quantityCase;
    data['oilTypeName'] = this.oilTypeName;
    return data;
  }
}

// Resuest model for fetch saledata list in 3rd step api
class SaleDataRequest {
  int? liftingId;
  String? doNumber;
  bool? isLiftingId;
  int? loginUserId;
  List<DoNumbersRequest>? doNumbers;

  SaleDataRequest(
      {this.liftingId,
        this.doNumber,
        this.isLiftingId,
        this.loginUserId,
        this.doNumbers});

  SaleDataRequest.fromJson(Map<String, dynamic> json) {
    liftingId = json['liftingId'];
    doNumber = json['doNumber'];
    isLiftingId = json['isLiftingId'];
    loginUserId = json['loginUserId'];
    if (json['doNumbers'] != null) {
      doNumbers = <DoNumbersRequest>[];
      json['doNumbers'].forEach((v) {
        doNumbers!.add(new DoNumbersRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['liftingId'] = this.liftingId;
    data['doNumber'] = this.doNumber;
    data['isLiftingId'] = this.isLiftingId;
    data['loginUserId'] = this.loginUserId;
    if (this.doNumbers != null) {
      data['doNumbers'] = this.doNumbers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Response model for saledata list in 3rd step api
class SalesDataResponse {
  String? doNumber;
  String? billingNumber;
  String? billingDate;
  int? liftingRequestId;
  List<Materials>? materials;
  String? shipToParty;


  SalesDataResponse({this.doNumber,  this.billingNumber, this.billingDate, this.liftingRequestId, this.materials});

  SalesDataResponse.fromJson(Map<String, dynamic> json) {
    doNumber = json['doNumber'];
    shipToParty = json['shipToParty'];
    billingNumber = json['billingNumber'];
    billingDate = json['billingDate'];
    liftingRequestId = json['liftingRequestId'];
    if (json['materials'] != null) {
      materials = <Materials>[];
      json['materials'].forEach((v) {
        materials!.add(new Materials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doNumber'] = this.doNumber;
    data['shipToParty'] = this.shipToParty;
    data['billingNumber'] =  billingNumber ;
    data['billingDate'] =  billingDate ;
    data['liftingRequestId'] = this.liftingRequestId;
    if (this.materials != null) {
      data['materials'] = this.materials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Materials {
  int? skuId;
  String? skuName;
  double? quantity;
  double? quantityCase;
  String? oilTypeName;
  String? shipToParty;

  Materials(
      {this.skuId,
        this.skuName,
        this.quantity,
        this.quantityCase,
        this.oilTypeName,
      this.shipToParty});

  Materials.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    skuName = json['skuName'];
    quantity = json['quantity'];
    quantityCase = json['quantityCase'];
    oilTypeName = json['oilTypeName'];
    shipToParty = json['shipToParty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skuId'] = this.skuId;
    data['skuName'] = this.skuName;
    data['quantity'] = this.quantity;
    data['quantityCase'] = this.quantityCase;
    data['oilTypeName'] = this.oilTypeName;
    data['shipToParty'] = this.shipToParty;
    return data;
  }
}


class DoNumbersRequest {
  String? doNumber;
  int? liftingId;
  String? status;

  DoNumbersRequest({this.doNumber, this.liftingId, this.status});

  DoNumbersRequest.fromJson(Map<String, dynamic> json) {
    doNumber = json['doNumber'];
    liftingId = json['liftingId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doNumber'] = this.doNumber;
    data['liftingId'] = this.liftingId;
    data['status'] = this.status;
    return data;
  }
}
