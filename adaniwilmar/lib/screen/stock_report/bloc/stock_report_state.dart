import 'package:equatable/equatable.dart';

import '../../../models/DealerStockResponse.dart';
import '../../../models/stock_report_model.dart';
import '../../../models/stock_submission_model.dart';

class StockReportState extends Equatable {
  final bool loading;
  final String? error;

  final List<ZonalTrader> zonalTraders;
  final List<StateTrader> stateTraders;
  final List<Distributor> distributors;

  final List<StockReportItem> stockEntries;

  final int totalCount;
  final int currentPage;
  final bool hasMore;

  const StockReportState({
    this.loading = false,
    this.error,
    this.zonalTraders = const [],
    this.stateTraders = const [],
    this.distributors = const [],
    this.stockEntries = const [],
    this.totalCount = 0,
    this.currentPage = 0,
    this.hasMore = false,
  });

  StockReportState copyWith({
    bool? loading,
    String? error,
    List<ZonalTrader>? zonalTraders,
    List<StateTrader>? stateTraders,
    List<Distributor>? distributors,
    List<StockReportItem>? stockEntries,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
  }) {
    return StockReportState(
      loading: loading ?? this.loading,
      error: error,
      zonalTraders: zonalTraders ?? this.zonalTraders,
      stateTraders: stateTraders ?? this.stateTraders,
      distributors: distributors ?? this.distributors,
      stockEntries: stockEntries ?? this.stockEntries,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error,
    zonalTraders,
    stateTraders,
    distributors,
    stockEntries,
    totalCount,
    currentPage,
    hasMore,
  ];
}