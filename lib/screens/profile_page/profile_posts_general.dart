import 'package:flutter/material.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';

class ProfilePostsGeneral extends StatefulWidget {
  final String userUUID;
  const ProfilePostsGeneral({Key? key, required this.userUUID}) : super(key: key);

  @override
  State<ProfilePostsGeneral> createState() => _ProfilePostsGeneralState();
}

class _ProfilePostsGeneralState extends State<ProfilePostsGeneral> {
  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = context.watch<ProfilePageProvider>().anotherUserPosts;

    if (posts.isEmpty) {
      context.watch<ProfilePageProvider>().getPosts(widget.userUUID);
    }

    List<PostWidget> postWidgets = [];
    for (var post in posts) {
      postWidgets.add(PostWidget(post: post));
    }

    return posts.isEmpty
        ? (context.read<ProfilePageProvider>().isUserPostsEmpty
            ? Container()
            : CircularProgressIndicator.adaptive(
                backgroundColor: ProjectConstants.getPrimaryColor(context, false),
              ))
        : ListView(children: postWidgets);
  }
}
