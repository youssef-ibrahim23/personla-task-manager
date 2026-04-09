import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:personal_task/bottom_navigations.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/auth/views/forgot_password_view.dart';
import 'package:personal_task/features/auth/views/register_view.dart';
import 'package:personal_task/features/auth/views/widgets/another_option.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/features/auth/data/login_data.dart';
import 'package:personal_task/features/auth/view-models/login_view_model.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/localization/locale_provider.dart';
import '../../../core/utils/theme/theme_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  bool _rememberMe = false;

  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRememberMe();
      _authenticateWithFingerPrint();
    });
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      _controllers['email']!.text = prefs.getString('savedEmail') ?? '';
    });
  }

  Future<void> _authenticateWithFingerPrint() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
    bool isBiometricEnabled = sharedPreferences.getBool('isBiometricEnabled') ?? false;
    print('is LoggedIn : $isLoggedIn , isBiometric Enabled : $isBiometricEnabled ');
    if(isLoggedIn && isBiometricEnabled){
      bool authenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to login',
        biometricOnly: true,
      );
      if(authenticated){
        Navigator.pushReplacement(
          context!,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen(loginViewModelProvider, (previous, next) {
      next.when(
        data: (user) async {
          if (user != null) {
            final prefs = await SharedPreferences.getInstance();

            if (_rememberMe) {
              await prefs.setBool('rememberMe', true);
              await prefs.setString('savedEmail', _controllers['email']!.text);
            } else {
              await prefs.clear();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BottomNavigation()),
            );
          }
        },

        error: (error, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Helpers.displayDialog(
              context: context,
              title: AppLocalizations.of(context)!.login_failed,
              message: error.toString(),
              dialogType: DialogType.error,
              openMailOption: false,
            );
          });
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 30,
                    ),
                    onSelected: (value) {
                      if (value is ThemeMode) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      } else {
                        ref
                            .read(localeProvider.notifier)
                            .setLocaleFromString(value.toString());
                      }
                    },
                    itemBuilder: (context) {
                      final locale = ref.watch(localeProvider);
                      final themeMode = ref.watch(themeProvider);

                      return [
                        PopupMenuItem(
                          value: locale.languageCode == 'ar' ? 'en' : 'ar',
                          child: Text(
                            locale.languageCode == 'ar'
                                ? AppLocalizations.of(context)!.english
                                : AppLocalizations.of(context)!.arabic,
                          ),
                        ),
                        PopupMenuItem(
                          value: themeMode == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark,
                          child: Text(
                            themeMode == ThemeMode.dark
                                ? AppLocalizations.of(context)!.light_mode
                                : AppLocalizations.of(context)!.dark_mode,
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              SizedBox(
                height: ref.watch(localeProvider).languageCode == 'ar'
                    ? screenHeight * 0.0
                    : screenHeight * 0.07,
              ),
              Text(
                AppLocalizations.of(context)!.app_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ref.watch(localeProvider).languageCode == 'ar'
                      ? 105
                      : 70,
                ),
              ).animate().shimmer(
                color: Theme.of(context).primaryColor,
                duration: 1.seconds,
              ),
              SizedBox(height: screenHeight * 0.01,),
              Container(
                width: screenWidth,
                height: screenHeight * 0.63,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 50,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      controller: _controllers['email'],
                      obscureText: false,
                      suffixIcon: Icons.mail,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.password,
                      controller: _controllers['password'],
                      obscureText: true,
                      isPassword: true,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ForgotPasswordView(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ?loginState.isLoading ? SizedBox(width: screenWidth * 0.2,) : null,
                        Button(
                          text: loginState.isLoading
                              ? AppLocalizations.of(context)!.logging
                              : AppLocalizations.of(context)!.login,
                          onPressed: loginState.isLoading
                              ? () {}
                              : () async {
                                  await ref
                                      .read(loginViewModelProvider.notifier)
                                      .signIn(
                                        LoginData(
                                          email: _controllers['email']!.text,
                                          password:
                                              _controllers['password']!.text,
                                        ),
                                        context,
                                      );
                                },
                          state: loginState.isLoading,
                          isLogin: true,
                        ),
                        ?loginState.isLoading ? SizedBox(width: screenWidth * 0.01,) : null,
                        Container(
                          width: screenWidth * 0.12,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5
                            ),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: IconButton(
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.fingerprint),
                            onPressed: () {
                              ref
                                  .read(loginViewModelProvider.notifier)
                                  .authenticateWithFingerPrint(context);
                            },
                          ),
                        ),
                      ],
                    ).animate().moveX(begin: 500, duration: 500.ms),
SizedBox(height: screenHeight * 0.01,),
                    AnotherOption(isLogin: false, page: const RegisterView()),
                    SizedBox(height: screenHeight * 0.01,),
                    InkWell(
                      onTap: () {
                        ref
                            .read(loginViewModelProvider.notifier)
                            .signInWithGoogle(context);
                      },
                      child: Image.asset('assets/google.png' , width: 30,),
                    ),
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
