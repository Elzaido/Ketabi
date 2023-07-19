// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:flutter/material.dart';

class NewFeeds extends StatelessWidget {
  NewFeeds({Key? key}) : super(key: key);

  TextEditingController Search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          //   child: formField(
          //       control: Search,
          //       isScure: false,
          //       label: 'إبحث من هنا',
          //       prefIcon: Icon(Icons.search),
          //       validator: (String? value) {
          //         if (value!.isEmpty) {
          //           return 'Name must not be empty';
          //         } else {
          //           return null;
          //         }
          //       }),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CarouselSlider(
          //       items: HomeCubit.get(context).images,
          //       options: CarouselOptions(
          //         height: 150.0,
          //         initialPage: 0,
          //         viewportFraction: 1.0,
          //         enableInfiniteScroll: true,
          //         reverse: false,
          //         autoPlay: true,
          //         autoPlayInterval: Duration(seconds: 3),
          //         autoPlayAnimationDuration: Duration(seconds: 1),
          //         autoPlayCurve: Curves.fastOutSlowIn,
          //         scrollDirection: Axis.horizontal,
          //       )),
          // ),
          // Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: GridView.count(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       crossAxisCount: 3,
          //       mainAxisSpacing: 2,
          //       crossAxisSpacing: 2,
          //       childAspectRatio: 1 / 1.75,
          //       // list.generation(Length, itemBuilder// anonemus function that return the item).
          //       children: TypesList.map((model) {
          //         return InkWell(
          //           child: Item(context, model),
          //           onTap: () {
          //             HomeCubit.get(context).getPosts();
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(builder: (context) => model.navigate),
          //             );
          //           },
          //         );
          //       }).toList(),
          //     )),
        ],
      ),
    );
  }
}

// Widget Item(context, TypesModel model) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Padding(
//         padding: EdgeInsets.all(8.0),
//         child: CircleAvatar(
//           radius: 50,
//           backgroundImage: NetworkImage(model.image),
//           backgroundColor: Colors.white,
//         ),
//       ),
//       SizedBox(
//         height: 5,
//       ),
//       Text(
//         model.name,
//         style: TextStyle(
//           fontFamily: 'Cairo',
//           fontSize: 15,
//         ),
//       )
//     ],
//   );
// }
