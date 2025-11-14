import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/DB/models/user.dart';
import 'package:personal_task/features/auth/views/login_view.dart';
import 'package:personal_task/features/auth/views/widgets/another_option.dart';
import 'package:personal_task/features/auth/views/widgets/button.dart';
import 'package:personal_task/features/auth/views/widgets/image_widget.dart';
import 'package:personal_task/features/auth/views/widgets/register_header.dart';
import 'package:personal_task/features/auth/views/widgets/text_field.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../home/view/home_view.dart';
import '../view-models/auth_view_model.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterStateView();
}

class _RegisterStateView extends ConsumerState<RegisterView> {

  XFile? pickedImage;

  final Map<String ,TextEditingController> _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'password': TextEditingController(),
  };

  void _register() {

    final emailError = Validators.validateEmail(_controllers['email']!.text);

    final passwordError = Validators.validatePassword(_controllers['password']!.text);

    if (emailError != null) {
      Helpers.displayDialog(context, 'Invalid Email', emailError, DialogType.error);
      return;
    } else if (passwordError != null) {
      Helpers.displayDialog(context, 'Weak Password', passwordError, DialogType.error);
      return;
    }
    ref
        .read(authViewModelProvider.notifier)
        .register(
      User(
        name: _controllers['name']!.text,
        email: _controllers['email']!.text,
        phoneNumber: _controllers['phoneNumber']!.text,
        password: _controllers['password']!.text,
        image: pickedImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    final double screenHeight = MediaQuery.of(context).size.height;

    final registerState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (user) async {
          if (user == null) {
            Helpers.displayDialog(context, 'Field To Register' , 'Something went wrong please , try again', DialogType.error);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          }
        },
        error: (error, _) {
          Helpers.displayDialog(context, 'Field To Register' , 'Something went wrong please , try again', DialogType.error);
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.12),
              RegisterHeader(),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: screenWidth,
                height: screenHeight * 0.73,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ImageWidget(pickedImage: pickedImage),
                        SizedBox(width: screenWidth * 0.1),
                        IconButton(onPressed: (){
                          setState(() {
                            pickedImage = null;
                          });
                        }, icon: Icon(Icons.delete) , color: Colors.red,)
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    CustomTextField(
                      hintText: "Name",
                      controller: _controllers['name'],
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: "Email",
                      controller: _controllers['email'],
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: "Phone Number",
                      controller: _controllers['phoneNumber'],
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: "Password",
                      controller: _controllers['password'],
                      obscureText: true,
                      isHaveSuffixIcon: true,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Button(
                      text: registerState.isLoading
                          ? "Registering"
                          : "Register",
                      onPressed: _register,
                      state: registerState.isLoading,
                    ),
                    SizedBox(height: screenHeight * 0.01,),
                    AnotherOption(isLogin: true, page: LoginView()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}