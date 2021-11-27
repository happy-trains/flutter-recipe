import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../../core/utils/output_converter.dart';
import '../bloc/search_recipe_bloc.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';

class SearchRecipesPage extends StatelessWidget {
  final OutputConverter outputConverter;

  SearchRecipesPage({Key? key, required this.outputConverter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
        actions: [
          SearchBar(),
        ],
      ),
      body: Column(
        children: [
          SearchInfo(outputConverter: outputConverter),
          SearchResults(),
        ],
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BlocBuilder<SearchRecipeBloc, SearchRecipeState>(
        builder: (context, state) {
          if (state.status == SearchStatus.loading) {
            return Center(child: const CircularProgressIndicator());
          }

          if (state.status == SearchStatus.failure) {
            Future.delayed(Duration.zero).then(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureMessage),
                ),
              ),
            );
          }

          if (state.status == SearchStatus.success) {
            final recipes = state.recipes;

            if (state.resultCount < 0) {
              return const SizedBox();
            }

            return ListView.separated(
              itemBuilder: (_, index) => RecipeCard(
                recipes[index],
                isFirst: index == 0,
                isLast: index == recipes.length - 1,
              ),
              separatorBuilder: (_, __) => SizedBox(
                height: 5,
              ),
              itemCount: recipes.length,
            );
          } else {
            return const SizedBox();
          }
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
