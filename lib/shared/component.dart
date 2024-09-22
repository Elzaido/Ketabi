import 'package:book_swapping/shared/Cubit/home/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/bourding_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../modules/chat/chat_details.dart';
import 'constant.dart';

Widget formField({
  required TextEditingController control,
  required bool isScure,
  required String label,
  required Icon prefIcon,
  TextInputType inputType = TextInputType.visiblePassword,
  ValueChanged<String>? onSubmit,
  required FormFieldValidator<String> validator,
  IconButton? suffButton,
}) =>
    TextFormField(
      textDirection: TextDirection.rtl,
      validator: validator,
      controller: control,
      keyboardType: inputType,
      obscureText: isScure,
      obscuringCharacter: '*',
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          isDense: true,
          prefixIcon: prefIcon,
          suffixIcon: suffButton,
          hintText: label,
          hintTextDirection: TextDirection.rtl,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

Widget button({
  required void Function()? onPressed,
  required Widget? child,
  required Color color,
  double height = 60,
}) =>
    SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: onPressed,
        child: child,
      ),
    );

Widget loading() => Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
        child: const Padding(
          padding: EdgeInsets.all(18.0),
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 102, 187, 106),
          ),
        ),
      ),
    );

void defaultToast({
  required String massage,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: massage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: choseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

// states of the Toast
// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color choseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

void navigateAndFinish({required context, required Widget widget}) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
        // delete previous pages when i go to the next page:
        (Route<dynamic> route) => false);

Widget boardingItemBuilder(BoardingModel model, size) => Stack(
      children: [
        Positioned(
          child: SizedBox(
              height: size.height,
              child: Image(
                image: AssetImage('${model.image}'),
                fit: BoxFit.cover,
              )),
        ),
        const SizedBox(
          height: 25,
        ),
        Positioned(
          child: Container(
              height: size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    spreadRadius: 6,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
                  child: Text(
                    '${model.title}',
                    style: const TextStyle(
                      fontSize: 35,
                      fontFamily: 'Cairo',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );

Widget profileButton(
    {required void Function()? onPressed,
    required String text,
    required Icon icon}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TextButton(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  icon,
                ],
              )),
        ),
      ],
    ),
  );
}

Widget defaultHomeItem({
  required BuildContext context,
  required String title,
  required String image,
  required void Function()? onTap,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4), // Shadow color
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(
                  0,
                  2,
                ), // Shadow position [horizontal, vertical]
              ),
            ],
          ),
          height: 100,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 15),
              ),
              const SizedBox(
                width: 20,
              ),
              Image(
                image: AssetImage(image),
              ),
            ],
          ),
        ),
      ),
    );

UserModel? userModel;

Widget adItem(
  context,
  PostModel model,
  bool myAd,
) {
  return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the radius as needed
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Shadow color
            spreadRadius: 2,
            blurRadius: 4,
            offset:
                const Offset(0, 2), // Shadow position [horizontal, vertical]
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              if (model.uId != uId) {
                showItemDialog(
                    model, context, model.postImage.isNotEmpty, model.adType);
              } else {
                showMyItemDialog(
                    model, context, model.postImage.isNotEmpty, model.adType);
              }
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              if (!myAd)
                IconButton(
                  onPressed: () {
                    if (!HomeCubit.get(context)
                        .userModel!
                        .favList
                        .contains(model.postId)) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uId)
                          .update({
                        'favlist': FieldValue.arrayUnion([model.postId]),
                      });
                      defaultToast(
                          massage: 'تمت إضافة الإعلان إلى المفضلة',
                          state: ToastStates.SUCCESS);
                    } else {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uId)
                          .update({
                        'favlist': FieldValue.arrayRemove([model.postId]),
                      });
                      defaultToast(
                          massage: 'تمت إزالة الإعلان من المفضلة',
                          state: ToastStates.ERROR);
                    }
                    HomeCubit.get(context).getUserData();
                  },
                  icon: HomeCubit.get(context)
                          .userModel!
                          .favList
                          .contains(model.postId)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.red,
                        ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (model.adType == 'تبرع')
                        const Text(
                          'مجاني',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold),
                        ),
                      if (model.adType != 'تبرع')
                        Text(
                          'لل${model.adType}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold),
                        ),
                      if (model.adContentType == 'كتاب')
                        Text(
                          'كتاب ${model.bookName}',
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      if (model.adContentType != 'كتاب')
                        Text(
                          '${model.adContentType} ${model.contentName}',
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      if (model.adType == 'تبديل')
                        Text(
                          'للتبديل على ${model.swapedBookType} ${model.swapedBook}',
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      Text(
                        model.university,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Image.network(
                model.postImage,
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    "هناك مشكلة\nفي عرض الصورة",
                    textAlign: TextAlign.center,
                  ); // Display a custom error message.
                },
              )
            ]),
          ),
          if (myAd)
            Column(
              children: [
                separator(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: button(
                      onPressed: () {
                        HomeCubit.get(context).deletePost(model.postId);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'حذف',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            ),
                          )
                        ],
                      ),
                      color: Colors.red),
                ),
              ],
            )
        ]),
      ));
}

