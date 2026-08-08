import 'dart:convert';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:bloc/bloc.dart';
import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/stock_submission_model.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'stock_list_event.dart';
import 'stock_list_state.dart';

class StockListBloc extends Bloc<StockListEvent, StockListState> {
  final ServiceRepository _repository = ServiceRepository();
  List<StockEntry> _allStockEntries = [];
  int _totalCount = 0;

  StockListBloc() : super(StockListInitial()) {

    on<FetchStockList>((event, emit) async {
      emit(StockListLoading());
      try {
        final Meta meta = await _repository.getStockSubmissionList(event.pageNo);

        if (meta.statusCode == 200) {
          Map<String, dynamic> stockData = {};

          // Try to extract the response data from various possible locations
          if (meta.response.isNotEmpty) {
            stockData = meta.response;
          } else {
              // Try parsing statusMsg as JSON string if needed
              try {
                if (meta.statusMsg.isNotEmpty) {
                  dynamic parsed = jsonDecode(meta.statusMsg);
                  if (parsed is Map<String, dynamic>) {
                    Map<String, dynamic> parsedMap = parsed;
                    // Check if data is nested under 'response' key
                    if (parsedMap.containsKey('response')) {
                      stockData = parsedMap['response'] as Map<String, dynamic>;
                    } else {
                      stockData = parsedMap;
                    }
                  }
                }
              } catch (e) {
                GMLogger.v("Error parsing statusMsg as JSON: $e");
              }
          }

          GMLogger.v("Final Stock Data: ${stockData.toString()}");

          if (stockData.isNotEmpty && stockData.containsKey('stockEntries')) {
            final StockSubmissionResponse response =
                StockSubmissionResponse.fromJson(stockData);

            _totalCount = response.listCount;

            if (event.pageNo == 0) {
              _allStockEntries = response.stockEntries;
            } else {
              _allStockEntries.addAll(response.stockEntries);
            }

            final hasMore = _allStockEntries.length < _totalCount;

            emit(StockListLoaded(
              stockEntries: _allStockEntries,
              totalCount: _totalCount,
              currentPage: event.pageNo,
              hasMore: hasMore,
            ));
          } else {
            emit(const StockListError(
              message: 'Invalid response format received from server',
            ));
          }
        } else {
          emit(StockListError(
            message: meta.statusMsg.isNotEmpty
                ? meta.statusMsg
                : 'Failed to load stock list (Status: ${meta.statusCode})',
          ));
        }
      } catch (e) {
        GMLogger.v("Stock List Error: ${e.toString()}");
        emit(StockListError(message: e.toString()));
      }
    });
  }
}
