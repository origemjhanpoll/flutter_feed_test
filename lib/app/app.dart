import 'package:flutter/material.dart';
import 'package:flutter_feed_test/app/views/home_page.dart';
import 'package:flutter_feed_test/core/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