Widget dropDown({
  required String selected,
  required List<String> list,
  required context,
  required int dropDown,
}) =>
    Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton(
            padding: const EdgeInsets.all(5),
            dropdownColor: const Color.fromARGB(255, 247, 247, 247),
            icon: const Icon(Icons.arrow_drop_down),
            isExpanded: true,
            iconSize: 22,
            style: const TextStyle(color: Colors.black, fontSize: 15),
            value: selected,
            underline: const SizedBox(),
            items: list.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        valueItem,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ));
            }).toList(),
            onChanged: (newValue) {
              if (dropDown == 2) {
                HomeCubit.get(context).selectAdContentType(newValue!);
              } else if (dropDown == 3) {
                HomeCubit.get(context).selectAdCategory(newValue!);
              } else if (dropDown == 4) {
                HomeCubit.get(context).selectUniversity(newValue!);
              } else {
                HomeCubit.get(context).selectSwapContentType(newValue!);
              }
            }));

Widget dropDownTitle(String title) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    ),
  );
}

void showItemDialog(PostModel model, context, bool isImage, String bookType) {
  showDialog(
      context: context,
      builder: (context1) => AlertDialog(
            title: model.adType == 'تبرع'
                ? const Text(
                    'مجاني',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Cairo',
                    ),
                  )
                : Text(
                    'لل${model.adType}',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Cairo',
                    ),
                  ),
            content: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (model.adContentType == 'كتاب')
                  infoItems(title: 'إسم الكتاب', info: model.bookName),
                if (model.adContentType == 'كتاب')
                  infoItems(title: 'إسم المؤلف', info: model.bookAuthorName),
                if (model.adContentType == 'كتاب')
                  infoItems(title: 'إسم الناشر', info: model.bookPublisherName),
                if (model.adContentType != 'كتاب')
                  infoItems(
                      title: 'إسم ال${model.adContentType}',
                      info: model.contentName),
                if (bookType == 'تبديل')
                  infoItems(title: 'للتبديل على', info: model.swapedBook),
                infoItems(title: 'الجامعة', info: model.university),
                infoItems(title: 'القسم أو المجال', info: model.bookCategory),
                infoItems(
                    title: 'صاحب ال${model.adContentType}',
                    info: model.ownerName!),
                isImage
                    ? SizedBox(
                        width: 300,
                        height: 300,
                        child: Image(
                          image: NetworkImage(
                            model.postImage,
                          ),
                          fit: BoxFit.cover,
                        ))
                    : const SizedBox(
                        height: 0,
                      )
              ],
            )),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context1, true);
                  },
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                    ),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.pop(context1, true);
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uId)
                      .update({
                    'chatlist': FieldValue.arrayUnion([model.uId]),
                  });
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(model.uId)
                      .update({
                    'chatlist': FieldValue.arrayUnion([uId]),
                  });
                  // get the ad owner data and pass it the chat datails page.
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(model.uId)
                      .get()
                      .then((value) {
                    userModel = UserModel.formJson(value.data()!);
                    String name = userModel!.name!;
                    String image = userModel!.image;
                    String token = userModel!.pushToken;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatDetails(
                                  uId: model.uId,
                                  image: image,
                                  name: name,
                                  fToken: token,
                                )));
                  });
                },
                child: const Text(
                  'دردشة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ));
}

