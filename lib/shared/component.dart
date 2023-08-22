// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/bourding_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../modules/chat/chat_details.dart';
import 'constant.dart';

Widget formField(
        {required TextEditingController control,
        required bool isScure,
        required String label,
        required Icon prefIcon,
        ValueChanged<String>? onSubmit,
        required FormFieldValidator<String> validator,
        IconButton? suffButton}) =>
    TextFormField(
      textDirection: TextDirection.rtl,
      validator: validator,
      controller: control,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isScure,
      obscuringCharacter: '*',
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: prefIcon,
          suffixIcon: suffButton,
          hintText: label,
          hintTextDirection: TextDirection.rtl,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
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

Widget boardingItemBuilder(BoardingModel model) => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: AssetImage('${model.image}')),
        const SizedBox(
          height: 30,
        ),
        Text(
          '${model.title}',
          style: const TextStyle(
            fontSize: 40,
            fontFamily: 'Cairo',
            // fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
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

Widget defualtHomeItem({
  required BuildContext context,
  required String title,
  required String image,
  required void Function()? onTap,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 5), // changes position of shadow
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
  bool infavpage,
  bool isfav,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: InkWell(
      onTap: () {
        if (model.uId != uId) {
          showDialog(
              context: context,
              builder: (context1) => AlertDialog(
                    title: Text(
                      model.type,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            model.postText,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                            width: 300,
                            height: 300,
                            child: Image(
                              image: NetworkImage(
                                model.postImage,
                              ),
                              fit: BoxFit.cover,
                            ))
                      ],
                    ),
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
        } else {
          defaultToast(
              massage: 'هذا الإعلان خاص بك!', state: ToastStates.ERROR);
        }
      },
      child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 247, 247, 247),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                if (!infavpage)
                  IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uId)
                          .update({
                        'favlist': FieldValue.arrayUnion([model.postId]),
                      });
                    },
                    icon: isfav
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (model.postText != '')
                          Text(
                            model.postText,
                            maxLines: 2,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Cairo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Text(
                          '${model.type} -',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (model.postImage != '')
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      image: NetworkImage(
                        model.postImage,
                      ),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
              ]),
            ],
          )),
    ),
  );
}

Widget myAdItem(
  context,
  PostModel model,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Card(
        elevation: 5,
        color: const Color.fromARGB(255, 247, 247, 247),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (model.postText != '')
                        Text(
                          model.postText,
                          maxLines: 2,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Text(
                        model.type,
                        textAlign: TextAlign.end,
                        style:
                            const TextStyle(fontSize: 15, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ),
              ),
              if (model.postImage != '')
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image(
                    image: NetworkImage(
                      model.postImage,
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
            ]),
            separator(),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {},
                  child: const Column(
                    children: [
                      Icon(Icons.analytics, color: Colors.green),
                      Text('إحصائيات'),
                    ],
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.orange,
                      ),
                      Text('تعديل')
                    ],
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text('حذف')
                    ],
                  ),
                )),
              ],
            ),
          ],
        )),
  );
}

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
      padding: const EdgeInsets.all(8.0),
      child: (Container(
        height: 1,
        color: const Color.fromARGB(255, 226, 226, 226),
      )),
    );
