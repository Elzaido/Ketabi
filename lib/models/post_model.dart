// ignore_for_file: non_constant_identifier_names

class PostModel {
  late String name;
  late String userImage;
  late String postText;
  late String date;
  late String postImage;
  late String uId;

  PostModel({
    required this.name,
    required this.userImage,
    required this.postText,
    required this.date,
    required this.postImage,
    required this.uId,
  });

  PostModel.formJson(Map<String, dynamic> json) {
    name = json['name'];
    userImage = json['userImage'];
    postText = json['postText'];
    date = json['date'];
    postImage = json['postImage'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userImage': userImage,
      'postText': postText,
      'date': date,
      'postImage': postImage,
      'uId': uId,
    };
  }
}
