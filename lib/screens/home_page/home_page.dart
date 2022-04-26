import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/utils/project_constants.dart';

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

    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return SafeArea(
      child: PageView(
        controller: pageController,
        children: [
          Scaffold(
            appBar: AppBar(
              shape: Border(
                bottom: BorderSide(
                  color: primaryColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              backgroundColor: primaryColorReversed,
              foregroundColor: primaryColor,
              toolbarHeight: ProjectConstants.toolbarHeight,
              title: SvgPicture.asset(
                "assets/icons/logo.svg",
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // TODO : IMPLEMENT ADD POST SCREEN
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/add.svg',
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO : IMPLEMENT RECENTLY MENU
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/heart.svg',
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/messenger.svg',
                    color: primaryColor,
                  ),
                ),
              ],
              centerTitle: false,
            ),
            body: Column(
              children: [
                // TODO : IMPLEMENT STORIES
                
              ],
            ),
          ),
          const MessengerPage(),
        ],
      ),
    );
  }
}
