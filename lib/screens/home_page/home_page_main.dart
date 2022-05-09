import 'package:flutter/material.dart';
import 'package:instaclone/screens/home_page/home_page.dart';
import 'package:instaclone/screens/home_page/messenger_page.dart';
import 'package:provider/provider.dart';

import '../../providers/home_page_provider.dart';

class HomePageMain extends StatefulWidget {
  const HomePageMain({super.key});

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        controller: context.read<HomePageProvider>().pageController,
        children: const [
          HomePage(),
          MessengerPage(),
        ],
      ),
    );
  }
}
