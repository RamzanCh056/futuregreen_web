class MockChapterModel {
  String id;
  String examId;
  String name;
  int no;
  int totalQuestions;
  List<MockParticipantModel> participants;
  List allowedUsers;
  DateTime timestamp;

  MockChapterModel({
    required this.id,
    required this.examId,
    required this.name,
    required this.no,
    required this.participants,
    required this.timestamp,
    required this.totalQuestions,
    required this.allowedUsers,
  });

  factory MockChapterModel.fromJson(dynamic json) => MockChapterModel(
        id: json["id"],
        examId: json["examId"],
        name: json["name"],
        no: json["no"],
        allowedUsers: json["allowedUsers"],
        totalQuestions: json["totalQuestions"],
        participants: json["participants"]
            .map<MockParticipantModel>((x) => MockParticipantModel.fromJson(x))
            .toList(),
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

class MockParticipantModel {
  String uid;
  double score;
  double time;
  String totalTime;

  MockParticipantModel({
    required this.uid,
    required this.score,
    required this.time,
    required this.totalTime,
  });

  factory MockParticipantModel.fromJson(dynamic json) => MockParticipantModel(
      uid: json["uid"],
      score: json["score"].toDouble(),
      time: json["time"].toDouble(),
      totalTime: json["totalTime"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "score": score,
        "time": time,
        "totalTime": totalTime,
      };
}
