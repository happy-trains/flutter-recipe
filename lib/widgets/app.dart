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
        colorScheme: ColorScheme(
          primary: const Color(0xfff3dfa2),
          primaryVariant: const Color(0xffe7c763),
          secondary: const Color(0xffb71f3a),
          secondaryVariant: const Color(0xff801025),
          surface: Colors.white,
          background: Colors.white,
          error: const Color(0xffb28c17),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xfff3dfa2),
          centerTitle: true,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'Averia Serif Libre',
            color: Colors.black,
            fontSize: 24,
          ),
          headline2: TextStyle(
            color: const Color(0xff801025),
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      home: BlocProvider(
        create: (_) => sl<SearchRecipeBloc>()..add(GetIndexSize()),
        child: SearchRecipesPage(
          outputConverter: sl(),
        ),
      ),
    );
  }
}
