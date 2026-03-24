/// Use case for getting progress statistics
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/repositories/progress_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Get completion statistics
class GetStatisticsUseCase implements NoParamsUseCase<ProgressStats> {
  final ProgressRepository repository;

  const GetStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, ProgressStats>> call() async {
    return await repository.getStatistics();
  }
}
