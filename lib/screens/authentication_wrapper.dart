import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/providers/posts_provider.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/login_page/login_page.dart';
import 'package:instaclone/screens/main_page.dart';
import 'package:provider/provider.dart';

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
      context.read<HomePageProvider>().setUser(firebaseUser);
      return const MainPage();
    } else {
      return const LoginPage();
    }
  }
}
