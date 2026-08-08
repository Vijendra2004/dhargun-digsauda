import 'dart:convert';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/models/StockCreationRequest.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../gmcore/model/Meta.dart';
import '../../../models/SaudaModApprovalRequest.dart';
import '../../../models/stock_sku_model.dart';
import '../../../models/stock_item.dart';
import '../../../repo/service_repository.dart';
import '../../../utils/constant.dart';
import 'stock_creation_event.dart';
import 'stock_creation_state.dart';

class StockCreationBloc extends Bloc<StockCreationEvent, StockCreationState> {
  StockCreationBloc() : super(const StockCreationState()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddStockItem>(_onAddStockItem);
    on<UpdateStockItem>(_onUpdateStockItem);
    on<RemoveStockItem>(_onRemoveStockItem);
    on<SubmitStockList>(_onSubmitStockList);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<StockCreationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      Meta meta = await ServiceRepository().getStockSkuList(SaudaModApprovalRequest());
      if (meta.statusCode == 200) {
        List<dynamic> responseModel = jsonDecode(meta.statusMsg)['response'];
        List<StockSku> productList = responseModel.map((item) {
          return StockSku.fromJson(item as Map<String, dynamic>);
        }).toList();
        emit(state.copyWith(products: productList, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Failed to load products"));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onAddStockItem(AddStockItem event, Emitter<StockCreationState> emit) {
    final updatedList = List<StockItem>.from(state.stockItems)..add(event.item);
    emit(state.copyWith(stockItems: updatedList));
  }

  void _onUpdateStockItem(UpdateStockItem event, Emitter<StockCreationState> emit) {
    final updatedList = List<StockItem>.from(state.stockItems);
    updatedList[event.index] = event.item;
    emit(state.copyWith(stockItems: updatedList));
  }

  void _onRemoveStockItem(RemoveStockItem event, Emitter<StockCreationState> emit) {
    final updatedList = List<StockItem>.from(state.stockItems)..removeAt(event.index);
    emit(state.copyWith(stockItems: updatedList));
  }

  Future<void> _onSubmitStockList(SubmitStockList event, Emitter<StockCreationState> emit) async {
    if (state.stockItems.isEmpty) {
      emit(state.copyWith(errorMessage: "Please add at least one item"));
      return;
    }
    emit(state.copyWith(isLoading: true));
    try {
      List<StockCreationSkuItem> skuList = [];
      for(var item in state.stockItems){
        StockCreationSkuItem skuItem = StockCreationSkuItem(skuId: item.product.id!, noOfCases: item.quantity);
        skuList.add(skuItem);
      }
      StockCreationRequest request = StockCreationRequest(loginUserId: Constants.AUTH_USERID, skuList: skuList);
      Meta meta = await ServiceRepository().saveStockItemsApiCall(request);
      if (meta.statusCode == 200) {
        String responseModel = jsonDecode(meta.statusMsg)['response'];
        emit(state.copyWith(isSuccess: true, isLoading: false,successMessage: responseModel));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Failed to Save Stock Items"));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
