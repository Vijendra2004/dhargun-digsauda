class AccountStatementRequest {
  int? id;
  int? loginUserId;
  String? companyName;
  String? customerName;
  String? fromDate;
  String? toDate;
  String? currency;
  bool? isWithoutSpecialGL;
  int? documentType;
  bool? isActive;

  AccountStatementRequest(
      {this.id,
        this.loginUserId,
        this.companyName,
        this.customerName,
        this.fromDate,
        this.toDate,
        this.currency,
        this.isWithoutSpecialGL,
        this.documentType,
        this.isActive});

  AccountStatementRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    loginUserId = json['LoginUserId'];
    companyName = json['CompanyName'];
    customerName = json['CustomerName'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    currency = json['Currency'];
    isWithoutSpecialGL = json['IsWithoutSpecialGL'];
    documentType = json['DocumentType'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['LoginUserId'] = this.loginUserId;
    data['CompanyName'] = this.companyName;
    data['CustomerName'] = this.customerName;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['Currency'] = this.currency;
    data['IsWithoutSpecialGL'] = this.isWithoutSpecialGL;
    data['DocumentType'] = this.documentType;
    data['IsActive'] = this.isActive;
    return data;
  }
}