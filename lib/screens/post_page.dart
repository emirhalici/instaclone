import 'package:flutter/material.dart';
import 'package:instaclone/widgets/post_widget.dart';

import '../utils/project_constants.dart';

class PostPage extends StatefulWidget {
  final PostWidget postWidget;
  const PostPage({Key? key, required this.postWidget}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: primaryColor,
        backgroundColor: primaryColorReversed,
        title: const Text('Explore'),
        centerTitle: false,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: widget.postWidget,
    );
  }
}
