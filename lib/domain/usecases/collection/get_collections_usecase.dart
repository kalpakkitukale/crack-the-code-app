/// Use case for getting all collections
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/collection.dart';
import 'package:crack_the_code/domain/repositories/collection_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Get all collections for the current user
class GetCollectionsUseCase implements NoParamsUseCase<List<Collection>> {
  final CollectionRepository repository;

  const GetCollectionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Collection>>> call() async {
    return await repository.getAllCollections();
  }
}
