// function to convert a random Timestamp to friendsly time text
import 'package:cloud_firestore/cloud_firestore.dart';

String convertTimeStamp({required Timestamp postTimestamp}) {
  Timestamp now = Timestamp.now();
  // the time difference in milliseconds from now to when the post was made
  num timeDiff =
      now.millisecondsSinceEpoch - postTimestamp.millisecondsSinceEpoch;
  num secondsDiff = (timeDiff / 1000).floor();

  if (secondsDiff < 60) {
    return ("${secondsDiff}s ago");
  } else if (secondsDiff < 3600) {
    return ("${(secondsDiff / 60).floor()}m ago");
  } else if (secondsDiff < 86400) {
    return ("${(secondsDiff / 3600).floor()}h ago");
  } else if (secondsDiff < 31536000) {
    num dayCount = (secondsDiff / 86400).floor();
    String dayText = "day";
    if (dayCount > 1) {
      dayText = "days";
    }
    return ("${dayCount} $dayText ago");
  } else {
    num yearCount = (secondsDiff / 86400).floor();
    String yearText = "year";
    if (yearCount > 1) {
      yearText = "years";
    }
    return ("${(secondsDiff / 31536000).floor()} $yearText ago");
  }
}
