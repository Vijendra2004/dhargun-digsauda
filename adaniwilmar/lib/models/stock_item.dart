import 'package:adaniwilmar/models/stock_sku_model.dart';

class StockItem {
  final StockSku product;
  final double quantity;

  StockItem({
    required this.product,
    required this.quantity,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      product: StockSku.fromJson(json['product']),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}