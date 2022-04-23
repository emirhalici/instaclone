import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
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

  bool waitingForRequest = false;

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
                  enableSuggestions: false,
                  obscureText: true,
                  autocorrect: false,
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
                  onPressed: waitingForRequest
                      ? null
                      : () async {
                          setState(() {
                            waitingForRequest = true;
                          });
                          String response = await context.read<AuthenticationService>().signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                          if (response == 'Signed up.' && mounted) {
                            if (mounted) {
                              await context.read<AuthenticationService>().signIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                              if (mounted) {
                                final user = context.read<AuthenticationService>().auth.currentUser;
                                context.read<ProfilePageProvider>().setUser(user);
                                setState(() {
                                  waitingForRequest = false;
                                });
                                // TODO : create user with the same username and email

                                Map<String, dynamic> json = <String, dynamic>{
                                  'following': [],
                                  'followers': [],
                                  'userUUID': user!.uid,
                                  'email': emailController.text.trim(),
                                  'username': usernameController.text.trim(),
                                  'description': '',
                                  'name': usernameController.text.trim(), // might change later?
                                  'profilePic': '',
                                };

                                context.read<ProfilePageProvider>().setUserUpAfterSignUp(json);
                                directToMainPage();
                              }
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
                          setState(() {
                            waitingForRequest = false;
                          });
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3797EF)),
                    elevation: MaterialStateProperty.all(0.0),
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
              if (waitingForRequest)
                const Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator.adaptive())
              else
                SizedBox(height: 32.h),
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
