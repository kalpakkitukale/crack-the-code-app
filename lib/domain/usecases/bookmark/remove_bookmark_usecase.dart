/// Use case for removing a bookmark
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/repositories/bookmark_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Remove a bookmark by video ID
class RemoveBookmarkUseCase implements BaseUseCase<void, String> {
  final BookmarkRepository repository;

  const RemoveBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String videoId) async {
    return await repository.removeBookmark(videoId);
  }
}
