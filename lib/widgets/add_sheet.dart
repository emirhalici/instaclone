import 'package:flutter/material.dart';
import 'package:instaclone/utils/project_constants.dart';

class AddSheet extends StatelessWidget {
  const AddSheet({Key? key}) : super(key: key);

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
          leading: const Icon(Icons.grid_on),
          title: Text(
            'Post',
            style: listTileTextStyle,
          ),
          onTap: () {
            // TODO : IMPLEMENT ADD POST SCREEN
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_activity_outlined),
          title: Text(
            'Reels',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.archive_outlined),
          title: Text(
            'Story',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.access_alarm),
          title: Text(
            'Special Story',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.live_tv),
          title: Text(
            'Live',
            style: listTileTextStyle,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.newspaper),
          title: Text(
            'Guide',
            style: listTileTextStyle,
          ),
        ),
      ],
    );
  }
}
