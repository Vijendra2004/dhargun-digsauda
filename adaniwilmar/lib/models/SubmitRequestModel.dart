
class SubmitRequestModel {
  final int formId;
  final int userId;
  final List<QuestionAnswer> questionAnswer;

  SubmitRequestModel({
    required this.formId,
    required this.userId,
    required this.questionAnswer,
  });

  // Convert a RequestModel instance to a JSON map
  Map<String, dynamic> toJson() => {
    'formId': formId,
    'UserId': userId,
    'QuestionAnswer': questionAnswer.map((qa) => qa.toJson()).toList(),
  };

  // Convert a JSON map to a RequestModel instance
  factory SubmitRequestModel.fromJson(Map<String, dynamic> json) => SubmitRequestModel(
    formId: json['formId'],
    userId: json['UserId'],
    questionAnswer: (json['QuestionAnswer'] as List<dynamic>)
        .map((item) => QuestionAnswer.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}

class QuestionAnswer {
  int QuestionId;
  String? answer;

  QuestionAnswer({
    required this.QuestionId,
    required this.answer,
  });

  // Convert a QuestionAnswer instance to a JSON map
  Map<String, dynamic> toJson() => {
    'QuestionId': QuestionId,
    'Answer': answer,
  };

  // Convert a JSON map to a QuestionAnswer instance
  factory QuestionAnswer.fromJson(Map<String, dynamic> json) => QuestionAnswer(
    QuestionId: json['QuestionId'],
    answer: json['Answer'],
  );

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
