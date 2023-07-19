// ignore_for_file: non_constant_identifier_names

class UserModel {
  late String? name;
  late String? email;
  late String? phone;
  late String image;
  late String uId;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.uId,
  });

  UserModel.formJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'uId': uId,
    };
  }
}
