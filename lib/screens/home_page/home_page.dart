import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:instaclone/widgets/add_sheet.dart';
import 'package:instaclone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  Future<void> getFollowingPosts() async {
    context.read<HomePageProvider>().getUserStream();
    context.read<HomePageProvider>().getPostsStreamForMainPage();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, getFollowingPosts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    var stream = context.watch<HomePageProvider>().postsStream;

    if (stream == null) {
      Future.delayed(Duration.zero, getFollowingPosts);
    }

    super.build(context);
    return Scaffold(
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
              ProjectUtils.showBottomSheet(context, (context) => const AddSheet());
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
      body: (stream == null)
          ? (context.watch<HomePageProvider>().userModel != null && context.watch<HomePageProvider>().userModel!.following.isEmpty)
              ? Container()
              : Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: primaryColor,
                  ),
                )
          : (context.watch<HomePageProvider>().userModel!.following.isEmpty)
              ? Container()
              : StreamBuilder<List<List<PostModel>>>(
                  stream: stream,
                  builder: (BuildContext context, AsyncSnapshot<List<List<PostModel>>> list) {
                    if (list.hasError) {
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                    }

                    if (list.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: primaryColor,
                        ),
                      );
                    }

                    var data = list.data![0];

                    List<Widget> postWidgets = [];
                    for (var post in data) {
                      postWidgets.add(PostWidget(post: post));
                    }

                    return ListView(
                      controller: context.read<HomePageProvider>().mainPostsController,
                      children: postWidgets,
                    );
                  },
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
