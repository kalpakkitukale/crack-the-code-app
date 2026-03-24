/// Use case for creating a new collection
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/collection.dart';
import 'package:crack_the_code/domain/repositories/collection_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Create a new video collection
class CreateCollectionUseCase implements BaseUseCase<Collection, Collection> {
  final CollectionRepository repository;

  const CreateCollectionUseCase(this.repository);

  @override
  Future<Either<Failure, Collection>> call(Collection collection) async {
    return await repository.createCollection(collection);
  }
}
