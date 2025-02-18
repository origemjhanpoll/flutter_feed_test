import 'package:flutter/foundation.dart';

bool isDataEqual(
  List<Map<String, dynamic>> localPosts,
  List<Map<String, dynamic>> apiPosts,
) {
  if (localPosts.length != apiPosts.length) {
    return false;
  }

  for (int i = 0; i < localPosts.length; i++) {
    if (!mapEquals(localPosts[i], apiPosts[i])) {
      return false;
    }
  }

  return true;
}
