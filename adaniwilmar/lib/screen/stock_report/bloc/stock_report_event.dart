import 'package:equatable/equatable.dart';

abstract class StockReportEvent extends Equatable {
  const StockReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadDropdownData extends StockReportEvent {
  const LoadDropdownData();

  @override
  List<Object?> get props => [];
}

class LoadZH extends StockReportEvent {
  final int NHID;

  LoadZH({required this.NHID});

  @override
  List<Object?> get props => [NHID];
}
class ClearStockReport extends StockReportEvent {}

class LoadST extends StockReportEvent {
  final int ZHId;

  LoadST({required this.ZHId});

  @override
  List<Object?> get props => [ZHId];
}

class LoadDistributor extends StockReportEvent {
  final int STId;

  LoadDistributor({required this.STId});

  @override
  List<Object?> get props => [STId];
}

class FetchStockReportList extends StockReportEvent {
  final int zonalTraderId;
  final int stateTradeId;
  final int distributorId;
  final int pageNo;

  const FetchStockReportList({
    required this.zonalTraderId,
    required this.stateTradeId,
    required this.distributorId,
    this.pageNo = 0,
  });

  @override
  List<Object?> get props =>
      [zonalTraderId, stateTradeId, distributorId, pageNo];
}
