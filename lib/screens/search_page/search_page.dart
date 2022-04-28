import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instaclone/models/post_model.dart';
import 'package:instaclone/providers/search_page_provider.dart';
import 'package:instaclone/screens/post_page.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<void> getSearchPosts() async {
    context.read<SearchPageProvider>().getPostsStreamForSearchPage();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    var stream = context.watch<SearchPageProvider>().postsStream;

    if (stream == null) {
      Future.delayed(Duration.zero, getSearchPosts);
    }

    return SafeArea(
      child: SingleChildScrollView(
        controller: context.read<SearchPageProvider>().searchPostsController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: primaryColor.withOpacity(0.04),
                ),
              ),
            ),
            stream == null
                ? Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: primaryColor,
                    ),
                  )
                : StreamBuilder<List<List<PostModel>>>(
                    stream: stream,
                    builder: (BuildContext context, AsyncSnapshot<List<List<PostModel>>> list) {
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

                      var data = list.data![0];

                      List<Widget> postWidgets = [];
                      List<Widget> postImages = [];
                      for (var post in data) {
                        PostWidget postWidget = PostWidget(post: post);
                        postWidgets.add(postWidget);
                        postImages.add(
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(postWidget: postWidget)));
                            },
                            splashColor: Colors.black.withOpacity(0.2),
                            hoverColor: Colors.black.withOpacity(0.2),
                            focusColor: Colors.black.withOpacity(0.2),
                            highlightColor: Colors.black.withOpacity(0.2),
                            child: Ink.image(
                              fit: BoxFit.cover,
                              image: NetworkImage(post.pictures[0]),
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.width / 3,
                            ),
                          ),
                        );
                      }

                      return StaggeredGrid.count(
                        crossAxisCount: 3,
                        children: postImages,
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
