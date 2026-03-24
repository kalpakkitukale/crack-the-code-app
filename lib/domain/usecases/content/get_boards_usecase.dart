/// Use case for getting all boards
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/content/board.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Get all available educational boards
class GetBoardsUseCase implements NoParamsUseCase<List<Board>> {
  final ContentRepository repository;

  const GetBoardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Board>>> call() async {
    return await repository.getBoards();
  }
}
