/// Use case for getting progress statistics
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/repositories/progress_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Get completion statistics
class GetStatisticsUseCase implements NoParamsUseCase<ProgressStats> {
  final ProgressRepository repository;

  const GetStatisticsUseCase(this.repository);

  @override
  Future<Either<Failure, ProgressStats>> call() async {
    return await repository.getStatistics();
  }
}
