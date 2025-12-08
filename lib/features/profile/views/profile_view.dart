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
import 'package:personal_task/core/shared/text-field/text_field.dart';

import '../../../core/utils/DB/models/user.dart';
import '../../../core/utils/localization/locale_provider.dart';
import '../view-models/profile_view_model.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

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

  bool _didFetchProfile = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final prev = ref.read(profileViewModelProvider);
      final existing = prev.asData?.value;

      if (existing != null) {
        userData = existing;
        _controllers['name']!.text = existing.name;
        _controllers['email']!.text = existing.email;
        _controllers['phoneNumber']!.text = existing.phoneNumber;
        ref.read(profileImageProvider.notifier).state = existing.image;
      } else if (!_didFetchProfile) {
        _didFetchProfile = true;
        ref.read(profileViewModelProvider.notifier).getProfileData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final screenHeight = MediaQuery.of(context).size.height;

    final profileState = ref.watch(profileViewModelProvider);

    ref.listen(profileViewModelProvider, (prev, next) {
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
        error: (e, _) {
          Helpers.displayDialog(
            context: context,
            title: 'Error',
            message: e.toString(),
            dialogType: DialogType.error,
            openMailOption: false,
          );
        },
        loading: () {},
      );
    });

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
                ImageWidget(
                  pickedImageProvider: profilePickedImageProvider,
                  cloudImage: ref.watch(profileImageProvider),
                  state: ref.watch(profileViewModelProvider).isLoading,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Name',
                  controller: _controllers['name'],
                  profileState: profileState.isLoading,
                  fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Email',
                  controller: _controllers['email'],
                  profileState: profileState.isLoading,
                  fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  hintText: 'Phone Number',
                  controller: _controllers['phoneNumber'],
                  profileState: profileState.isLoading,
                  fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
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
                  fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                ),
                SizedBox(height: screenHeight * 0.03),
                Button(
                  text: 'Save Changes',
                  onPressed: () async {
                    await ref
                        .read(profileViewModelProvider.notifier)
                        .updateProfile(
                      user: User(
                        uid: userData!.uid,
                        name: _controllers['name']!.text,
                        email: _controllers['email']!.text,
                        phoneNumber: _controllers['phoneNumber']!.text,
                        password: userData!.password,
                      ),
                      ref: ref,
                    );
                  },
                  state: profileState.isLoading,
                  fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}








