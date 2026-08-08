class DealerInvoices {
  int? dealerId;
  String? dealer;
  String? townName;
  double? totalQuantity;
  double? totalBookedInvoiceValue;
  bool? isBulkPack;
  List<DashboardSalesDetails>? dashboardSalesDetails;

  DealerInvoices(
      {this.dealerId,
      this.dealer,
      this.townName,
      this.totalQuantity,
      this.totalBookedInvoiceValue,
      this.isBulkPack,
      this.dashboardSalesDetails});

  DealerInvoices.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    townName = json['townName'];
    totalQuantity = json['totalQuantity'];
    totalBookedInvoiceValue = json['totalBookedInvoiceValue'];
    isBulkPack = json['isBulkPack'];
    if (json['dashboardSalesDetails'] != null) {
      dashboardSalesDetails = <DashboardSalesDetails>[];
      json['dashboardSalesDetails'].forEach((v) {
        dashboardSalesDetails!.add(DashboardSalesDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['townName'] = townName;
    data['totalQuantity'] = totalQuantity;
    data['totalBookedInvoiceValue'] = totalBookedInvoiceValue;
    data['isBulkPack'] = isBulkPack;
    if (dashboardSalesDetails != null) {
      data['dashboardSalesDetails'] =
          dashboardSalesDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class DashboardSalesDetails {
//   int? invoiceId;
//   int? packgroupId;
//   String? invoiceNumber;
//   String? invoiceDate;
//   double? totalQuantity;
//   double? invoiceValue;
//   int? statusId;
//   String? statusName;
//   int? oilTypeId;
//   String? oilTypeName;
//   int? skuId;
//   String? skuName;
//   bool? isBulkPack;
//   int? packGroupId;
//
//   DashboardSalesDetails(
//       {this.invoiceId,
//       this.packgroupId,
//       this.invoiceNumber,
//       this.invoiceDate,
//       this.totalQuantity,
//       this.invoiceValue,
//       this.statusId,
//       this.statusName,
//       this.oilTypeId,
//       this.oilTypeName,
//       this.skuId,
//       this.skuName,
//       this.isBulkPack,
//       this.packGroupId});
//
//   DashboardSalesDetails.fromJson(Map<String, dynamic> json) {
//     invoiceId = json['invoiceId'];
//     packgroupId = json['packgroupId'];
//     invoiceNumber = json['invoiceNumber'];
//     invoiceDate = json['invoiceDate'];
//     totalQuantity = json['totalQuantity'];
//     invoiceValue = json['invoiceValue'];
//     statusId = json['statusId'];
//     statusName = json['statusName'];
//     oilTypeId = json['oilTypeId'];
//     oilTypeName = json['oilTypeName'];
//     skuId = json['skuId'];
//     skuName = json['skuName'];
//     isBulkPack = json['isBulkPack'];
//     packGroupId = json['packGroupId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['invoiceId'] = invoiceId;
//     data['packgroupId'] = packgroupId;
//     data['invoiceNumber'] = invoiceNumber;
//     data['invoiceDate'] = invoiceDate;
//     data['totalQuantity'] = totalQuantity;
//     data['invoiceValue'] = invoiceValue;
//     data['statusId'] = statusId;
//     data['statusName'] = statusName;
//     data['oilTypeId'] = oilTypeId;
//     data['oilTypeName'] = oilTypeName;
//     data['skuId'] = skuId;
//     data['skuName'] = skuName;
//     data['isBulkPack'] = isBulkPack;
//     data['packGroupId'] = packGroupId;
//     return data;
//   }
// }

class DashboardSalesDetails {
  String? invoiceNumber;
  List<InvoiceList>? invoiceList;

  DashboardSalesDetails({this.invoiceNumber, this.invoiceList});

  DashboardSalesDetails.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoiceNumber'];
    if (json['invoiceList'] != null) {
      invoiceList = <InvoiceList>[];
      json['invoiceList'].forEach((v) {
        invoiceList!.add(new InvoiceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceNumber'] = this.invoiceNumber;
    if (this.invoiceList != null) {
      data['invoiceList'] = this.invoiceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceList {
  int? invoiceId;
  String? invoiceDate;
  double? invoiceQuantity;
  double? invoiceValue;

  InvoiceList(
      {this.invoiceId,
        this.invoiceDate,
        this.invoiceQuantity,
        this.invoiceValue});

  InvoiceList.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'];
    invoiceDate = json['invoiceDate'];
    invoiceQuantity = json['invoiceQuantity'];
    invoiceValue = json['invoiceValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceId'] = this.invoiceId;
    data['invoiceDate'] = this.invoiceDate;
    data['invoiceQuantity'] = this.invoiceQuantity;
    data['invoiceValue'] = this.invoiceValue;
    return data;
  }
}
