class DealerPendingSales {
  int? dealerId;
  String? dealer;
  String? townName;
  double? totalQuantity;
  double? totalBookedInvoiceValue;
  bool? isBulkPack;
  List<DashboardSalesDetails>? dashboardSalesDetails;

  DealerPendingSales(
      {this.dealerId,
      this.dealer,
      this.townName,
      this.totalQuantity,
      this.totalBookedInvoiceValue,
      this.isBulkPack,
      this.dashboardSalesDetails});

  DealerPendingSales.fromJson(Map<String, dynamic> json) {
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

class DashboardSalesDetails {
  String? invoiceNumber;
  String? invoiceDate;
  double? totalInvoiceQuantity;
  double? totalInvoiceValue;
  List<InvoiceList>? invoiceList;

  DashboardSalesDetails(
      {this.invoiceNumber,
        this.invoiceDate,
        this.totalInvoiceQuantity,
        this.totalInvoiceValue,
        this.invoiceList});

  DashboardSalesDetails.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoiceNumber'];
    invoiceDate = json['invoiceDate'];
    totalInvoiceQuantity = json['totalInvoiceQuantity'];
    totalInvoiceValue = json['totalInvoiceValue'];
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
    data['invoiceDate'] = this.invoiceDate;
    data['totalInvoiceQuantity'] = this.totalInvoiceQuantity;
    data['totalInvoiceValue'] = this.totalInvoiceValue;
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
  String? invoiceNumber;

  InvoiceList(
      {this.invoiceId,
        this.invoiceDate,
        this.invoiceQuantity,
        this.invoiceValue,
        this.invoiceNumber});

  InvoiceList.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'];
    invoiceDate = json['invoiceDate'];
    invoiceQuantity = json['invoiceQuantity'];
    invoiceValue = json['invoiceValue'];
    invoiceNumber = json['invoiceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceId'] = this.invoiceId;
    data['invoiceDate'] = this.invoiceDate;
    data['invoiceQuantity'] = this.invoiceQuantity;
    data['invoiceValue'] = this.invoiceValue;
    data['invoiceNumber'] = this.invoiceNumber;
    return data;
  }
}
