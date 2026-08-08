class InvoiceDetail {
  int? invoiceId;
  String? invoiceNumber;
  String? invoiceDate;
  double? invoiceQuantity;
  double? totalInvoiceValue;
  double? pendingInvoiceValue;
  List<InvoiceSKUDetails>? invoiceSKUDetails;

  InvoiceDetail(
      {this.invoiceId,
      this.invoiceNumber,
      this.invoiceDate,
      this.invoiceQuantity,
      this.totalInvoiceValue,
      this.pendingInvoiceValue,
      this.invoiceSKUDetails});

  InvoiceDetail.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'];
    invoiceNumber = json['invoiceNumber'];
    invoiceDate = json['invoiceDate'];
    invoiceQuantity = json['invoiceQuantity'];
    totalInvoiceValue = json['totalInvoiceValue'];
    pendingInvoiceValue = json['pendingInvoiceValue'];
    if (json['invoiceSKUDetails'] != null) {
      invoiceSKUDetails = <InvoiceSKUDetails>[];
      json['invoiceSKUDetails'].forEach((v) {
        invoiceSKUDetails!.add(InvoiceSKUDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceId'] = invoiceId;
    data['invoiceNumber'] = invoiceNumber;
    data['invoiceDate'] = invoiceDate;
    data['invoiceQuantity'] = invoiceQuantity;
    data['totalInvoiceValue'] = totalInvoiceValue;
    data['pendingInvoiceValue'] = pendingInvoiceValue;
    if (invoiceSKUDetails != null) {
      data['invoiceSKUDetails'] =
          invoiceSKUDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceSKUDetails {
  int? skuId;
  String? sku;
  int? oilTypeId;
  String? oilType;
  double? quantityInCase;
  double? quantity;
  double? qunatityPrice;

  InvoiceSKUDetails(
      {this.skuId,
      this.sku,
      this.oilTypeId,
      this.oilType,
      this.quantityInCase,
      this.quantity,
      this.qunatityPrice});

  InvoiceSKUDetails.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    sku = json['sku'];
    oilTypeId = json['oilTypeId'];
    oilType = json['oilType'];
    quantityInCase = json['quantityInCase'];
    quantity = json['quantity'];
    qunatityPrice = json['qunatityPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['sku'] = sku;
    data['oilTypeId'] = oilTypeId;
    data['oilType'] = oilType;
    data['quantityInCase'] = quantityInCase;
    data['quantity'] = quantity;
    data['qunatityPrice'] = qunatityPrice;
    return data;
  }
}
