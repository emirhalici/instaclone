import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostWidget extends StatefulWidget {
  PostModel post;
  PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Color getColor() {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
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
        CarouselSlider(
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Stack(
            children: [
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
                      SvgPicture.asset(
                        'assets/icons/heart.svg',
                        color: getColor(),
                      ),
                      SizedBox(width: 14.w),
                      SvgPicture.asset(
                        'assets/icons/comment.svg',
                        color: getColor(),
                      ),
                      SizedBox(width: 14.w),
                      SvgPicture.asset(
                        'assets/icons/share.svg',
                        color: getColor(),
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/icons/bookmark.svg',
                    color: getColor(),
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
                '${widget.post.likes.length} likes',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: widget.post.username, style: const TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: ' ${widget.post.description}'),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
