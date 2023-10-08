class PostModel {
  late String? ownerName;
  late String university;
  late String bookName;
  late String bookAuthorName;
  late String bookPublisherName;
  late String postId;
  late String contentName;
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
    required this.university,
    required this.contentName,
    required this.bookName,
    required this.bookAuthorName,
    required this.bookPublisherName,
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
    university = json['university'];
    contentName = json['contentName'];
    bookName = json['bookName'];
    bookAuthorName = json['bookAuthorName'];
    bookPublisherName = json['bookPublisherName'];
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
      'university': university,
      'contentName': contentName,
      'bookName': bookName,
      'bookAuthorName': bookAuthorName,
      'bookPublisherName': bookPublisherName,
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
