import 'package:equatable/equatable.dart';
import '../../../models/stock_item.dart';

abstract class StockCreationEvent extends Equatable {
  const StockCreationEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends StockCreationEvent {}

class AddStockItem extends StockCreationEvent {
  final StockItem item;

  const AddStockItem(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateStockItem extends StockCreationEvent {
  final int index;
  final StockItem item;

  const UpdateStockItem(this.index, this.item);

  @override
  List<Object?> get props => [index, item];
}

class RemoveStockItem extends StockCreationEvent {
  final int index;

  const RemoveStockItem(this.index);

  @override
  List<Object?> get props => [index];
}

class SubmitStockList extends StockCreationEvent {}
