// ignore_for_file: non_constant_identifier_names

class ChatModel {
  late String senderId;
  late String receiverId;
  late String date;
  late String text;
  late String? image;

  ChatModel(
      {required this.senderId,
      required this.receiverId,
      required this.date,
      required this.text,
      required this.image});

  ChatModel.formJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receverId'];
    date = json['date'];
    text = json['text'];
    image = json['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receverId': receiverId,
      'date': date,
      'text': text,
      'image': image,
    };
  }
}
