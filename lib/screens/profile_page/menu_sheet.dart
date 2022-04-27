import 'package:flutter/material.dart';
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
            await context.read<AuthenticationService>().signOut();
          },
        ),
      ],
    );
  }
}
