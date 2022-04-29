import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/models/comment_model.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/models/reply_model.dart';
import 'package:instaclone/providers/posts_provider.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/widgets/comment_widget.dart';
import 'package:instaclone/widgets/duration_timer_widget.dart';
import 'package:provider/provider.dart';

class PostCommentsWidget extends StatefulWidget {
  final PostModel post;
  const PostCommentsWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCommentsWidget> createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends State<PostCommentsWidget> {
  List<Map<String, dynamic>> users = [];
  TextEditingController userCommentTextController = TextEditingController();
  String userCommentText = '';

  @override
  void initState() {
    super.initState();
    getUsersForComments();
  }

  Future<void> getUsersForComments() async {
    if (widget.post.comments.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await context.read<PostsProvider>().getUsersForComments(widget.post);
      for (var element in usersSnapshot.docs) {
        users.add(element.data());
      }
      setState(() {});
    }
  }

  Map<String, dynamic> getUserFromUsers(String userUUID) {
    for (var user in users) {
      if (user['userUUID'] == userUUID) {
        return user;
      }
    }
    throw 'user not found error: given userUUID $userUUID doesn\'t match in the users. users: ${users.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.comments.isNotEmpty && users.isEmpty) {
      getUsersForComments();
    }

    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    List<Widget> comments = [];

    for (var comment in widget.post.comments) {
      if (users.isNotEmpty) {
        try {
          comments.add(
            CommentWidget(
              commentModel: comment,
              userModel: getUserFromUsers(comment.userUUID),
            ),
          );
        } catch (e) {
          // TODO : URGENT
          // TODO : HANDLE UNEXPECTED USER NOT FOUND ERROR
        }
      }
    }

    void showErrorMessageToUser() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while posting a comment'),
          duration: Duration(milliseconds: 500),
          backgroundColor: ProjectConstants.blueColor,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        toolbarHeight: ProjectConstants.toolbarHeight,
        automaticallyImplyLeading: true,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        title: const Text('Comments'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // TODO : IMPLEMENT SHARE POST SCREEN
            },
            icon: SvgPicture.asset(
              'assets/icons/share.svg',
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  foregroundImage: (widget.post.userData['profilePic'] != null && widget.post.userData['profilePic'] != '')
                      ? NetworkImage(widget.post.userData['profilePic'])
                      : const AssetImage('assets/images/default_profile_pic.png') as ImageProvider,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: primaryColor,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO : IMPLEMENT GO THE PROFILE
                                  },
                                  child: Text(
                                    widget.post.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.post.description}',
                              ),
                            ],
                          ),
                        ),
                        DurationTimerWidget(
                          date: widget.post.timestamp.toDate(),
                          textStyle: TextStyle(
                            color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: ProjectConstants.getPrimaryColor(context, false).withOpacity(0.3),
            width: double.infinity,
            height: 0.5,
          ),
          if (comments.isNotEmpty)
            users.isEmpty
                ? Expanded(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: ProjectConstants.getPrimaryColor(context, false),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: comments,
                      ),
                    ),
                  )
          else
            Expanded(child: Container()),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  foregroundImage: (widget.post.userData['profilePic'] != null && widget.post.userData['profilePic'] != '')
                      ? NetworkImage(widget.post.userData['profilePic'])
                      : const AssetImage('assets/images/default_profile_pic.png') as ImageProvider,
                  radius: 24,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: TextField(
                    controller: userCommentTextController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      setState(() {
                        userCommentText = value;
                      });
                    },
                    minLines: 1,
                    maxLines: 3,
                    expands: false,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Add a comment...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      suffix: GestureDetector(
                        onTap: () async {
                          CommentModel comment = CommentModel(
                            comment: userCommentText,
                            likes: <String>[],
                            userUUID: context.read<ProfilePageProvider>().loggedInUser!.uid,
                            replies: <ReplyModel>[],
                            timestamp: Timestamp.now(),
                          );
                          widget.post.comments.add(comment);
                          bool isSuccess = await context.read<PostsProvider>().writePost(widget.post);
                          if (isSuccess) {
                            userCommentTextController.clear();
                            setState(() {
                              userCommentText = '';
                            });
                          } else {
                            widget.post.comments.remove(comment);
                            showErrorMessageToUser();
                          }
                        },
                        child: Text(
                          'Post  ',
                          style: TextStyle(
                            color: userCommentText == '' ? ProjectConstants.blueColor.withAlpha(100) : ProjectConstants.blueColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      fillColor: primaryColorReversed,
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
