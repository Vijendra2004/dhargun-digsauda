import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/models/call_to_customer_model.dart';
import 'package:adaniwilmar/repo/service_repository.dart';
import 'package:adaniwilmar/screen/customer_ledger/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/network/GMLogger.dart';
import '../../../models/customerLedgerNHResponse.dart';
import '../../../models/customer_ledger_response.dart';
import '../../../models/dealer_response.dart';
import '../../../utils/constant.dart';

class CustomerLedgerBloc
    extends Bloc<CustomerLedgerEvent, CustomerLedgerState> {
  CustomerLedgerBloc() : super(InitialCustomerLedgerState()) {
    on<LoadCustomerLedgerScreen>(
        (event, emit) => _getCustomerLedgerData(event, emit));
    on<LoadLedgerData>((event, emit) => _getLedgerData(event, emit));
    on<LoadCallToCustomer>(
        (event, emit) => _getCallToCustomerData(event, emit));
    on<SaveCallToCustomer>((event, emit) => _saveCallToCusomer(event, emit));

    on<LoadCustomerLedgerNH>(
        (event, emit) => _getCustomerLedgerNHData(event, emit));
  }

  CustomerLedgerState get initialState => InitialCustomerLedgerState();

  Future<void> _getCustomerLedgerData(
      LoadCustomerLedgerScreen event, Emitter<CustomerLedgerState> emit) async {
    try {
      emit(ShowProgressBar());
      List<DistributorList> distList = [];

      Meta metaLedgerList = await ServiceRepository()
          .getCustomerLedger(event.dealerId);
      GMLogger.v("Dealer" + metaLedgerList.statusMsg);
      GMLogger.v("Dealer" + metaLedgerList.statusCode.toString());
      LedgerInfo info = LedgerInfo(currentBalance: 0, customerLedger: [], transactionType: 1);
      if (metaLedgerList.statusCode == 200) {
        info = LedgerInfo.fromJson(
            jsonDecode(metaLedgerList.statusMsg)['response']);
      }

      if (metaLedgerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadSuccess(ledgerInfo: info, distributorList: distList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaLedgerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getLedgerData(
      LoadLedgerData event, Emitter<CustomerLedgerState> emit) async {
    try {
      emit(ShowProgressBar());

      Meta metaLedgerList = await ServiceRepository()
          .getCustomerLedger(event.dealerId.toString());
      GMLogger.v("Dealer" + metaLedgerList.statusMsg);
      GMLogger.v("Dealer" + metaLedgerList.statusCode.toString());
      LedgerInfo info = LedgerInfo(currentBalance: 0, transactionType: 1, customerLedger: []);
      if (metaLedgerList.statusCode == 200) {
        info = LedgerInfo.fromJson(
            jsonDecode(metaLedgerList.statusMsg)['response']);
      }

      if (metaLedgerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLedgerDataSuccess(ledgerInfo: info));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaLedgerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getCallToCustomerData(
      LoadCallToCustomer event, Emitter<CustomerLedgerState> emit) async {
    try {
      emit(ShowProgressBar());

      Meta metaDealerList = await ServiceRepository()
          .getCallToCustomerList(Constants.AUTH_USERID, bdoIds: event.bdoIds);
      GMLogger.v("Dealer" + metaDealerList.statusMsg);
      GMLogger.v("Dealer" + metaDealerList.statusCode.toString());
      List<CallToCustomerList> custList = [];
      if (metaDealerList.statusCode == 200) {
        jsonDecode(metaDealerList.statusMsg)['response']
            .forEach((f) => custList.add(CallToCustomerList.fromJson(f)));
      }

      if (metaDealerList.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadCallToCustomerSuccess(distributorList: custList));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _saveCallToCusomer(
      SaveCallToCustomer event, Emitter<CustomerLedgerState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta savedSauda = await ServiceRepository().saveCallToCustomer(
          event.BDOId, event.dealerMobileNumber, event.dealerId);
      GMLogger.v(savedSauda.statusCode.toString());
      GMLogger.v(savedSauda.statusMsg);
      if (savedSauda.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnSaveSuccess(
            mobileNumber: jsonDecode(savedSauda.statusMsg)['response'] == null
                ? event.dealerMobileNumber
                : jsonDecode(savedSauda.statusMsg)['response']));
      } else {
        emit(HideProgressBar());
        emit(OnSaveSuccess(mobileNumber: event.dealerMobileNumber));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _getCustomerLedgerNHData(
      LoadCustomerLedgerNH event, Emitter<CustomerLedgerState> emit) async {
    try {
      emit(ShowProgressBar());
      Meta metaCustomerLedger =
          await ServiceRepository().getCustomerLedgerNHData(event.userId);
      GMLogger.v(metaCustomerLedger.statusCode.toString());
      GMLogger.v(metaCustomerLedger.statusMsg);
      CustomerLedgerNHResponse customerLedgerNHResponse =
          CustomerLedgerNHResponse(
              totalOutStandingBalance: 0, transactionType: 1, customerLedgerNH: []);
      if (metaCustomerLedger.statusCode == 200) {
        customerLedgerNHResponse = CustomerLedgerNHResponse.fromJson(
            jsonDecode(metaCustomerLedger.statusMsg)['response']);
      }
      if (metaCustomerLedger.statusCode == 200) {
        emit(HideProgressBar());
        emit(OnLoadCustomerLedgerSuccess(
            customerLedgerNHResponse: customerLedgerNHResponse));
      } else {
        emit(HideProgressBar());
        emit(OnFailure(error: metaCustomerLedger.statusMsg));
      }
    } catch (error) {
      GMLogger.v(error.toString());
      emit(HideProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
