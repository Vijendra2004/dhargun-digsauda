import 'package:flutter/cupertino.dart';

import '../gmcore/network/GMLogger.dart';

class TdsQuestionModel {
  TdsQuestionModelResponse? response;

  TdsQuestionModel({this.response});

  TdsQuestionModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new TdsQuestionModelResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class TdsQuestionModelResponse {
  int? sectionId;
  Null? sectionName;
  int? questionsCount;
  Null? selectedQuestionsString;
  Null? unselectedQuestionsString;
  bool? postStatus;
  Null? postMessage;
  List<Questions>? questions;

  TdsQuestionModelResponse(
      {this.sectionId,
      this.sectionName,
      this.questionsCount,
      this.selectedQuestionsString,
      this.unselectedQuestionsString,
      this.postStatus,
      this.postMessage,
      this.questions});

  TdsQuestionModelResponse.fromJson(Map<String, dynamic> json) {
    sectionId = json['sectionId'];
    sectionName = json['sectionName'];
    questionsCount = json['questionsCount'];
    selectedQuestionsString = json['selectedQuestionsString'];
    unselectedQuestionsString = json['unselectedQuestionsString'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sectionId'] = this.sectionId;
    data['sectionName'] = this.sectionName;
    data['questionsCount'] = this.questionsCount;
    data['selectedQuestionsString'] = this.selectedQuestionsString;
    data['unselectedQuestionsString'] = this.unselectedQuestionsString;
    data['postStatus'] = this.postStatus;
    data['postMessage'] = this.postMessage;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? questionTypeId;
  String? questionTypeName;
  int? questionId;
  int? orderNo;
  String answer = "Hello";
  String? query;
  String? textlength;
  String? description;
  bool? isDeleted;
  bool? isActive;
  bool? isMandatory;
  String? submittedAnswer;
  int? orderId;
  String? createdDate;
  Null? modifiedDate;
  String? answerOutput = "";
  String? answerOutputQuestionId = "";
  List<AnswerOptions>? answerOptions;
  TextEditingController? controller = TextEditingController();
  int? maxLength;

  Questions(
      {this.questionTypeId,
      this.questionTypeName,
      this.questionId,
      this.orderNo,
      this.query,
      this.textlength,
      this.maxLength,
      this.description,
      this.isDeleted,
      this.isActive,
      this.isMandatory,
      this.submittedAnswer,
      this.orderId,
      this.createdDate,
      this.modifiedDate,
      this.answerOptions});

  Questions.fromJson(Map<String, dynamic> json) {
    questionTypeId = json['questionTypeId'];
    questionTypeName = json['questionTypeName'];
    questionId = json['questionId'];
    orderNo = json['orderNo'];
    query = json['query'];
    textlength = json['textlength'];
    String textLengthText = textlength ?? '';
    if(textLengthText.isNotEmpty){
      maxLength = int.parse(textLengthText);
      GMLogger.v("maxLength $maxLength");
    }else{
     // maxLength = 100;
    }
    description = json['description'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    isMandatory = json['isMandatory'];
    orderId = json['orderId'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    submittedAnswer = json['submittedAnswer'];
    if (json['answerOptions'] != null) {
      answerOptions = <AnswerOptions>[];
      json['answerOptions'].forEach((v) {
        answerOptions!.add(new AnswerOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionTypeId'] = this.questionTypeId;
    data['questionTypeName'] = this.questionTypeName;
    data['questionId'] = this.questionId;
    data['orderNo'] = this.orderNo;
    data['query'] = this.query;
    data['description'] = this.description;
    data['isDeleted'] = this.isDeleted;
    data['isActive'] = this.isActive;
    data['submittedAnswer'] = this.submittedAnswer;
    data['isMandatory'] = this.isMandatory;
    data['orderId'] = this.orderId;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    if (this.answerOptions != null) {
      data['answerOptions'] =
          this.answerOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswerOptions {
  int? questionId;
  int? answerOptionId;
  String? option;

  AnswerOptions({this.questionId, this.answerOptionId, this.option});

  AnswerOptions.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    answerOptionId = json['answerOptionId'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['answerOptionId'] = this.answerOptionId;
    data['option'] = this.option;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerOptions &&
          runtimeType == other.runtimeType &&
          option == other.option;

  @override
  int get hashCode => option.hashCode;
}
