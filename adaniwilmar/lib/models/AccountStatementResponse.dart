class AccountStatementResponse {
  AccountStatementDataModel? response;

  AccountStatementResponse({this.response});

  AccountStatementResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? AccountStatementDataModel.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class AccountStatementDataModel {
  String? name;
  String? key;
  String? value;
  bool? isactive;
  int? typeId;
  int? id;

  AccountStatementDataModel({this.name, this.key, this.value, this.isactive, this.typeId, this.id});

  AccountStatementDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    value = json['value'];
    isactive = json['isactive'];
    typeId = json['typeId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['key'] = key;
    data['value'] = value;
    data['isactive'] = isactive;
    data['typeId'] = typeId;
    data['id'] = id;
    return data;
  }
}

class AccountStatementsResponse {

  AccountStatements? accountStatements;

  AccountStatementsResponse({this.accountStatements});

  AccountStatementsResponse.fromJson(Map<String, dynamic> json) {
    if (json['accountStatements'] != null) {
      accountStatements = AccountStatements.fromJson(json['accountStatements']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (accountStatements != null) {
      data['accountStatements'] = accountStatements!.toJson();
    }
    return data;
  }
}


class AccountStatements {
  int? totalcount;
  int? customerUserId;
  bool? isSubmitted;
  int? requestId;
  String? countLimit;

  AccountStatements({this.totalcount, this.customerUserId, this.isSubmitted, this.requestId, this.countLimit});

  AccountStatements.fromJson(Map<String, dynamic> json) {
    totalcount = json['totalcount'];
    customerUserId = json['customerUserId'];
    isSubmitted = json['isSubmitted'];
    requestId = json['requestid'];
    countLimit = json['countLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalcount'] = totalcount;
    data['customerUserId'] = customerUserId;
    data['isSubmitted'] = isSubmitted;
    data['requestid'] = requestId;
    data['countLimit'] =countLimit;
    return data;
  }
}


class CustomerStatement {

  String? requestID;
  String? companyCode;
  String? customer;
  String? dateFrom;
  String? dateTo;
  String? currency;
  String? withoutSpecialGL;
  String? withSpecialGL;
  String? withSpecialGLAOnly;
  String? withSpecialGLHOnly;
  String? withSpecialGL3Only;
  String? withSpecialGL4Only;
  String? email;
  String? excel;
  String? pDF;

  CustomerStatement(
      {this.requestID,
        this.companyCode,
        this.customer,
        this.dateFrom,
        this.dateTo,
        this.currency,
        this.withoutSpecialGL,
        this.withSpecialGL,
        this.withSpecialGLAOnly,
        this.withSpecialGLHOnly,
        this.withSpecialGL3Only,
        this.withSpecialGL4Only,
        this.email,
        this.excel,
        this.pDF});

  CustomerStatement.fromJson(Map<String, dynamic> json) {
    requestID = json['Request_ID'];
    companyCode = json['Company_Code'];
    customer = json['Customer'];
    dateFrom = json['Date_from'];
    dateTo = json['Date_to'];
    currency = json['Currency'];
    withoutSpecialGL = json['Without_Special_GL'];
    withSpecialGL = json['With_Special_GL'];
    withSpecialGLAOnly = json['With_Special_GL_A_only'];
    withSpecialGLHOnly = json['With_Special_GL_H_only'];
    withSpecialGL3Only = json['With_Special_GL_3_only'];
    withSpecialGL4Only = json['With_Special_GL_4_only'];
    email = json['Email'];
    excel = json['Excel'];
    pDF = json['PDF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Request_ID'] = requestID;
    data['Company_Code'] = companyCode;
    data['Customer'] = customer;
    data['Date_from'] = dateFrom;
    data['Date_to'] = dateTo;
    data['Currency'] = currency;
    data['Without_Special_GL'] = withoutSpecialGL;
    data['With_Special_GL'] = withSpecialGL;
    data['With_Special_GL_A_only'] = withSpecialGLAOnly;
    data['With_Special_GL_H_only'] = withSpecialGLHOnly;
    data['With_Special_GL_3_only'] = withSpecialGL3Only;
    data['With_Special_GL_4_only'] = withSpecialGL4Only;
    data['Email'] = email;
    data['Excel'] = excel;
    data['PDF'] = pDF;
    return data;
  }
}

