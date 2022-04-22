import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/profile_page/profile_posts.dart';
import 'package:instaclone/screens/profile_page/tagged_posts.dart';
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

  Color getColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<ProfilePageProvider>().userData;
    print(userData);

    if (userData.isEmpty) {
      getUserData();
    }
    return Scaffold(
      body: userData.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : DefaultTabController(
              length: 2,
              child: NestedScrollView(
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
                      indicatorColor: getColor(context),
                      tabs: [
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/icons/grid.svg',
                            color: getColor(context),
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/icons/mentions.svg',
                            color: getColor(context),
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
                    ))
                  ],
                ),
              ),
            ),
    );
  }

  Widget profileWidget(BuildContext context, Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userData['username'],
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () {
                  // TODO : IMPLEMENT PROFILE MENU
                },
                icon: SvgPicture.asset(
                  'assets/icons/menu.svg',
                  color: getColor(context),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              userData['profilePic'] == ''
                  ? Image.asset('assets/images/default_profile_pic.png', width: 86.w, height: 86.h)
                  : Image.network(userData['profilePic'], width: 86.w, height: 86.h),
              Row(
                children: [
                  Column(
                    children: [
                      Text('54', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), // DUMMY TEXT
                      Text('Posts', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(width: 50.w),
                  Column(
                    children: [
                      Text('242', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), // DUMMY TEXT
                      Text('Followers', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(width: 50.w),
                  Column(
                    children: [
                      Text('111', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), // DUMMY TEXT
                      Text('Following', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                    ],
                  )
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
                side: BorderSide(color: getColor(context).withOpacity(0.2)),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: getColor(context),
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
