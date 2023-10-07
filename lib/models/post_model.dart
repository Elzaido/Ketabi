// ignore_for_file: non_constant_identifier_names

class PostModel {
  late String? ownerName;
  late String postId;
  late String bookName;
  late String swapedBook;
  late String userImage;
  late String date;
  late String postImage;
  late String uId;
  late String adType;
  late String adContentType;
  late String bookCategory;

  PostModel({
    required this.ownerName,
    required this.bookName,
    required this.swapedBook,
    required this.postId,
    required this.userImage,
    required this.date,
    required this.postImage,
    required this.uId,
    required this.adType,
    required this.adContentType,
    required this.bookCategory,
  });

  PostModel.formJson(Map<String, dynamic> json) {
    ownerName = json['ownerName'];
    bookName = json['bookName'];
    swapedBook = json['swapedBook'];
    postId = json['postId'];
    userImage = json['userImage'];
    date = json['date'];
    postImage = json['postImage'];
    uId = json['uId'];
    adType = json['adType'];
    adContentType = json['adContentType'];
    bookCategory = json['bookCategory'];
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName,
      'bookName': bookName,
      'swapedBook': swapedBook,
      'postId': postId,
      'userImage': userImage,
      'date': date,
      'postImage': postImage,
      'uId': uId,
      'adType': adType,
      'adContentType': adContentType,
      'bookCategory': bookCategory,
    };
  }
}
