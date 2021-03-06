import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/utils/project_constants.dart';
import 'package:intl/intl.dart';

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

  static int timeDifferenceInSeconds(DateTime date1, DateTime date2) {
    return date1.difference(date2).inSeconds;
  }

  static bool isDateToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Converts DateTime date into readable String formatted as MONTH DAY, HH:MM AM
  static String dateTimeToStringWithDate(DateTime date) {
    return DateFormat('MMM d ').format(date) + dateTimeToString(date);
  }

  // Converts DateTime date into readable String formatted as HH:MM AM
  static String dateTimeToString(DateTime date) {
    return DateFormat.jm().format(date);
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

  static Widget profilePictureAvatar(String picture, double? radius) => CircleAvatar(
        radius: radius,
        foregroundImage: picture == ''
            ? const AssetImage('assets/images/default_profile_pic.png') as ImageProvider
            : CachedNetworkImageProvider(picture),
      );

  static Widget progressIndicator(Color backgroundColor) => Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: backgroundColor,
          valueColor: const AlwaysStoppedAnimation<Color>(ProjectConstants.blueColor),
        ),
      );
}
