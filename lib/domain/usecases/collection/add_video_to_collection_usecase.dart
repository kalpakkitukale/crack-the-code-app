/// Use case for adding a video to a collection
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/collection_video.dart';
import 'package:streamshaala/domain/repositories/collection_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Add a video to a collection
class AddVideoToCollectionUseCase implements BaseUseCase<CollectionVideo, CollectionVideo> {
  final CollectionRepository repository;

  const AddVideoToCollectionUseCase(this.repository);

  @override
  Future<Either<Failure, CollectionVideo>> call(CollectionVideo collectionVideo) async {
    return await repository.addVideoToCollection(collectionVideo);
  }
}
