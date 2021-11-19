import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/recipe.dart';

part 'search_recipe_event.dart';
part 'search_recipe_state.dart';

class SearchRecipeBloc extends Bloc<SearchRecipeEvent, SearchRecipeState> {
  SearchRecipeBloc() : super(Empty()) {
    on<SearchRecipeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
