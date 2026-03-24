/// Use case for getting watch history
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/progress.dart';
import 'package:streamshaala/domain/repositories/progress_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Get watch history sorted by last watched (recent first)
class GetWatchHistoryUseCase implements BaseUseCase<List<Progress>, GetWatchHistoryParams> {
  final ProgressRepository repository;

  const GetWatchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Progress>>> call(GetWatchHistoryParams params) async {
    return await repository.getWatchHistory(limit: params.limit);
  }
}

/// Parameters for getting watch history
class GetWatchHistoryParams {
  final int? limit;

  const GetWatchHistoryParams({this.limit});
}
