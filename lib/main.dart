import 'package:flutter/material.dart';
import 'package:flutter_feed_test/app/app.dart';
import 'package:flutter_feed_test/app/injection.dart' as di;

void main() async {
  await di.init();
  runApp(const App());
}
