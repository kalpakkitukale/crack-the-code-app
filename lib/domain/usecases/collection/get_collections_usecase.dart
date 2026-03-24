/// Use case for getting all collections
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/collection.dart';
import 'package:streamshaala/domain/repositories/collection_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Get all collections for the current user
class GetCollectionsUseCase implements NoParamsUseCase<List<Collection>> {
  final CollectionRepository repository;

  const GetCollectionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Collection>>> call() async {
    return await repository.getAllCollections();
  }
}
