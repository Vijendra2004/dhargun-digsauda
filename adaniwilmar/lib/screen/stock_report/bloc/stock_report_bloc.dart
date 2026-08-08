import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/models/stock_report_model.dart';
import 'package:adaniwilmar/models/stock_submission_model.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import '../../../models/DealerStockResponse.dart';
import 'stock_report_event.dart';
import 'stock_report_state.dart';

class StockReportBloc extends Bloc<StockReportEvent, StockReportState> {
  StockReportBloc() : super(const StockReportState()) {
    on<FetchStockReportList>(_onLoadReports);
    on<LoadDistributor>(_onLoadDistributor);
    on<LoadST>(_onLoadStateTraders);
    on<LoadZH>(_onLoadZonalHead);
    on<ClearStockReport>(_clearStockList);
  }

  final ServiceRepository _repository = ServiceRepository();
  List<StockReportItem> _allStockEntries = [];

  Future<void> _onLoadReports(
      FetchStockReportList event, Emitter<StockReportState> emit) async {
    try {
      final Meta meta =
          await _repository.getDealerStockReportList(event.distributorId);
      emit(state.copyWith(loading: true));
      if (meta.statusCode == 200) {
        try {
          Map<String, dynamic> stockData = {};

          if (meta.response.isNotEmpty) {
            stockData = Map<String, dynamic>.from(meta.response);
          } else {
            stockData = jsonDecode(meta.statusMsg) as Map<String, dynamic>;
          }

          GMLogger.v("Final Stock Data: $stockData");

          if (stockData.containsKey('response')) {
            final DealerStockResponse response =
                DealerStockResponse.fromJson(stockData);

            _allStockEntries = response.response;

            emit(
              state.copyWith(
                loading: false,
                stockEntries: _allStockEntries,
                totalCount: _allStockEntries.length,
                currentPage: event.pageNo,
                error: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                loading: false,
                error: 'Invalid response format received from server',
              ),
            );
          }
        } catch (e) {
          GMLogger.v("Stock Parse Error: $e");

          emit(
            state.copyWith(
              loading: false,
              error: 'Failed to parse server response.',
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: meta.statusMsg?.toString() ??
                'Failed to load stock report (Status: ${meta.statusCode})',
          ),
        );
      }
    } catch (e) {
      GMLogger.v("Stock Report Error: ${e.toString()}");
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadStateTraders(
      LoadST event, Emitter<StockReportState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final Meta meta = await _repository.getStateTradersList(event.ZHId);

      if (meta.statusCode == 200) {
        List<StateTrader> stateTradersList = [];

        try {
          dynamic parsedResponse;
          if (meta.response.isNotEmpty) {
            parsedResponse = meta.response;
          } else if (meta.statusMsg.isNotEmpty) {
            parsedResponse = jsonDecode(meta.statusMsg);
          }
          if (parsedResponse is Map<String, dynamic>) {
            final List<dynamic> responseList = parsedResponse['response'] ?? [];

            stateTradersList =
                responseList.map((e) => StateTrader.fromJson(e)).toList();
          }

          emit(state.copyWith(loading: false, stateTraders: stateTradersList));
        } catch (e) {
          GMLogger.v("Error parsing distributorList: $e");
          emit(state.copyWith(
              loading: false, error: "Unable to parse distributor list"));
        }
      } else {
        emit(state.copyWith(
            loading: false, error: "Failed to load distributor list"));
      }
    } catch (e) {
      GMLogger.v("Error fetching distributorList: ${e.toString()}");
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadZonalHead(
      LoadZH event, Emitter<StockReportState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final Meta meta = await _repository.getZonalheadList(event.NHID);

      if (meta.statusCode == 200) {
        List<ZonalTrader> zonalTraderList = [];

        try {
          dynamic parsedResponse;
          if (meta.response.isNotEmpty) {
            parsedResponse = meta.response;
          } else if (meta.statusMsg.isNotEmpty) {
            parsedResponse = jsonDecode(meta.statusMsg);
          }
          if (parsedResponse is Map<String, dynamic>) {
            final List<dynamic> responseList = parsedResponse['response'] ?? [];

            zonalTraderList =
                responseList.map((e) => ZonalTrader.fromJson(e)).toList();
          }

          emit(state.copyWith(loading: false, zonalTraders: zonalTraderList));
        } catch (e) {
          GMLogger.v("Error parsing distributorList: $e");
          emit(state.copyWith(
              loading: false, error: "Unable to parse distributor list"));
        }
      } else {
        emit(state.copyWith(
            loading: false, error: "Failed to load distributor list"));
      }
    } catch (e) {
      GMLogger.v("Error fetching distributorList: ${e.toString()}");
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadDistributor(
      LoadDistributor event, Emitter<StockReportState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final Meta meta = await _repository.getDistributorList(event.STId);

      if (meta.statusCode == 200) {
        List<Distributor> distributorList = [];

        try {
          dynamic parsedResponse;
          if (meta.response.isNotEmpty) {
            parsedResponse = meta.response;
          } else if (meta.statusMsg.isNotEmpty) {
            parsedResponse = jsonDecode(meta.statusMsg);
          }
          if (parsedResponse is Map<String, dynamic>) {
            final List<dynamic> responseList = parsedResponse['response'] ?? [];

            distributorList =
                responseList.map((e) => Distributor.fromJson(e)).toList();
          }

          emit(state.copyWith(loading: false, distributors: distributorList));
        } catch (e) {
          GMLogger.v("Error parsing distributorList: $e");
          emit(state.copyWith(
              loading: false, error: "Unable to parse distributor list"));
        }
      } else {
        emit(state.copyWith(
            loading: false, error: "Failed to load distributor list"));
      }
    } catch (e) {
      GMLogger.v("Error fetching distributorList: ${e.toString()}");
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  FutureOr<void> _clearStockList(ClearStockReport event, Emitter<StockReportState> emit) {
    _allStockEntries.clear();
    emit(
      state.copyWith(
        stockEntries: [],
        totalCount: 0,
        currentPage: 0,
        hasMore: false,
        error: null,
        loading: false,
      ),
    );
  }
}
