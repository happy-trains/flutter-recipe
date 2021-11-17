import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'search_recipe_event.dart';
part 'search_recipe_state.dart';

class SearchRecipeBloc extends Bloc<SearchRecipeEvent, SearchRecipeState> {
  SearchRecipeBloc() : super(SearchRecipeInitial()) {
    on<SearchRecipeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
