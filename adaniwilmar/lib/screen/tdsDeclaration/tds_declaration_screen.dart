import 'dart:collection';

import 'package:adaniwilmar/widget/ModalRoundedProgressBar.dart';
import 'package:adaniwilmar/widget/multiselect/dialog/multi_select_dialog_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/constant.dart';
import '../../models/SubmitRequestModel.dart';
import '../../models/TdsQuestionsModelData.dart';
import '../../utils/constant.dart';
import '../../widget/multiselect/util/multi_select_item.dart';
import '../../widget/widget.dart';
import 'bloc/tds_declaration_bloc.dart';
import 'bloc/tds_declaration_event.dart';
import 'bloc/tds_declaration_state.dart';

class TDSDeclarationScreen extends StatelessWidget {
  final dynamic argument;

  const TDSDeclarationScreen({Key? key, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TdsDeclarationBloc()..add(TdsQuestionsApiCall(formId: 1)),
      child: const TDSDeclarationData(),
    );
  }
}

class TDSDeclarationData extends StatefulWidget {
  const TDSDeclarationData({Key? key}) : super(key: key);

  @override
  State<TDSDeclarationData> createState() => _TdsDeclarationDataState();
}

class _TdsDeclarationDataState extends State<TDSDeclarationData> {
  ProgressBarHandler? _handler;
  String selectedRadioItem = "";
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List<Questions> dataModel = [];
  List<QuestionAnswer> questionAnswerDataModel = [];
  TdsQuestionModelResponse questionModel = TdsQuestionModelResponse();
  HashMap<String, dynamic> selectedvalues = HashMap();
  bool isSubmittedForm = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    isSubmittedForm = Constants.isSubmitted;
    screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;