void showMyItemDialog(PostModel model, context, bool isImage, String bookType) {
  showDialog(
      context: context,
      builder: (context1) => AlertDialog(
            title: model.adType == 'تبرع'
                ? const Text(
                    'مجاني',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Cairo',
                    ),
                  )
                : Text(
                    'لل${model.adType}',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Cairo',
                    ),
                  ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (model.adContentType == 'كتاب')
                    infoItems(title: 'إسم الكتاب', info: model.bookName),
                  if (model.adContentType == 'كتاب')
                    infoItems(title: 'إسم المؤلف', info: model.bookAuthorName),
                  if (model.adContentType == 'كتاب')
                    infoItems(
                        title: 'إسم الناشر', info: model.bookPublisherName),
                  if (model.adContentType != 'كتاب')
                    infoItems(
                        title: 'إسم ال${model.adContentType}',
                        info: model.contentName),
                  if (bookType == 'تبديل')
                    infoItems(title: 'للتبديل على', info: model.swapedBook),
                  infoItems(title: 'الجامعة', info: model.university),
                  infoItems(title: 'القسم أو المجال', info: model.bookCategory),
                  infoItems(
                      title: 'صاحب ال${model.adContentType}',
                      info: model.ownerName!),
                  isImage
                      ? SizedBox(
                          width: 300,
                          height: 300,
                          child: Image(
                            image: NetworkImage(
                              model.postImage,
                            ),
                            fit: BoxFit.cover,
                          ))
                      : Container(),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: button(
                    onPressed: () {
                      HomeCubit.get(context).deletePost(model.postId);
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'حذف',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                          ),
                        )
                      ],
                    ),
                    color: Colors.red),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(fontFamily: 'Cairo'),
                    )),
              )
            ],
          ));
}

Widget infoItems({required String title, required String info}) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      info,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "Cairo",
                      ),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                    ))),
          ),
          const Text(
            '   :',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(title,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: "Cairo",
              )),
        ],
      ),
    );

Widget chatItem(context, UserModel model) => InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetails(
                      uId: model.uId,
                      image: model.image,
                      name: model.name!,
                      fToken: model.pushToken,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                  radius: 30.0, backgroundImage: NetworkImage(model.image)),
            ),
            Text(
              '${model.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );

Widget separator() => Padding(
      padding: const EdgeInsets.all(10.0),
      child: (Container(
        width: double.infinity,
        height: 1,
        color: const Color.fromARGB(255, 226, 226, 226),
      )),
    );

Widget gridItem({
  required context,
  required Widget nav,
  required String image,
  required String title,
}) {
  return InkWell(
      onTap: () {
        if (title == 'كتب مجانية') {
          HomeCubit.get(context).getPostsByType(type: 'تبرع');
        } else if (title == 'كتب للتبديل') {
          HomeCubit.get(context).getPostsByType(type: 'تبديل');
        } else if (title == 'جميع الإعلانات') {
          HomeCubit.get(context).getAllPosts();
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => nav));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(16.0), // Adjust the radius as needed
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8), // Shadow color
              spreadRadius: 3,
              blurRadius: 7,
              offset:
                  const Offset(-1, 2), // Shadow position [horizontal, vertical]
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            children: [
              Center(
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  width: double.infinity, // Match the width of the Container
                  height: double.infinity, // Match the height of the Container
                ),
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 6,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ),
      ));
}

postTypeItem({
  required context,
  required Widget nav,
  required String image,
  required String title,
}) {
  return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => nav));
      },
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(16.0), // Adjust the radius as needed
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8), // Shadow color
              spreadRadius: 3,
              blurRadius: 7,
              offset:
                  const Offset(-1, 2), // Shadow position [horizontal, vertical]
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            children: [
              Center(
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  width: double.infinity, // Match the width of the Container
                  height: double.infinity, // Match the height of the Container
                ),
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 6,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
        ),
      ));
}
