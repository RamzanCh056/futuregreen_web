import 'package:cloud_firestore/cloud_firestore.dart';

class ExamModel {
  String id;
  String name;
  int totalChapters;
  List allowedUsers;
  List flashCardAllowed;
  List factsAllowed;
  List mockExamAllowed;
  List trialEnd;
  Timestamp timestamp;

  ExamModel({
    required this.id,
    required this.name,
    required this.allowedUsers,
    required this.timestamp,
    required this.totalChapters,
    required this.factsAllowed,
    required this.mockExamAllowed,
    required this.trialEnd,
    required this.flashCardAllowed,
  });

  factory ExamModel.fromJson(dynamic json) => ExamModel(
      id: json["id"],
      name: json["name"],
      totalChapters: json["totalChapters"],
      allowedUsers: json["allowedUsers"],
      flashCardAllowed: json["flashCardAllowed"],
      timestamp: json["timestamp"],
      mockExamAllowed: json["mockExamAllowed"],
      factsAllowed: json["factsAllowed"],
      trialEnd: json["trialEnd"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        'totalChapters': totalChapters,
        "allowedUsers": allowedUsers,
        "timestamp": timestamp,
        "factsAllowed": factsAllowed,
        "mockExamAllowed": mockExamAllowed,
        'flashCardAllowed': flashCardAllowed,
        "trialEnd": trialEnd,
      };
}
