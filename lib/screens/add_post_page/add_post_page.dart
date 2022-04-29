import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/screens/add_post_page/add_post_following_page.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  void directToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostFollowingPage(images: images),
      ),
    );
  }

  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: primaryColor,
        backgroundColor: primaryColorReversed,
        title: const Text('Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    await Permission.photos.request();
                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    images = [];
                    images.add(image!);
                    if (images.isNotEmpty) directToNextPage();
                  } catch (e) {
                    // TODO : SHOW ERROR MESSAGE
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor.withOpacity(0.2)),
                ),
                child: Text(
                  'Pick From Gallery',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    await Permission.photos.request();
                    final imageLst = await ImagePicker().pickMultiImage();
                    images = [];
                    imageLst?.forEach((element) {
                      images.add(element);
                    });
                    if (images.isNotEmpty) directToNextPage();
                  } catch (e) {
                    // TODO : SHOW ERROR MESSAGE
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor.withOpacity(0.2)),
                ),
                child: Text(
                  'Pick Multiple Images From Gallery',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    await Permission.photos.request();
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);
                    images = [];
                    images.add(image!);
                    if (images.isNotEmpty) directToNextPage();
                  } catch (e) {
                    // TODO : SHOW ERROR MESSAGE
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor.withOpacity(0.2)),
                ),
                child: Text(
                  'Pick From Camera',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
