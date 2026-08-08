import 'package:equatable/equatable.dart';
import '../../../models/stock_item.dart';
import '../../../models/oiltype_skulist.dart';
import '../../../models/stock_sku_model.dart';

class StockCreationState extends Equatable {
  final List<StockItem> stockItems;
  final List<StockSku> products;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool isSuccess;

  const StockCreationState({
    this.stockItems = const [],
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isSuccess = false,
  });

  StockCreationState copyWith({
    List<StockItem>? stockItems,
    List<StockSku>? products,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? isSuccess,
  }) {
    return StockCreationState(
      stockItems: stockItems ?? this.stockItems,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isSuccess: isSuccess ?? false,
    );
  }

  @override
  List<Object?> get props => [stockItems, products, isLoading, errorMessage, isSuccess,successMessage];
}
