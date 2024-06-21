// To parse this JSON data, do
//
//     final chapterModel = chapterModelFromJson(jsonString);

import 'dart:convert';

ChapterModel chapterModelFromJson(String str) =>
    ChapterModel.fromJson(json.decode(str));

String chapterModelToJson(ChapterModel data) => json.encode(data.toJson());

class ChapterModel {
  String id;
  String examId;
  String name;
  int no;
  int totalQuestions;
  List participants;
  List allowedUsers;
  DateTime timestamp;

  ChapterModel({
    required this.id,
    required this.examId,
    required this.name,
    required this.no,
    required this.participants,
    required this.timestamp,
    required this.totalQuestions,
    required this.allowedUsers,
  });

  factory ChapterModel.fromJson(dynamic json) => ChapterModel(
        id: json["id"],
        examId: json["examId"],
        name: json["name"],
        no: json["no"],
        allowedUsers: json["allowedUsers"],
        totalQuestions: json["totalQuestions"],
        participants: json["participants"],
        timestamp: json["timestamp"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "examId": examId,
        "name": name,
        "no": no,
        'totalQuestions': totalQuestions,
        'allowedUsers': allowedUsers,
        "participants": participants,
        "timestamp": timestamp,
      };
}

class ParticipantModel {
  String uid;
  int attempted;
  int correct;

  ParticipantModel({
    required this.uid,
    required this.attempted,
    required this.correct,
  });

  factory ParticipantModel.fromJson(dynamic json) => ParticipantModel(
        uid: json["uid"],
        attempted: json["attempted"],
        correct: json["correct"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "attempted": attempted,
        "correct": correct,
      };
}