    SubmitRequestModel? request;

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return () {};
      },
    );

    return BlocListener<TdsDeclarationBloc, TdsDeclarationState>(
        listener: (context, state) {
          if (state is LoadProgressBar) {
            _handler!.show!();
          }
          if (state is DisableProgressBar) {
            _handler!.dismiss!();
          }
          if (state is TdsQuestionsGetResponseModel) {
          }
          if (state is GetSubmitResponse) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Form Submitted Successfully!")));
            Navigator.pop(context, "return");
          }
          if (state is LoadQuestionData) {
            setState(() {
              questionModel = state.response;
            });
          }
          if (state is RadioSelected) {
            setState(() {
              selectedRadioItem = state.selectedValue;
            });
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: Constants.formName.isNotEmpty ? Constants.formName : "Tds Declaration",
            backArrow: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Container(
                    height: screenHeight,
                    margin: const EdgeInsets.only(top: 64),
                    child: CurveOuterBox(
                        boxLRPadding: 0,
                        boxTBPadding: 0,
                        boxofWidget: SizedBox(
                          height: screenHeight,
                          width: screenWidth,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: getDynamicFields(questionModel),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: !isSubmittedForm,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
                          child: Row(children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
                                  onPressed: () {
                                    questionAnswerDataModel.clear();
                                    for (int i = 0; i < dataModel.length; i++) {
                                      if (dataModel[i].isMandatory! && dataModel[i].answerOutput == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill ${dataModel[i].query} fields")));
                                        return;
                                      } else if (dataModel[i].isMandatory! && dataModel[i].answerOutput!.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill ${dataModel[i].query} fields")));
                                        return;
                                      } else if (dataModel[i].answerOutput!.isNotEmpty && dataModel[i].answerOutputQuestionId!.isNotEmpty) {
                                        QuestionAnswer questionAnswer = QuestionAnswer(QuestionId: int.parse(dataModel[i].answerOutputQuestionId!), answer: dataModel[i].answerOutput);

                                        questionAnswerDataModel.add(questionAnswer);

                                        request = SubmitRequestModel(
                                          formId: Constants.formId,
                                          userId: Constants.AUTH_USERID,
                                          questionAnswer: questionAnswerDataModel,
                                        );
                                      }

                                      /*if (dataModel[i]
                                              .answerOutput!
                                              .isNotEmpty &&
                                          dataModel[i]
                                              .answerOutputQuestionId!
                                              .isNotEmpty) {
                                        QuestionAnswer questionAnswer =
                                            QuestionAnswer(
                                                QuestionId: int.parse(dataModel[
                                                        i]
                                                    .answerOutputQuestionId!),
                                                answer:
                                                    dataModel[i].answerOutput);

                                        questionAnswerDataModel
                                            .add(questionAnswer);

                                        print(
                                            "dataValueeQuestion--${questionAnswerDataModel.length}");

                                        request = SubmitRequestModel(
                                          formId: Constants.formId,
                                          userId: Constants.AUTH_USERID,
                                          questionAnswer:
                                              questionAnswerDataModel,
                                        );
                                      } else {
                                        if (dataModel[i].isMandatory!) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please fill ${dataModel[i].query} field")));
                                        }

                                        return;
                                      }*/
                                    }

                                    BlocProvider.of<TdsDeclarationBloc>(context).add(SurveyQuestionSubmit(request!));
                                  },
                                  child: Text("Submit")),
                            )
                          ]),
                        )),
                  ),
                ),
                progressBar
              ],
            ),
          ),
        ));
  }

  List<Widget> getDynamicFields(TdsQuestionModelResponse questionmodel) {
    List<Widget> dynamicWidgets = [];
    List<Questions> questions = questionmodel.questions ?? [];
    var multiSelectValues = [];
    if (questions.isNotEmpty) {
      List<Object?> _selectedValues = <AnswerOptions>[];
      AnswerOptions? _selectedItems;
      dataModel = questionmodel.questions!;
      for (int i = 0; i < dataModel.length; i++) {
        switch (dataModel[i].questionTypeId) {
          case 1:
            {
              dataModel[i].controller?.text = dataModel[i].submittedAnswer ?? "";
              dynamicWidgets.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: RichText(
                        text: TextSpan(
                            text: ((i + 1).toString()) + ". " + dataModel[i].query!,
                            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: Constant.fontWeight600, fontFamily: 'Aganè'),
                            children: [
                              TextSpan(
                                text: dataModel[i].isMandatory! ? "*" : "",
                                style: TextStyle(color: dataModel[i].isMandatory! ? Colors.red : null),
                              )
                            ]),
                      )),
                  const SizedBox(height: 5),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLength: dataModel[i].maxLength != null ? dataModel[i].maxLength : null,
                    maxLines: 1,
                    controller: dataModel[i].submittedAnswer!.isNotEmpty ? dataModel[i].controller : null,
                    onChanged: (value) {
                      dataModel[i].answerOutput = value;
                      dataModel[i].answerOutputQuestionId = dataModel[i].questionId.toString();
                    },
                    style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: Constant.fontWeight400),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      enabled: !isSubmittedForm,
                    ),
                  )
                ],
              ));
            }
            break;
          case 2:
            {
              dynamicWidgets.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: RichText(
                        text: TextSpan(
                            text: ((i + 1).toString()) + ". " + dataModel[i].query!,
                            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: Constant.fontWeight600, fontFamily: 'Aganè'),
                            children: [
                              TextSpan(
                                text: dataModel[i].isMandatory! ? "*" : "",
                                style: TextStyle(color: dataModel[i].isMandatory! ? Colors.red : null),
                              )
                            ]),
                      )),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Radio<String>(
                        activeColor: Colors.orange,
                        value: "Yes",
                        groupValue: dataModel[i].submittedAnswer!.isNotEmpty ? dataModel[i].submittedAnswer : dataModel[i].answerOutput,
                        onChanged: !isSubmittedForm
                            ? (value) {
                                setState(() {
                                  select = "";
                                  select = value!;
                                  dataModel[i].answerOutput = value;
                                  dataModel[i].answerOutputQuestionId = dataModel[i].questionId.toString();
                                });
                              }
                            : null,
                      ),
                      const Text("Yes"),
                      Radio<String>(
                        activeColor: Colors.orange,
                        value: "No",
                        groupValue: dataModel[i].submittedAnswer!.isNotEmpty ? dataModel[i].submittedAnswer! : dataModel[i].answerOutput,
                        onChanged: !isSubmittedForm
                            ? (value) {
                                setState(() {
                                  select = "";
                                  select = value!;
                                  dataModel[i].answerOutput = value;
                                  dataModel[i].answerOutputQuestionId = dataModel[i].questionId.toString();
                                });
                              }
                            : null,
                      ),
                      const Text("No")
                    ],
                  )
                ],
              ));
            }
            break;
          case 3:
            {
              AnswerOptions? _currentSelectedItems;
              if (dataModel[i].submittedAnswer!.isNotEmpty) {
                _currentSelectedItems = AnswerOptions(option: dataModel[i].submittedAnswer);
              } else if (dataModel[i].answerOutput != null && dataModel[i].answerOutput!.isNotEmpty) {
                _currentSelectedItems = AnswerOptions(option: dataModel[i].answerOutput);
              }

              dynamicWidgets.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: RichText(
                        text: TextSpan(
                            text: ((i + 1).toString()) + ". " + dataModel[i].query!,
                            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: Constant.fontWeight600, fontFamily: 'Aganè'),
                            children: [
                              TextSpan(
                                text: dataModel[i].isMandatory! ? "*" : "",
                                style: TextStyle(color: dataModel[i].isMandatory! ? Colors.red : null),
                              )
                            ]),
                      )),
                  const SizedBox(height: 5),
                  CommonDropdownButtonFormField<AnswerOptions?>(
                    value: dataModel[i].answerOptions!.contains(_currentSelectedItems) ? _currentSelectedItems : null,
                    label: "Select",
                    onChanged: !isSubmittedForm
                        ? (AnswerOptions? newValue) {
                            setState(() {
                              dataModel[i].answerOutput = newValue?.option ?? "";
                              dataModel[i].answerOutputQuestionId = dataModel[i].questionId.toString();
                            });
                          }
                        : null,
                    items: dataModel[i].answerOptions!.map((AnswerOptions item) {
                      return DropdownMenuItem<AnswerOptions>(
                        value: item,
                        child: Text(
                          item.option!,
                          softWrap: true,
                        ),
                      );
                    }).toList(),
                  )
                ],
              ));
            }
            break;

          case 4:
            {
              if (dataModel[i].submittedAnswer != null) {
                if (dataModel[i].submittedAnswer!.isNotEmpty) {
                  if (dataModel[i].submittedAnswer!.contains(",")) {
                    var answers = dataModel[i].submittedAnswer!.split(',').map((s) => s.trim()).toList();

                    // Add each answer to the list as AnswerOptions
                    for (var answer in answers) {
                      multiSelectValues.add(AnswerOptions(option: answer));
                    }
                  } else {
                    multiSelectValues = [AnswerOptions(option: dataModel[i].submittedAnswer!)];
                  }
                }
              }
              dynamicWidgets.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: RichText(
                    text: TextSpan(
                        text: ((i + 1).toString()) + ". " + dataModel[i].query!,
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: Constant.fontWeight600, fontFamily: 'Aganè'),
                        children: [
                          TextSpan(
                            text: dataModel[i].isMandatory! ? "*" : "",
                            style: TextStyle(color: dataModel[i].isMandatory! ? Colors.red : null),
                          )
                        ]),
                  ),
                ),
                const SizedBox(height: 5),
                IgnorePointer(
                  ignoring: isSubmittedForm,
                  child: MultiSelectDialogField(
                      items: dataModel[i].answerOptions!.map((option) {
                        return MultiSelectItem<AnswerOptions>(option, option.option!);
                      }).toList(),
                      initialValue: multiSelectValues,
                      title: const Text("Select"),
                      buttonIcon: const Icon(Icons.arrow_drop_down),
                      selectedColor: Colors.orange,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      buttonText: const Text("Select"),
                      onConfirm: (results) {
                        setState(() {
                          _selectedValues = results;
                          for (var item in _selectedValues) {
                            multiSelectValues.add((item as AnswerOptions).option);
                          }

                          dataModel[i].answerOutput = multiSelectValues.toString().replaceAll("[", "").replaceAll("]", "");
                          dataModel[i].answerOutputQuestionId = dataModel[i].questionId.toString();
                        });
                      }),
                )
              ]));
            }
            break;
        }
      }
    } else {
      dynamicWidgets.add(const Center(
        child: Text("No Data Found"),
      ));
    }

    return dynamicWidgets;
  }

  String select = "";

  List<AnswerOptions> convertListOfObjectsToModels(List<Object?> objects) {
    return objects.map((obj) {
      // Ensure obj is a Map<String, dynamic> or use a specific conversion logic
      if (obj is Map<String, dynamic>) {
        return AnswerOptions.fromJson(obj);
      } else {
        throw ArgumentError('Invalid object type');
      }
    }).toList();
  }
}
