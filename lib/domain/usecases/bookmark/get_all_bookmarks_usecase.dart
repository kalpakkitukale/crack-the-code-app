/// Use case for getting all bookmarks
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/bookmark.dart';
import 'package:crack_the_code/domain/repositories/bookmark_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Get all bookmarks sorted by created date (newest first)
class GetAllBookmarksUseCase implements NoParamsUseCase<List<Bookmark>> {
  final BookmarkRepository repository;

  const GetAllBookmarksUseCase(this.repository);

  @override
  Future<Either<Failure, List<Bookmark>>> call() async {
    return await repository.getAllBookmarks();
  }
}
