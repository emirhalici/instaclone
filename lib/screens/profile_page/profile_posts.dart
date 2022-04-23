import 'package:flutter/material.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';

class ProfilePosts extends StatefulWidget {
  const ProfilePosts({Key? key}) : super(key: key);

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = context.watch<ProfilePageProvider>().posts;

    List<PostWidget> postWidgets = [];
    for (var post in posts) {
      postWidgets.add(PostWidget(post: post));
    }

    return posts.isEmpty
        ? const CircularProgressIndicator.adaptive()
        : ListView(
            children: postWidgets,
          );
  }
}
