import 'package:flutter/material.dart';
import 'package:instaclone/providers/home_page_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:provider/provider.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({Key? key}) : super(key: key);

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return Scaffold(
      appBar: AppBar(
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
        title: const Text('Messages'),
        centerTitle: false,
        leading: BackButton(
          color: primaryColor,
          onPressed: () {
            context
                .read<HomePageProvider>()
                .pageController
                .animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.ease);
          },
        ),
      ),
    );
  }
}
