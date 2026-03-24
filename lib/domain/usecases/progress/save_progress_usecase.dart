/// Use case for saving video watch progress
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/progress.dart';
import 'package:streamshaala/domain/repositories/progress_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Save or update progress for a video
class SaveProgressUseCase implements BaseUseCase<Progress, Progress> {
  final ProgressRepository repository;

  const SaveProgressUseCase(this.repository);

  @override
  Future<Either<Failure, Progress>> call(Progress progress) async {
    return await repository.saveProgress(progress);
  }
}
