/// Use case for removing a video from a collection
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/repositories/collection_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Remove a video from a collection
class RemoveVideoFromCollectionUseCase implements BaseUseCase<void, RemoveVideoParams> {
  final CollectionRepository repository;

  const RemoveVideoFromCollectionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveVideoParams params) async {
    return await repository.removeVideoFromCollection(
      collectionId: params.collectionId,
      videoId: params.videoId,
    );
  }
}

/// Parameters for removing a video from a collection
class RemoveVideoParams {
  final String collectionId;
  final String videoId;

  const RemoveVideoParams({
    required this.collectionId,
    required this.videoId,
  });
}
