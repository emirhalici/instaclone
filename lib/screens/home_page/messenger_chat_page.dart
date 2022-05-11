import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/models/chat_model.dart';
import 'package:instaclone/models/message_model.dart';
import 'package:instaclone/models/user_model.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:provider/provider.dart';

class MessengerChatPage extends StatefulWidget {
  final String documentId;
  const MessengerChatPage({super.key, required this.documentId});

  @override
  State<MessengerChatPage> createState() => _MessengerChatPageState();
}

class _MessengerChatPageState extends State<MessengerChatPage> {
  @override
  void initState() {
    context.read<HomePageProvider>().getSpecifiedChatStream(widget.documentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);
    var stream = context.watch<HomePageProvider>().specifiedChatStream;

    print('document id: ${widget.documentId}');
    if (stream == null) {
      print('stream is null');
      return Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: primaryColor,
        ),
      );
    } else {
      return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<ChatModel> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('connection is waiting');
            return Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: primaryColor,
              ),
            );
          }

          // sort messages so they are reversed
          snapshot.data?.messages.sort(
            (a, b) => a.timestamp.compareTo(b.timestamp),
          );

          String chatTitleText;
          if (snapshot.data == null || snapshot.data!.users == null || snapshot.data!.users!.isEmpty) {
            chatTitleText = 'Unnamed chat room';
          } else if (snapshot.data!.users!.length == 1) {
            chatTitleText = snapshot.data!.users!.first.name;
          } else {
            List<String> users = [];
            for (var element in snapshot.data!.users!) {
              users.add(element.name);
            }
            chatTitleText = users.join(', ');
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: primaryColorReversed,
              foregroundColor: primaryColor,
              toolbarHeight: ProjectConstants.toolbarHeight,
              centerTitle: false,
              leadingWidth: 26,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    foregroundImage: (snapshot.data == null ||
                            snapshot.data!.users == null ||
                            snapshot.data!.users!.isEmpty ||
                            snapshot.data!.users![0].profilePic == '')
                        ? const AssetImage('assets/images/default_profile_pic.png') as ImageProvider
                        : CachedNetworkImageProvider(snapshot.data!.users![0].profilePic),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatTitleText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              reverse: false,
              //physics: const ClampingScrollPhysics(),
              itemCount: snapshot.data?.messages.length,
              itemBuilder: ((context, index) {
                if (index == 0) {
                  print('item count: ${snapshot.data?.messages.length}');
                }
                MessageModel? message = snapshot.data?.messages[index];
                bool isMe = message?.senderUUID == context.read<HomePageProvider>().userModel?.userUUID;

                List<Widget> widgets = [];
                if (index == 0) {
                  DateTime date = message!.timestamp.toDate();
                  String dateString =
                      ProjectUtils.isDateToday(date) ? ProjectUtils.dateTimeToString(date) : ProjectUtils.dateTimeToStringWithDate(date);
                  widgets.add(
                    Center(
                      child: Text(
                        dateString,
                        style: ProjectConstants.chatMessagesDateTextStyle(context),
                      ),
                    ),
                  );
                } else {
                  DateTime date1 = message!.timestamp.toDate();
                  DateTime date2 = snapshot.data!.messages[index - 1].timestamp.toDate();
                  int diffInSeconds = ProjectUtils.timeDifferenceInSeconds(date1, date2);
                  if (diffInSeconds > 60) {
                    String dateString = ProjectUtils.isDateToday(date1)
                        ? ProjectUtils.dateTimeToString(date1)
                        : ProjectUtils.dateTimeToStringWithDate(date1);
                    widgets.add(
                      Center(
                        child: Text(
                          dateString,
                          style: TextStyle(
                            color: primaryColor.withOpacity(0.5),
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    );
                  }
                }
                UserModel? user = isMe
                    ? context.read<HomePageProvider>().userModel
                    : snapshot.data?.users?.firstWhere((element) => element.userUUID == message.senderUUID);

                if (isMe) {
                  widgets.add(
                    Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 0,
                          borderRadius: const BorderRadius.all(Radius.circular(22.0)),
                          color: ProjectConstants.blueColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(message.message),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  widgets.add(
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            foregroundImage: (user == null || user.profilePic == '')
                                ? const AssetImage('assets/images/default_profile_pic.png') as ImageProvider
                                : CachedNetworkImageProvider(user.profilePic),
                            radius: 16,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 0,
                                borderRadius: const BorderRadius.all(Radius.circular(22.0)),
                                color: primaryColor.withOpacity(0.15),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Flexible(child: Text(message.message)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  children: widgets,
                );
              }),
            ),
          );
        },
      );
    }
  }
}
