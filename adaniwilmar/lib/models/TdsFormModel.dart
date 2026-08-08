class TdsFormListModel {
  List<TdsFormResponse>? response;
  Null? message;

  TdsFormListModel({this.response, this.message});

  TdsFormListModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <TdsFormResponse>[];
      json['response'].forEach((v) {
        response!.add(new TdsFormResponse.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class TdsFormResponse {
  int? formId;
  String? formName;
  bool? isSubmittedForms;
  bool? isActive;
  bool? isFormStatus;
  int? parentFormId;
  String? parentFormName;

  TdsFormResponse(
      {this.formId,
        this.formName,
        this.isSubmittedForms,
        this.isActive,
        this.isFormStatus,
        this.parentFormId,
        this.parentFormName});

  TdsFormResponse.fromJson(Map<String, dynamic> json) {
    formId = json['formId'];
    formName = json['formName'];
    isActive = json['isActive'];
    isSubmittedForms = json['isSubmittedForms'];
    isFormStatus = json['isFormStatus'];
    parentFormId = json['parentFormId'];
    parentFormName = json['parentFormName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formId'] = this.formId;
    data['formName'] = this.formName;
    data['isActive'] = this.isActive;
    data['isSubmittedForms'] = this.isSubmittedForms;
    data['isFormStatus'] = this.isFormStatus;
    data['parentFormId'] = this.parentFormId;
    data['parentFormName'] = this.parentFormName;
    return data;
  }
}