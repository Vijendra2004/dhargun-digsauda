import 'dart:convert';

import 'package:adaniwilmar/screen/tdsDeclaration/bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../gmcore/model/Meta.dart';
import '../../../gmcore/network/GMLogger.dart';
import '../../../models/TdsQuestionsModelData.dart';
import '../../../repo/service_repository.dart';
import '../../../utils/constant.dart';

class TdsDeclarationBloc extends Bloc<TdsDeclarationEvent, TdsDeclarationState> {
  TdsDeclarationBloc() : super(TdsDeclarationInitial()) {
    on<TdsQuestionsApiCall>((event, emit) => _getTdsQustionsData(event, emit));
    on<RadioSelectionChanged>((event, emit) => _getRadioChanges(event, emit));
    on<SurveyQuestionSubmit>((event, emit) => _submitSureveyQuestionsApiCall(event, emit));
  }

  /*@override
  Stream<TdsDeclarationState> mapEventToState(
      TdsDeclarationEvent event) async* {
    if (event is RadioSelectionChanged) {
      yield RadioSelected(event.selectedValue);
    }
  }*/

  Future<void> _getRadioChanges(RadioSelectionChanged event, Emitter<TdsDeclarationState> emit) async {
    emit(RadioSelected(event.selectedValue));
  }

  TdsDeclarationInitial get initialState => TdsDeclarationInitial();

  Future<void> _getTdsQustionsData(TdsQuestionsApiCall event, Emitter<TdsDeclarationState> emit) async {
    try {
      emit(LoadProgressBar());
      Meta metaDealerList = await ServiceRepository().getTdsDeclarationQuestions(Constants.formId, Constants.AUTH_USERID);

      if (metaDealerList.statusCode == 200) {
        TdsQuestionModelResponse response = TdsQuestionModelResponse();
        response = TdsQuestionModelResponse.fromJson(jsonDecode(metaDealerList.statusMsg)['response']);
        emit(LoadQuestionData(response: response));
      }
      if (metaDealerList.statusCode == 200) {
        emit(DisableProgressBar());
      } else {
        emit(DisableProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }

      /* final String response =
          await rootBundle.loadString('assets/json/tds_questions.json');
      final Map<String, dynamic> data = jsonDecode(response);
      print("formIdBlocCons--${data.length}");*/
    } catch (error) {
      GMLogger.v(error.toString());
      emit(DisableProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }

  Future<void> _submitSureveyQuestionsApiCall(SurveyQuestionSubmit event, Emitter<TdsDeclarationState> emit) async {
    try {
      emit(LoadProgressBar());
      Meta metaDealerList = await ServiceRepository().submitSurveyQuestionApi(event.requestModel);

      if (metaDealerList.statusCode == 200) {
        emit(const GetSubmitResponse(response: "Sucess"));
      }
      if (metaDealerList.statusCode == 200) {
        emit(DisableProgressBar());
      } else {
        emit(DisableProgressBar());
        emit(OnFailure(error: metaDealerList.statusMsg));
      }

      /* final String response =
          await rootBundle.loadString('assets/json/tds_questions.json');
      final Map<String, dynamic> data = jsonDecode(response);
      print("formIdBlocCons--${data.length}");*/
    } catch (error) {
      emit(DisableProgressBar());
      emit(OnFailure(error: error.toString()));
    }
  }
}
