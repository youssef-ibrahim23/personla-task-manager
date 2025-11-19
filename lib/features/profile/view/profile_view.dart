import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/features/auth/views/widgets/image_widget.dart';
import 'package:personal_task/features/auth/views/widgets/text_field.dart';

import '../../../core/utils/DB/models/user.dart';
import '../view-model/profile_view_model.dart';
import 'package:personal_task/features/auth/view-models/register_view_model.dart';

class ProfileView extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'name': TextEditingController(),
    'phoneNumber': TextEditingController(),
  };

  bool _isListenerSet = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isListenerSet) {
      _isListenerSet = true;

      ref.listen<AsyncValue<User?>>(
        profileViewModelProvider,
            (prev, next) {
          next.when(
            data: (user) {
              if (user != null) {
                _controllers['name']!.text = user.name;
                _controllers['email']!.text = user.email;
                _controllers['phoneNumber']!.text = user.phoneNumber;

                ref.read(pickedImageProvider.notifier).state = user.image;
              }
            },
            loading: () {},
            error: (e, st) {},
          );
        },
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.primary,
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.light,
            fontSize: 45,
            fontFamily: AppStrings.primaryFont,
          ),
        ),
      ),
      body: Column(
        children: [
          Spacer(),
          Container(
            width: screenWidth,
            height: screenHeight * 0.65,
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                ImageWidget(),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Name',
                  controller: _controllers['name'],
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Email',
                  controller: _controllers['email'],
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Phone Number',
                  controller: _controllers['phoneNumber'],
                ),
                SizedBox(height: screenHeight * 0.05),
                // Container(
                //   width: screenWidth * 0.75,
                //   height: screenHeight * 0.07,
                //   decoration: BoxDecoration(
                //     color: AppColors.primary,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: MaterialButton(
                //     onPressed: () {},
                //     child: Text(
                //       "Change Password",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 20,
                //         fontFamily: AppStrings.primaryFont,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
