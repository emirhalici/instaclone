import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> getUserData() async {
    await context.read<ProfilePageProvider>().getCurrentUserData();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<ProfilePageProvider>().userData;
    if (userData.isEmpty) {
      getUserData();
    }
    print(userData);
    return Scaffold(
      body: Column(
        children: [
          const Text(
            "Profile",
          ),
        ],
      ),
    );
  }
}
