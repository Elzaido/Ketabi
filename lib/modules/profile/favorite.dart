import 'package:book_swapping/shared/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../shared/Cubit/home/home_cubit.dart';
import '../../shared/component.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المفضلة',
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching user data'),
              );
            } else {
              final userData = snapshot.data?.data() as Map<String, dynamic>?;

              // Get the list of user IDs from the user data
              final List<String> favList =
                  List<String>.from(userData?['favlist'] ?? []);
              bool noSeparate = false;

              return favList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: ((context, index) {
                                    final post =
                                        HomeCubit.get(context).posts[index];
                                    // Check if the post's ID is in the favlist of the current user.
                                    final bool isPostInFavList =
                                        favList.contains(post.postId);
                                    // If the user's ID is in the chatlist, display the chat item.
                                    if (isPostInFavList) {
                                      return adItem(context, post,
                                          false); // Return the chat item widget.
                                    } else {
                                      noSeparate = true;
                                      return Container(
                                        height: 0,
                                      );
                                      // Return an empty container if the condition is false.
                                    }
                                  }),
                                  separatorBuilder: ((context, index) =>
                                      noSeparate
                                          ? Container(
                                              height: 0,
                                            )
                                          : separator()),
                                  itemCount:
                                      HomeCubit.get(context).posts.length),
                              const SizedBox(
                                height: 25,
                              )
                            ],
                          )),
                    )
                  : const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '!',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'لا يوجد لديك إعلانات مفضلة حتى الآن',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 40,
                          )
                        ],
                      ),
                    );
            }
          }),
    );
  }
}
