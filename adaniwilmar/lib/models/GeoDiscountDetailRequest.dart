class GeoDiscountDetailRequest {
  int? id;
  int? parentId;
  int? verticalId;
  int? pageNumber;
  int? pageSize;
  bool? isRequestFromWeb;

  GeoDiscountDetailRequest(
      {this.id,
        this.parentId,
        this.verticalId,
        this.pageNumber,
        this.pageSize,
        this.isRequestFromWeb});

GeoDiscountDetailRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    parentId = json['ParentId'];
    verticalId = json['VerticalId'];
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
    isRequestFromWeb = json['IsRequestFromWeb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ParentId'] = this.parentId;
    data['VerticalId'] = this.verticalId;
    data['PageNumber'] = this.pageNumber;
    data['PageSize'] = this.pageSize;
    data['IsRequestFromWeb'] = this.isRequestFromWeb;
    return data;
  }
}