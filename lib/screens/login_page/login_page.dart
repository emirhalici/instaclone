import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/login_page/signup_page.dart';
import 'package:instaclone/screens/main_page.dart';
import 'package:instaclone/utils/authentication_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
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
              SizedBox(height: 9.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO : IMPLEMENT FORGOT PASSWORD
                  },
                  child: const Text(
                    'Forgot password?',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Color(0xFF3797EF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
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
                          String response = await context.read<AuthenticationService>().signIn(
                                email: usernameController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                          if (mounted && response == 'Signed in.') {
                            final user = context.read<AuthenticationService>().auth.currentUser;
                            context.read<ProfilePageProvider>().setUser(user);
                            directToMainPage();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response),
                                duration: const Duration(milliseconds: 500),
                                backgroundColor: const Color(0xFF3797EF),
                              ),
                            );
                            setState(() {
                              waitingForRequest = false;
                            });
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
                  child: const Text('Log In'),
                ),
              ),
              if (waitingForRequest)
                const Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator.adaptive())
              else
                SizedBox(height: 32.h),
              SvgPicture.asset(
                "assets/icons/seperator_or.svg",
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.grey),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign up.',
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