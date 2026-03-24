/// Use case for getting subjects
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/content/subject.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Get subjects for a board, class, and stream
class GetSubjectsUseCase implements BaseUseCase<List<Subject>, GetSubjectsParams> {
  final ContentRepository repository;

  const GetSubjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Subject>>> call(GetSubjectsParams params) async {
    return await repository.getSubjects(
      boardId: params.boardId,
      classId: params.classId,
      streamId: params.streamId,
    );
  }
}

/// Parameters for getting subjects
class GetSubjectsParams {
  final String boardId;
  final String classId;
  final String streamId;

  const GetSubjectsParams({
    required this.boardId,
    required this.classId,
    required this.streamId,
  });
}
