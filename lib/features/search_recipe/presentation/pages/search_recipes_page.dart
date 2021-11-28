import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../../core/utils/output_converter.dart';
import '../bloc/search_recipe_bloc.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';

class SearchRecipesPage extends StatefulWidget {
  final OutputConverter outputConverter;

  SearchRecipesPage({Key? key, required this.outputConverter})
      : super(key: key);

  @override
  State<SearchRecipesPage> createState() => _SearchRecipesPageState();
}

class _SearchRecipesPageState extends State<SearchRecipesPage> {
  late final ScrollController _recipesScrollController;

  @override
  void initState() {
    super.initState();
    _recipesScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Constants.appName,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          SearchBar(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SearchInfo(
              outputConverter: widget.outputConverter,
            ),
            SearchResults(
              controller: _recipesScrollController,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _recipesScrollController.dispose();
  }
}

class SearchResults extends StatelessWidget {
  final ScrollController controller;
  const SearchResults({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        BlocProvider.of<SearchRecipeBloc>(context).add(GetNextPage());
      }
    });

    return Flexible(
      child: BlocBuilder<SearchRecipeBloc, SearchRecipeState>(
        builder: (context, state) {
          if (state.status == SearchStatus.failure) {
            Future.delayed(Duration.zero).then(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureMessage),
                ),
              ),
            );
          }

          final recipes = state.recipes;

          if (state.resultCount < 0) {
            return const SizedBox();
          }

          return Column(
            children: [
              if (state.resultCount > -1)
                Flexible(
                  child: ListView.separated(
                    controller: controller,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, index) => RecipeCard(
                      recipes[index],
                      isFirst: index == 0,
                      isLast: index == recipes.length - 1,
                    ),
                    separatorBuilder: (_, __) => SizedBox(
                      height: 5,
                    ),
                    itemCount: recipes.length,
                  ),
                ),
              if (state.status == SearchStatus.loading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}

class SearchInfo extends StatelessWidget {
  const SearchInfo({
    Key? key,
    required this.outputConverter,
  }) : super(key: key);

  final OutputConverter outputConverter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: BlocBuilder<SearchRecipeBloc, SearchRecipeState>(
          builder: (context, state) {
            final stringBuffer = StringBuffer();
            stringBuffer.write('✨ ');

            if (state.status == SearchStatus.success &&
                state.resultCount > -1) {
              final _resultCount =
                  outputConverter.commaSeparatedNumber(state.resultCount);
              stringBuffer.write('$_resultCount results found ');

              if (state.indexSize > -1) {
                final _indexSize =
                    outputConverter.commaSeparatedNumber(state.indexSize);
                stringBuffer.write('- Searched $_indexSize recipes ');
              }

              if (state.searchTime > Duration.zero) {
                final _searchTime = outputConverter
                    .commaSeparatedNumber(state.searchTime.inMilliseconds);
                stringBuffer.write('in ${_searchTime}ms.');
              }
            }

            return Text(
              stringBuffer.toString(),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
    );
  }
}
