import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/screens/login_page/login_page.dart';
import 'package:instaclone/screens/main_page.dart';
import 'package:instaclone/utils/authentication_service.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void directToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                width: 182.w,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              SizedBox(height: 39.h),
              SizedBox(
                height: 44.h,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 44.h,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 44.h,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton(
                  onPressed: () async {
                    String response = await context.read<AuthenticationService>().signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                    print(response);
                    if (response == 'Signed up.' && mounted) {
                      if (mounted) {
                        String logInResponse = await context.read<AuthenticationService>().signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                        print(logInResponse);
                        // TODO : create user with the same username and email
                        directToMainPage();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response),
                          duration: const Duration(milliseconds: 500),
                          backgroundColor: const Color(0xFF3797EF),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3797EF)),
                    elevation: MaterialStateProperty.all(0.0),
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.grey),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Log in.',
                        style: TextStyle(color: Color(0xFF3797EF)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
