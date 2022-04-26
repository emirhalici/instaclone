import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/screens/home_page/messenger_page.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //PageController pageController = PageController(initialPage: 0);

  Future<void> getFollowingPosts() async {
    context.read<HomePageProvider>().getPostsForMainPage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFollowingPosts();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    if (context.watch<HomePageProvider>().allPosts.isEmpty) {
      getFollowingPosts();
    }

    // TODO: CHANGE THIS WITH INFINITE SCROLL PAGINATION
    List<PostWidget> postWidgets = [];
    context.watch<HomePageProvider>().allPosts.forEach(
          (element) => postWidgets.add(
            PostWidget(post: element),
          ),
        );

    return SafeArea(
      child: PageView(
        controller: context.read<HomePageProvider>().pageController,
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
              elevation: 0,
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
                    context
                        .read<HomePageProvider>()
                        .pageController
                        .animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/messenger.svg',
                    color: primaryColor,
                  ),
                ),
              ],
              centerTitle: false,
            ),
            body: postWidgets.isEmpty
                ? Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: primaryColor,
                    ),
                  )
                : ListView(
                    children: postWidgets,
                  ),
          ),
          const MessengerPage(),
        ],
      ),
    );
  }
}
