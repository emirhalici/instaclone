import 'package:flutter/material.dart';
import 'package:instaclone/screens/login_page/login_page.dart';
import 'package:instaclone/utils/authentication_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    // animate to page
    // pageController.animateToPage(1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);

    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          children: const [
            Scaffold(
              body: Text('Home Page!'),
            ),
            Scaffold(
              body: Text("Messages"),
            )
          ],
        ),
      ),
    );
  }
}
