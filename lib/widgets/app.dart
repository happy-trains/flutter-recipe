import 'package:flutter/material.dart';

import 'home_page.dart';
import '../constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${Constants.appName} - ${Constants.appAbout}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: Constants.appName),
    );
  }
}
