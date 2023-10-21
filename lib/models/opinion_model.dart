class OpinionModel {
  late String? name;
  late String opinion;
  late String opinionId;

  OpinionModel({
    required this.name,
    required this.opinion,
    required this.opinionId
  });

  OpinionModel.formJson(Map<String, dynamic> json) {
    name = json['name'];
    opinion = json['opinion'];
    opinionId = json['opinionId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'opinion': opinion,
      'opinionId': opinionId,
    };
  }
}
