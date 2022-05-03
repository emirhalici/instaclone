import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/user_model.dart';
import 'package:instaclone/providers/profile_page_provider.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:instaclone/utils/project_utils.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    nameTextController.text = widget.user.name;
    usernameTextController.text = widget.user.username;
    descriptionTextController.text = widget.user.description;
    super.initState();
  }

  void showErrorSnackbar() {
    ProjectUtils.showSnackBarMessage(context, 'An unexpected error occured while saving user');
  }

  void popStack() {
    Navigator.pop(context);
  }

  void updateProfilePic(XFile? image) async {
    print('updating profile pic:');
    if (image != null) {
      String imgLink = await context.read<ProfilePageProvider>().uploadProfilePicture(image);
      setState(() {
        widget.user.profilePic = imgLink;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget changeProfilePicMenu(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera),
          title: Text(
            'Pick From Camera',
            style: TextStyle(
              color: ProjectConstants.getPrimaryColor(context, false),
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            final image = await ImagePicker().pickImage(source: ImageSource.camera);
            Navigator.pop(context);
            updateProfilePic(image);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo),
          title: Text(
            'Pick From Gallery',
            style: TextStyle(
              color: ProjectConstants.getPrimaryColor(context, false),
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            final image = await ImagePicker().pickImage(source: ImageSource.gallery);
            Navigator.pop(context);
            updateProfilePic(image);
          },
        ),
        if (isLoading)
          CircularProgressIndicator.adaptive(
            backgroundColor: ProjectConstants.getPrimaryColor(context, false),
          ),
      ],
    );
  }

  void setUser() {
    context.read<ProfilePageProvider>().userModel = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = ProjectConstants.getPrimaryColor(context, false);
    Color primaryColorReversed = ProjectConstants.getPrimaryColor(context, true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        shape: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        backgroundColor: primaryColorReversed,
        foregroundColor: primaryColor,
        toolbarHeight: ProjectConstants.toolbarHeight,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              widget.user.name = nameTextController.text.trim();
              widget.user.username = usernameTextController.text.trim();
              widget.user.description = descriptionTextController.text.trim();

              bool response = await context.read<ProfilePageProvider>().writeUser(widget.user);

              setState(() {
                isLoading = false;
              });

              if (response == true) {
                setUser();
                popStack();
              } else {
                showErrorSnackbar();
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: ProjectConstants.blueColor,
                fontSize: 16.sp,
              ),
            ),
          )
        ],
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22.h),
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                builder: (context) => changeProfilePicMenu(context),
              ),
              child: Center(
                child: widget.user.profilePic == ''
                    ? const SizedBox(
                        width: 86.0,
                        height: 86.0,
                        child: CircleAvatar(
                          foregroundImage: AssetImage('assets/images/default_profile_pic.png'),
                        ),
                      )
                    : SizedBox(
                        width: 86.0,
                        height: 86.0,
                        child: CircleAvatar(
                          foregroundImage: NetworkImage(widget.user.profilePic),
                        ),
                      ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  builder: (context) => changeProfilePicMenu(context));
            },
            child: const Text(
              'Change Profile Picture',
              style: TextStyle(
                color: ProjectConstants.blueColor,
              ),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Name'),
                Expanded(
                  child: TextField(
                    controller: nameTextController,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Username'),
                Expanded(
                  child: TextField(
                    controller: usernameTextController,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Biography'),
                Expanded(
                  child: TextField(
                    controller: descriptionTextController,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            CircularProgressIndicator.adaptive(
              backgroundColor: primaryColor,
            )
        ],
      ),
    );
  }
}
