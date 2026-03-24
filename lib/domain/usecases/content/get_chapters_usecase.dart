/// Use case for getting chapters
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/content/chapter.dart';
import 'package:crack_the_code/domain/repositories/content_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Get chapters for a subject
class GetChaptersUseCase implements BaseUseCase<List<Chapter>, String> {
  final ContentRepository repository;

  const GetChaptersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Chapter>>> call(String subjectId) async {
    return await repository.getChapters(subjectId);
  }
}
