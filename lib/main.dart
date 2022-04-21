import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/screens/login_page/signup_page.dart';
import 'package:instaclone/screens/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // TODO: PROVIDER PACKAGE

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Insta',
        // TODO: THEME
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.grey,
          ),
          brightness: Brightness.light,
          primaryColor: const Color.fromARGB(0, 0, 208, 255),
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: const Color.fromARGB(0, 0, 208, 255),
                secondary: const Color.fromARGB(0, 0, 208, 255),
                brightness: Brightness.light,
              ),
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'SF-UI-Display',
        ),
        darkTheme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.grey,
          ),
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(0, 0, 208, 255),
          colorScheme: ThemeData().colorScheme.copyWith(
                // primary: const Color.fromARGB(255, 19, 89, 146),
                // secondary: const Color.fromARGB(255, 19, 89, 146),
                primary: const Color.fromARGB(0, 0, 208, 255),
                secondary: const Color.fromARGB(0, 0, 208, 255),
                brightness: Brightness.dark,
              ),
          scaffoldBackgroundColor: const Color(0x000aa111),
          fontFamily: 'SF-UI-Display',
        ),
        themeMode: ThemeMode.system,
        home: const MainPage(),
      ),
    );
  }
}
