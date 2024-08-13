import 'package:book_swapping/modules/posts/ads.dart';
import 'package:book_swapping/shared/Cubit/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/Cubit/home/home_state.dart';
import '../../shared/component.dart';

class FilteringDialog extends StatelessWidget {
  const FilteringDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is SuccessGetPostDataState) {
          navigateAndFinish(
              context: context,
              widget: AllAds(
                  title: 'إعلانات للتبديل', type: 'تبديل', fromAddPost: true));
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: AlertDialog(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularProgressIndicator(
                    color: Color.fromARGB(255, 102, 187, 106),
                  ),
                  Spacer(),
                  Text(
                    '... جاري فلترة النتائج',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
