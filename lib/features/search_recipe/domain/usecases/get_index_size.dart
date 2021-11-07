import 'package:dartz/dartz.dart';

import '../repositories/recipes_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetIndexSize implements UseCase<int, NoParams> {
  final RecipesRepository repository;

  GetIndexSize(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) =>
      repository.getIndexSize();
}
