class MockExamQuestionModel {
  String id;
  String examId;
  String chapterId;
  String question;
  List choices;
  String correct;
  List<AttemptedModel> attempted;
  String explanation;
  List participants;

  MockExamQuestionModel({
    required this.id,
    required this.examId,
    required this.chapterId,
    required this.question,
    required this.attempted,
    required this.explanation,
    required this.choices,
    required this.participants,
    required this.correct,
  });

  factory MockExamQuestionModel.fromJson(dynamic json) => MockExamQuestionModel(
      id: json["id"],
      examId: json["examId"],
      chapterId: json["chapterId"],
      question: json["question"],
      choices: json["choices"],
      attempted: json["attempted"]
          .map<AttemptedModel>((x) => AttemptedModel.fromMap(x))
          .toList(),
      explanation: json["explanation"],
      correct: json["correct"],
      participants: json["participants"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "examId": examId,
        "chapterId": chapterId,
        "question": question,
        'choices': choices,
        "attempted": attempted,
        "explanation": explanation,
        "correct": correct,
        "participants": participants,
      };
}

class AttemptedModel {
  String uid;
  String selected;

  AttemptedModel({
    required this.uid,
    required this.selected,
  });

  factory AttemptedModel.fromMap(dynamic doc) {
    return AttemptedModel(
      uid: doc['uid'],
      selected: doc['selected'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'selected': selected,
    };
  }
}
