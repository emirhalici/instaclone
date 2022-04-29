import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/providers/posts_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:provider/provider.dart';

class AddPostFollowingPage extends StatefulWidget {
  final List<XFile> images;
  const AddPostFollowingPage({Key? key, required this.images}) : super(key: key);

  @override
  State<AddPostFollowingPage> createState() => _AddPostFollowingPageState();
}

class _AddPostFollowingPageState extends State<AddPostFollowingPage> {
  final TextEditingController _descriptionTextController = TextEditingController();
  List<String> imageURLs = [];
  bool isLoading = false;

  void popUntilFirstRoute() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<bool> addNewPost(PostModel postModel) async {
    return await context.read<PostsProvider>().addNewPost(postModel);
  }

  @override
  Widget build(BuildContext context) {
    String userUUID = context.watch<User?>()!.uid;

    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: primaryColor,
        backgroundColor: primaryColorReversed,
        title: const Text('New Post'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (imageURLs.isEmpty) {
                for (var img in widget.images) {
                  String url = await context.read<PostsProvider>().uploadImage(img);
                  imageURLs.add(url);
                }
              }
              PostModel postModel = PostModel.newModelForUpload(
                userUUID,
                imageURLs,
                _descriptionTextController.text.trim(),
              );
              bool response = await addNewPost(postModel);
              if (response) {
                popUntilFirstRoute();
              } else {
                // TODO : SHOW SNACKBAR WITH RESPONSE
                setState(() {
                  isLoading = false;
                });
              }
            },
            icon: const Icon(Icons.done),
            tooltip: 'Next',
            color: ProjectConstants.blueColor,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(
                    File(widget.images[0].path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                  child: TextField(
                controller: _descriptionTextController,
                decoration: const InputDecoration(
                  hintText: 'Write a description...',
                ),
              )),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator.adaptive(),
            )
        ],
      ),
    );
  }
}
