import 'package:flutter/material.dart';
import 'package:instaclone/utils/project_constants.dart';

class ProjectUtils {
  static String timestampToString(DateTime then, DateTime now) {
    Duration difference = now.difference(then);
    String returnStr = '';
    if (difference.inDays >= 365) {
      returnStr = difference.inDays == 365 ? '1 year ago' : '${difference.inDays ~/ 365} years ago';
    } else if (difference.inDays >= 30) {
      returnStr = difference.inDays == 30 ? '1 month ago' : '${difference.inDays ~/ 30} months ago';
    } else if (difference.inDays >= 1) {
      returnStr = difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      returnStr = difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      returnStr = difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      returnStr = '${difference.inSeconds} seconds ago';
    }
    return returnStr;
  }

  static void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 500),
        backgroundColor: ProjectConstants.blueColor,
      ),
    );
  }

  static void showBottomSheet(BuildContext context, Widget Function(BuildContext) builder) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: builder,
    );
  }
}
