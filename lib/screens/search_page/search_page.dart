import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  TextEditingController searchTextController = TextEditingController();

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    Theme.of(context).brightness == Brightness.dark ? primaryColor.withOpacity(0.15) : primaryColor.withOpacity(0.05),
                hintText: 'Search',
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
                            image: CachedNetworkImageProvider(
                              post.pictures[0],
                            ),
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ));
                    }
                    return Expanded(
                      child: GridView.count(
                        controller: context.read<SearchPageProvider>().searchPostsController,
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        children: postImages,
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
