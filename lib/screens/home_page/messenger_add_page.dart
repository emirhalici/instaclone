import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/models/chat_model.dart';
import 'package:instaclone/models/user_model.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/screens/home_page/messenger_chat_page.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:instaclone/widgets/checkbox_list_tile_widget.dart';
import 'package:provider/provider.dart';

class MessengerAddPage extends StatefulWidget {
  const MessengerAddPage({super.key});

  @override
  State<MessengerAddPage> createState() => _MessengerAddPageState();
}

class _MessengerAddPageState extends State<MessengerAddPage> {
  @override
  void initState() {
    super.initState();
    if (context.read<HomePageProvider>().userModel == null) {
      context.read<HomePageProvider>().getUserStream();
    }
    context.read<HomePageProvider>().getFollowingUsersForNewChat();
  }

  void showSnackbarMessage(String message) {
    ProjectUtils.showSnackBarMessage(context, message);
  }

  void redirectToChatPage(String documentId) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MessengerChatPage(documentId: documentId)));
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    List<UserModel>? users = context.watch<HomePageProvider>().followingUserModels;
    List<String> selectedUsers = [];

    if (users == null) {
      context.read<HomePageProvider>().getFollowingUsersForNewChat();
    }

    bool isLoading = false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: ProjectConstants.toolbarHeight,
        shape: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        elevation: 0,
        titleSpacing: 10,
        leadingWidth: 26,
        title: Text(
          'New message',
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () async {
              if (selectedUsers.isEmpty) {
                showSnackbarMessage('Please select users to message');
                return;
              }
              if (isLoading) {
                return;
              }
              isLoading = true;
              selectedUsers.add(context.read<HomePageProvider>().loggedInUser!.uid);
              ChatModel chatModel = ChatModel.newModelForUpload(selectedUsers);
              String response = await context.read<HomePageProvider>().writeNewChatModel(chatModel);
              print('resonse $response');
              if (response != '') {
                redirectToChatPage(response);
              } else {
                showSnackbarMessage('Error while trying to create a chat room');
                isLoading = false;
              }
            },
            child: Text(
              'Chat',
              style: TextStyle(
                fontSize: 18.sp,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 48.h,
              child: TextField(
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  isDense: true,
                  isCollapsed: true,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor:
                      Theme.of(context).brightness == Brightness.dark ? primaryColor.withOpacity(0.15) : primaryColor.withOpacity(0.05),
                  hintText: 'Search',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Following',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (users == null)
            Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: primaryColor,
              ),
            )
          else
            ListView.builder(
              itemCount: users.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => CheckboxListTileWidget(
                  userModel: users[index],
                  onPressedCallback: (UserModel user, bool val) {
                    if (val) {
                      selectedUsers.add(user.userUUID);
                    } else {
                      selectedUsers.remove(user.userUUID);
                    }
                  }),
            ),
        ],
      ),
    );
  }
}
