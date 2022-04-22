import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/login_page/login_page.dart';
import 'package:instaclone/screens/main_page.dart';
import 'package:instaclone/utils/authentication_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => ProfilePageProvider()),
        Provider<AuthenticationService>(
          create: (context) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      context.read<ProfilePageProvider>().setUser(firebaseUser);
      return const MainPage();
    } else {
      return const LoginPage();
    }
  }
}
