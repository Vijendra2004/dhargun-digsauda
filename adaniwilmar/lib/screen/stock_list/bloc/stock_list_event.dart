import 'package:equatable/equatable.dart';

abstract class StockListEvent extends Equatable {
  const StockListEvent();

  @override
  List<Object?> get props => [];
}

class FetchStockList extends StockListEvent {
  final int pageNo;

  const FetchStockList({this.pageNo = 0});

  @override
  List<Object?> get props => [pageNo];
}


