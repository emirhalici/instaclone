import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';

class PostCommentsWidget extends StatefulWidget {
  PostModel post;
  PostCommentsWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCommentsWidget> createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends State<PostCommentsWidget> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        toolbarHeight: ProjectConstants.toolbarHeight,
        automaticallyImplyLeading: true,
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
                const CircleAvatar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.sp,
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
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
                        Text(
                          ProjectUtils.timestampToString(widget.post.timestamp, Timestamp.now()),
                          style: TextStyle(
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
          // TODO : IMPLEMENT COMMENTS
        ],
      ),
    );
  }
}
