// ignore_for_file: non_constant_identifier_names

class PostModel {
  late String? name;
  late String postId;
  late String userImage;
  late String postText;
  late String date;
  late String postImage;
  late String uId;
  late String type;

  PostModel({
    required this.name,
    required this.postId,
    required this.userImage,
    required this.postText,
    required this.date,
    required this.postImage,
    required this.uId,
    required this.type,
  });

  PostModel.formJson(Map<String, dynamic> json) {
    name = json['name'];
    postId = json['postId'];
    userImage = json['userImage'];
    postText = json['postText'];
    date = json['date'];
    postImage = json['postImage'];
    uId = json['uId'];
    type = json['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'postId': postId,
      'userImage': userImage,
      'postText': postText,
      'date': date,
      'postImage': postImage,
      'uId': uId,
      'type': type,
    };
  }
}
