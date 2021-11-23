import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../widgets/search_bar.dart';

class SearchRecipes extends StatelessWidget {
  SearchRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
        actions: [
          SearchBar(),
        ],
      ),
      body: const SizedBox(),
    );
  }
}
