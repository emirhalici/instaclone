import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instaclone/providers/posts_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/widgets/post_comments_widget.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  PostModel post;
  PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);

    //print(widget.post.userData);
    String profilePic = widget.post.userData['profilePic'] ?? '';
    List<String> likes = [];

    for (var item in widget.post.likes) {
      likes.add(item.toString());
    }

    // WHAT KIND OF STUPID LANGUAGE THINKS AN EMPTY ARRAY
    // HAS THE LENGTH OF ONE WHEN DATA INSIDE IS FUCKING
    // EMPTY? I RAGED FOR 20 MINUTES WHILE FIGURING IT OUT
    if (likes.isNotEmpty && likes[0] == '') {
      likes.removeAt(0);
    }

    List<Widget> images = [];
    for (var picture in widget.post.pictures) {
      images.add(
        SizedBox(
          width: double.infinity,
          child: Image.network(
            picture,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 0.5,
          color: primaryColor.withOpacity(0.2),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    foregroundImage: profilePic == ''
                        ? const AssetImage('assets/images/default_profile_pic.png')
                        : NetworkImage(profilePic) as ImageProvider,
                    radius: 16,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    widget.post.username,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/icons/more.svg',
                color: primaryColor,
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              if (widget.post.likes.contains(widget.post.userUUID)) {
                widget.post.likes.remove(widget.post.userUUID);
              } else {
                widget.post.likes.add(widget.post.userUUID);
              }
            });
            context.read<PostsProvider>().writePost(widget.post);
          },
          child: CarouselSlider(
              items: images,
              carouselController: _controller,
              options: CarouselOptions(
                  aspectRatio: 1,
                  viewportFraction: 1,
                  initialPage: 0,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  })),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Stack(
            children: [
              if (images.length > 1)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == entry.key
                                ? Colors.blue
                                : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey).withOpacity(0.3),
                          ));
                    }).toList(),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: SvgPicture.asset(
                          widget.post.likes.contains(widget.post.userUUID) ? 'assets/icons/heart_filled.svg' : 'assets/icons/heart.svg',
                          color: widget.post.likes.contains(widget.post.userUUID) ? const Color(0xFFF3555A) : primaryColor,
                        ),
                        onTap: () {
                          setState(() {
                            if (widget.post.likes.contains(widget.post.userUUID)) {
                              widget.post.likes.remove(widget.post.userUUID);
                            } else {
                              widget.post.likes.add(widget.post.userUUID);
                            }
                          });
                          context.read<PostsProvider>().writePost(widget.post);
                        },
                      ),
                      SizedBox(width: 14.w),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostCommentsWidget(post: widget.post),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/comment.svg',
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      SvgPicture.asset(
                        'assets/icons/share.svg',
                        color: primaryColor,
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/icons/bookmark.svg',
                    color: primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${likes.length} likes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 4.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: widget.post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                    TextSpan(
                      text: ' ${widget.post.description}',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
}
