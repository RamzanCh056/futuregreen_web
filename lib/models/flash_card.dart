// To parse this JSON data, do
//
//     final chapterModel = chapterModelFromJson(jsonString);

import 'dart:convert';

FlashCardModel chapterModelFromJson(String str) =>
    FlashCardModel.fromJson(json.decode(str));

String chapterModelToJson(FlashCardModel data) => json.encode(data.toJson());

class FlashCardModel {
  String id;
  String examId;
  String chapterId;
  String question;
  String answer;
  List favourites;
  List<AttemptedModel> attempted;
  List participants;

  FlashCardModel({
    required this.id,
    required this.examId,
    required this.chapterId,
    required this.question,
    required this.attempted,
    required this.participants,
    required this.answer,
    required this.favourites,
  });

  factory FlashCardModel.fromJson(dynamic json) => FlashCardModel(
        id: json["id"],
        examId: json["examId"],
        chapterId: json["chapterId"],
        question: json["question"],
        answer: json["answer"],
        attempted: json["attempted"]
            .map<AttemptedModel>((x) => AttemptedModel.fromMap(x))
            .toList(),
        participants: json["participants"],
        favourites: json["favourites"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "examId": examId,
        "chapterId": chapterId,
        "question": question,
        'answer': answer,
        "attempted": attempted,
        "participants": participants,
        "favourites": favourites,
      };
}

class AttemptedModel {
  String uid;
  String answer;

  AttemptedModel({
    required this.uid,
    required this.answer,
  });

  factory AttemptedModel.fromMap(dynamic doc) {
    return AttemptedModel(
      uid: doc['uid'],
      answer: doc['answer'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'answer': answer,
    };
  }
}
