// ignore_for_file: non_constant_identifier_names

class PostModel {
  late String? ownerName;
  late String postId;
  late String bookName;
  late String bookPrice;
  late String swapedBook;
  late String userImage;
  late String date;
  late String postImage;
  late String uId;
  late String type;

  PostModel({
    required this.ownerName,
    required this.bookPrice,
    required this.bookName,
    required this.swapedBook,
    required this.postId,
    required this.userImage,
    required this.date,
    required this.postImage,
    required this.uId,
    required this.type,
  });

  PostModel.formJson(Map<String, dynamic> json) {
    ownerName = json['ownerName'];
    bookName = json['bookName'];
    swapedBook = json['swapedBook'];
    bookPrice = json["bookPrice"];
    postId = json['postId'];
    userImage = json['userImage'];
    date = json['date'];
    postImage = json['postImage'];
    uId = json['uId'];
    type = json['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName,
      'bookName': bookName,
      'swapedBook': swapedBook,
      'bookPrice': bookPrice,
      'postId': postId,
      'userImage': userImage,
      'date': date,
      'postImage': postImage,
      'uId': uId,
      'type': type,
    };
  }
}
