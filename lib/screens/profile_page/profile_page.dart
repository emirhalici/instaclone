import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/profile_page/profile_posts.dart';
import 'package:instaclone/screens/profile_page/tagged_posts.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> getUserData() async {
    await context.watch<ProfilePageProvider>().getCurrentUserData();
  }

  Future<void> getUserPosts() async {
    context.read<ProfilePageProvider>().getUserPosts();
  }

  @override
  void initState() {
    super.initState();
    getUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<ProfilePageProvider>().userData;

    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    if (userData.isEmpty) {
      getUserData();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        toolbarHeight: ProjectConstants.toolbarHeight,
        title: Text(
          userData['username'],
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
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
              // TODO : IMPLEMENT PROFILE MENU
            },
            icon: SvgPicture.asset(
              'assets/icons/menu.svg',
              color: primaryColor,
            ),
          )
        ],
        centerTitle: false,
      ),
      body: userData.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : DefaultTabController(
              length: 2,
              child: NestedScrollView(
                controller: context.read<ProfilePageProvider>().pageScrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate([profileWidget(context, userData)]),
                    )
                  ];
                },
                body: Column(
                  children: [
                    TabBar(
                      indicatorColor: primaryColor,
                      tabs: [
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/icons/grid.svg',
                            color: primaryColor,
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/icons/mentions.svg',
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          ProfilePosts(),
                          TaggedPosts(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget profileWidget(BuildContext context, Map<String, dynamic> userData) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);

    List<dynamic> following = userData['following'];
    List<dynamic> followers = userData['followers'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              userData['profilePic'] == '' || userData['profilePic'] == null
                  ? const SizedBox(
                      width: 86.0,
                      height: 86.0,
                      child: CircleAvatar(foregroundImage: AssetImage('assets/images/default_profile_pic.png')),
                    )
                  : SizedBox(
                      width: 86.0,
                      height: 86.0,
                      child: CircleAvatar(foregroundImage: NetworkImage(userData['profilePic'])),
                    ),
              Column(
                children: [
                  Text(
                    context.watch<ProfilePageProvider>().posts.length.toString(),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  Text('Posts', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                children: [
                  Text(followers.length.toString(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  Text('Followers', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                children: [
                  Text(following.length.toString(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  Text('Following', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            userData['name'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            userData['description'],
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // TODO : IMPLEMENT EDIT PROFILE
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor.withOpacity(0.2)),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
