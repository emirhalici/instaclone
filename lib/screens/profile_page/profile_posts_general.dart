import 'package:flutter/material.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/screens/post_page.dart';
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
  Future<void> getUserPostsStream() async {
    await context.read<ProfilePageProvider>().getAnotherUserPostsStream(widget.userUUID);
    // TODO : HANDLE RESPONSE
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, getUserPostsStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    var stream = context.watch<ProfilePageProvider>().anotherUserPostsStream;

    if (stream == null) {
      Future.delayed(Duration.zero, (() => context.read<ProfilePageProvider>().getAnotherUserPostsStream(widget.userUUID)));
    }

    return stream == null
        ? Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: primaryColor,
            ),
          )
        : StreamBuilder<List<PostModel>>(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot<List<PostModel>> list) {
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

              List<Widget> postWidgets = [];
              List<Widget> postImages = [];
              for (var post in list.data!) {
                PostWidget postWidget = PostWidget(post: post);
                postWidgets.add(postWidget);
                postImages.add(Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(postWidget: postWidget)));
                    },
                    highlightColor: Colors.black.withOpacity(0.2),
                    focusColor: Colors.black.withOpacity(0.2),
                    hoverColor: Colors.black.withOpacity(0.2),
                    splashColor: Colors.black.withOpacity(0.2),
                    child: Ink.image(
                      image: NetworkImage(
                        post.pictures[0],
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      fit: BoxFit.cover,
                    ),
                  ),
                ));
              }
              Future.delayed(Duration.zero, () {
                context.read<ProfilePageProvider>().setAnotherUserPostsCount(postImages.length);
              });
              return GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                children: postImages,
              );
            },
          );
  }
}
