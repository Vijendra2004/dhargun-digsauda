import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../../gmcore/model/Meta.dart';
import '../../../models/AccountStatementResponse.dart';
import '../../../repo/service_repository.dart';
import 'account_statement_event.dart';
import 'account_statement_state.dart';

class AccountStatementBloc
    extends Bloc<AccountStatementEvent, AccountStatementState> {
  AccountStatementBloc() : super(AccountStatementInitial()) {
    on<AccountDataEvent>(
        (event, emit) => _getAccountStatementDate(event, emit));
    on<AccountStatementCountEvent>(
        (event, emit) => _getAccountStatementCount(event, emit));
    on<AccountStatementStatusUpdate>(
        (event, emit) => _getAccountStatementStatusUpdate(event, emit));
    on<AccountStatementSubmit>(
        (event, emit) => _getAccountStatementSubmit(event, emit));

    on<CustomerStatementEvent>(
        (event, emit) => _getSubmitCustomerStatement(event, emit));
  }

  Future<void> _getAccountStatementDate(
      AccountDataEvent event, Emitter<AccountStatementState> emit) async {
    try {
      emit(AccountStatementLoadProgress());
      Meta metaDealerList = await ServiceRepository().getAccountStatementDate();

      if (metaDealerList.statusCode == 200) {
        AccountStatementDataModel respModel = AccountStatementDataModel();
        respModel = AccountStatementDataModel.fromJson(
            jsonDecode(metaDealerList.statusMsg)['response']);
        emit(LoadAccountStatementData(response: respModel));
      }
      if (metaDealerList.statusCode == 200) {
        emit(AccountStatementHideProgress());
      } else {
        emit(AccountStatementHideProgress());
      }
    } catch (error) {
      emit(AccountStatementHideProgress());
    }
  }

  Future<void> _getAccountStatementCount(AccountStatementCountEvent event,
      Emitter<AccountStatementState> emit) async {
    try {
      emit(AccountStatementLoadProgress());
      Meta metaDealerList =
          await ServiceRepository().getAccountStatementCount();

      if (metaDealerList.statusCode == 200) {
        AccountStatementsResponse respModel = AccountStatementsResponse();
        respModel = AccountStatementsResponse.fromJson(
            jsonDecode(metaDealerList.statusMsg)['response']);
        emit(LoanAccountStatementDataCount(response: respModel));
      }
      if (metaDealerList.statusCode == 200) {
        emit(AccountStatementHideProgress());
      } else {
        emit(AccountStatementHideProgress());
      }
    } catch (error) {
      emit(AccountStatementHideProgress());
    }
  }

  Future<void> _getAccountStatementSubmit(
      AccountStatementSubmit event, Emitter<AccountStatementState> emit) async {
    try {
      emit(AccountStatementLoadProgress());
      Meta metaDealerList = await ServiceRepository()
          .getAccountStatementSubmit(event.accountStatementRequest!);
      if (metaDealerList.statusCode == 200) {
        emit(AccountStatementSubmitResponse());
        emit(AccountStatementHideProgress());
      } else {
        emit(AccountStatementHideProgress());
      }
    } catch (error) {
      emit(AccountStatementHideProgress());
    }
  }

  Future<void> _getAccountStatementStatusUpdate(
      AccountStatementStatusUpdate event,
      Emitter<AccountStatementState> emit) async {
    try {
      emit(AccountStatementLoadProgress());
      Meta metaDealerList = await ServiceRepository()
          .getAccountStatementStatusUpdate(event.requestId);
      if (metaDealerList.statusCode == 200) {
        emit(AccountStatementCountUpdate());
        emit(AccountStatementHideProgress());
      } else {
        emit(AccountStatementHideProgress());
      }
    } catch (error) {
      emit(AccountStatementHideProgress());
    }
  }

  Future<void> _getSubmitCustomerStatement(
      CustomerStatementEvent event, Emitter<AccountStatementState> emit) async {
    try {
      emit(AccountStatementLoadProgress());

      Meta metaDealerList = await ServiceRepository()
          .getSubmitCustomerStatement(event.customerStatement);
      if (metaDealerList.statusCode == 200) {
        emit(AccountStatementSubmitResponse());
      }
      if (metaDealerList.statusCode == 200) {
        emit(AccountStatementHideProgress());
      } else {
        emit(AccountStatementHideProgress());
      }
    } catch (error) {
      emit(AccountStatementHideProgress());
    }
  }
}
