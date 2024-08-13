// ignore_for_file: non_constant_identifier_names

class UserModel {
  late String? name;
  late String? email;
  late String? phone;
  late String image;
  late String uId;
  late List<String> chatList;
  late List<String> favList;
  late String pushToken;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.uId,
    this.chatList = const [],
    this.favList = const [],
    required this.pushToken,
  });

  UserModel.formJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'] ?? '';
    image = json['image'];
    uId = json['uId'];
    chatList = List<String>.from(json['chatlist'] ?? []);
    favList = List<String>.from(json['favlist'] ?? []);
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'uId': uId,
      'chatlist': chatList,
      'favlist': favList,
      'push_token': pushToken,
    };
  }
}
