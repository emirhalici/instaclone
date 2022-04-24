import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectUtils {
  static String timestampToString(Timestamp timestamp, Timestamp timestampNow) {
    DateTime now = timestampNow.toDate();
    DateTime then = timestamp.toDate();

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
}
