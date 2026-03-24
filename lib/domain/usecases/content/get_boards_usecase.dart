/// Use case for getting all boards
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/content/board.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Get all available educational boards
class GetBoardsUseCase implements NoParamsUseCase<List<Board>> {
  final ContentRepository repository;

  const GetBoardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Board>>> call() async {
    return await repository.getBoards();
  }
}
