import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/shared/image/image_providers.dart';
import 'package:personal_task/core/shared/image/image_widget.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/DB/models/user.dart';
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

  bool isGoogle = false;

  _loadIsGoogle()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isGoogle =  sharedPreferences.getBool('isGoogle') ?? false;
  }

  @override
  void initState() {
    super.initState();

    _loadIsGoogle();

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
            title: AppLocalizations.of(context)!.error,
            message: e.toString(),
            dialogType: DialogType.error,
            openMailOption: false,
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
            color: AppColors.light,
            fontSize: 45,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              width: screenWidth,
              height: screenHeight * 0.73,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
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
                    isGoogle: isGoogle,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomTextField(
                    hintText: AppLocalizations.of(context)!.name,
                    controller: _controllers['name'],
                    profileState: profileState.isLoading,
                    suffixIcon: Icons.short_text,
                    ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomTextField(
                    hintText: AppLocalizations.of(context)!.email,
                    controller: _controllers['email'],
                    profileState: profileState.isLoading,
                    suffixIcon: Icons.mail,
                     ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomTextField(
                    hintText: AppLocalizations.of(context)!.phone_number,
                    controller: _controllers['phoneNumber'],
                    profileState: profileState.isLoading,
                    suffixIcon: Icons.phone,
                     ),
                  SizedBox(height: screenHeight * 0.04),
                  Button(
                    text: AppLocalizations.of(context)!.change_password,
                    onPressed: () async {
                      final result = await ref
                          .read(profileViewModelProvider.notifier)
                          .sendRestPasswordEmail(_controllers['email']!.text);
                      result == true
                          ? Helpers.displayDialog(
                              context: context,
                              title: AppLocalizations.of(context)!.reset_password_email_sent,
                              message:
                                  AppLocalizations.of(context)!.reset_password_email_message,
                              dialogType: DialogType.success,
                              openMailOption: true,
                            )
                          : null;
                    },
                    state: profileState.isLoading,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Button(
                    text: AppLocalizations.of(context)!.save_changes,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}








