import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/providers/posts_provider.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/providers/search_page_provider.dart';
import 'package:instaclone/screens/authentication_wrapper.dart';
import 'package:instaclone/utils/authentication_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    RestartWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomePageProvider()),
          ChangeNotifierProvider(create: (_) => ProfilePageProvider()),
          ChangeNotifierProvider(create: (_) => PostsProvider()),
          ChangeNotifierProvider(create: (_) => SearchPageProvider()),
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
    ),
  );
}

class RestartWidget extends StatefulWidget {
  final Widget child;
  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    if (context.findAncestorStateOfType<_RestartWidgetState>() != null) {
      context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
    }
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Insta',
        useInheritedMediaQuery: true,
        // TODO: THEME
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.grey,
          ),
          brightness: Brightness.light,
          primaryColor: const Color.fromARGB(0, 0, 208, 255),
          splashColor: Colors.grey,
          highlightColor: Colors.grey,
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
          highlightColor: Colors.grey,
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(0, 0, 208, 255),
          splashColor: Colors.grey,
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
