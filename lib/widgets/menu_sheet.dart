import 'package:flutter/material.dart';
import 'package:instaclone/main.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/providers/search_page_provider.dart';
import 'package:instaclone/screens/authentication_wrapper.dart';
import 'package:instaclone/screens/login_page/login_page.dart';
import 'package:instaclone/utils/authentication_service.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:provider/provider.dart';

class MenuSheet extends StatelessWidget {
  const MenuSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle listTileTextStyle = TextStyle(
      color: ProjectConstants.getPrimaryColor(context, false),
      fontWeight: FontWeight.w600,
    );

    void directToLoginPage() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthenticationWrapper(),
        ),
      );
    }

    void restartApp() {
      RestartWidget.restartApp(context);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.3),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(
            'Settings',
            style: listTileTextStyle,
          ),
          onTap: () {
            // TODO : IMPLEMENT SETTINGS SCREEN
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_activity_outlined),
          title: Text(
            'Your activity',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.archive_outlined),
          title: Text(
            'Archive',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.qr_code),
          title: Text(
            'QR Code',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.save_rounded),
          title: Text(
            'Saved',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.favorite_border),
          title: Text(
            'Favorites',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(
            'Sign out',
            style: listTileTextStyle,
          ),
          onTap: () async {
            context.read<HomePageProvider>().userStream = null;
            context.read<HomePageProvider>().chatsStream = null;
            context.read<HomePageProvider>().postsStream = null;
            context.read<HomePageProvider>().specifiedChatStream = null;

            context.read<ProfilePageProvider>().userPostsStream = null;
            context.read<ProfilePageProvider>().anotherUserPostsStream = null;

            context.read<SearchPageProvider>().postsStream = null;
            await context.read<AuthenticationService>().signOut();
            restartApp();
          },
        ),
      ],
    );
  }
}
