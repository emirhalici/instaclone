import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          brightness: Brightness.light,
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: const Color(0x000aa111),
                brightness: Brightness.light,
              ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'SF-UI-Display',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.grey,
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
