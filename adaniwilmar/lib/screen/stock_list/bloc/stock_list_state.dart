import 'package:equatable/equatable.dart';
import 'package:adaniwilmar/models/stock_submission_model.dart';

abstract class StockListState extends Equatable {
  const StockListState();

  @override
  List<Object?> get props => [];
}

class StockListInitial extends StockListState {}

class StockListLoading extends StockListState {}

class StockListLoaded extends StockListState {
  final List<StockEntry> stockEntries;
  final int totalCount;
  final int currentPage;
  final bool hasMore;

  const StockListLoaded({
    required this.stockEntries,
    required this.totalCount,
    this.currentPage = 0,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [stockEntries, totalCount, currentPage, hasMore];
}

class StockListError extends StockListState {
  final String message;

  const StockListError({required this.message});

  @override
  List<Object?> get props => [message];
}
