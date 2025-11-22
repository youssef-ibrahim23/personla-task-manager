import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/shared/image/image_providers.dart';
import 'package:personal_task/core/shared/image/image_widget.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/features/auth/views/widgets/text_field.dart';

import '../../../core/utils/DB/models/user.dart';
import '../view-models/profile_view_model.dart';

class ProfileView extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  User? userData;

  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'name': TextEditingController(),
    'phoneNumber': TextEditingController(),
  };

  Future<void> updateProfile() async {
    final image = ref.read(pickedImageProvider.notifier).state == null
        ? ref.read(profileImageProvider.notifier).state
        : await Helpers.imageToBase64(
            File(ref.read(pickedImageProvider.notifier).state!.path),
          );
    await ref
        .read(profileViewModelProvider.notifier)
        .updateProfile(
          user: User(
            uid: userData!.uid,
            name: _controllers['name']!.text,
            email: _controllers['email']!.text,
            phoneNumber: _controllers['phoneNumber']!.text,
            password: userData!.password,
            image: image,
          ),
        );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).getProfileData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue<User?>>(profileViewModelProvider, (prev, next) {
      next.when(
        data: (user) {
          if (user != null) {
            userData = user;
            print('user data : ${user.toMap()}');
            _controllers['name']!.text = user.name;
            _controllers['email']!.text = user.email;
            _controllers['phoneNumber']!.text = user.phoneNumber;
            ref.read(profileImageProvider.notifier).state = user.image;
          }
        },
        loading: () {},
        error: (e, st) {
          Helpers.displayDialog(
            context: context,
            title: 'Error',
            message: e.toString(),
            dialogType: DialogType.error,
            openMailOption: false,
          );
        },
      );
    });

    final screenWidth = MediaQuery.of(context).size.width;

    final screenHeight = MediaQuery.of(context).size.height;

    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(profileImageProvider.notifier).state = null;
            ref.read(pickedImageProvider.notifier).state = null;
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
        ),

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
            height: screenHeight * 0.73,
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
                  profileState: profileState.isLoading,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Email',
                  controller: _controllers['email'],
                  profileState: profileState.isLoading,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Phone Number',
                  controller: _controllers['phoneNumber'],
                  profileState: profileState.isLoading,
                ),
                SizedBox(height: screenHeight * 0.04),
                Button(
                  text: 'Change Password',
                  onPressed: () async {
                    final result = await ref
                        .read(profileViewModelProvider.notifier)
                        .sendRestPasswordEmail(_controllers['email']!.text);
                    result == true
                        ? Helpers.displayDialog(
                            context: context,
                            title: 'Reset password email sent',
                            message:
                                'We sent to your email password reset link, please check your mail',
                            dialogType: DialogType.success,
                            openMailOption: true,
                          )
                        : null;
                  },
                  state: profileState.isLoading,
                ),
                SizedBox(height: screenHeight * 0.03),
                Button(
                  text: 'Save Changes',
                  onPressed: () async => await updateProfile(),
                  state: profileState.isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
