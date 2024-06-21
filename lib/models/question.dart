// To parse this JSON data, do
//
//     final chapterModel = chapterModelFromJson(jsonString);

import 'dart:convert';

QuestionModel chapterModelFromJson(String str) =>
    QuestionModel.fromJson(json.decode(str));

String chapterModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
  String id;
  String examId;
  String chapterId;
  int chapterNo;
  String question;
  List choices;
  String correct;
  List<AttemptedModel> attempted;
  String explanation;

  QuestionModel({
    required this.id,
    required this.examId,
    required this.chapterId,
    required this.chapterNo,
    required this.question,
    required this.attempted,
    required this.explanation,
    required this.choices,
    required this.correct,
  });

  factory QuestionModel.fromJson(dynamic json) => QuestionModel(
        id: json["id"],
        examId: json["examId"],
        chapterId: json["chapterId"],
        chapterNo: json["chapterNo"],
        question: json["question"],
        choices: json["choices"],
        attempted: json["attempted"]
            .map<AttemptedModel>((x) => AttemptedModel.fromMap(x))
            .toList(),
        explanation: json["explanation"],
        correct: json["correct"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "examId": examId,
        "chapterId": chapterId,
        "chapterNo": chapterNo,
        "question": question,
        'choices': choices,
        "attempted": attempted,
        "explanation": explanation,
        "correct": correct,
      };
}

class AttemptedModel {
  String uid;
  int selectedIndex;

  AttemptedModel({
    required this.uid,
    required this.selectedIndex,
  });

  factory AttemptedModel.fromMap(dynamic doc) {
    return AttemptedModel(
      uid: doc['uid'],
      selectedIndex: doc['selectedIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'selectedIndex': selectedIndex,
    };
  }
}
