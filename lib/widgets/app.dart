import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../features/search_recipe/presentation/bloc/search_recipe_bloc.dart';
import '../features/search_recipe/presentation/pages/search_recipes_page.dart';
import '../injection_container.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${Constants.appName} - ${Constants.appAbout}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => sl<SearchRecipeBloc>(),
        child: SearchRecipes(),
      ),
    );
  }
}
