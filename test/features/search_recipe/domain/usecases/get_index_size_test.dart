import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:recipe/core/usecases/usecase.dart';
import 'package:recipe/features/search_recipe/domain/usecases/get_index_size.dart';

import 'search_recipes_test.mocks.dart';

void main() {
  late GetIndexSize usecase;
  late MockRecipesRepository mockRecipesRepository;

  setUp(() {
    mockRecipesRepository = MockRecipesRepository();
    usecase = GetIndexSize(mockRecipesRepository);
  });

  final mockResult = 2231142;

  test(
    'should get total indexed documents from repository',
    () async {
      // arrange
      when(mockRecipesRepository.getIndexSize())
          .thenAnswer((_) async => Right(mockResult));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(mockResult));
      verify(mockRecipesRepository.getIndexSize());
      verifyNoMoreInteractions(mockRecipesRepository);
    },
  );
}
