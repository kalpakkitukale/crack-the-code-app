/// Use case for adding a bookmark
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/bookmark.dart';
import 'package:crack_the_code/domain/repositories/bookmark_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Add a bookmark for a video
class AddBookmarkUseCase implements BaseUseCase<Bookmark, Bookmark> {
  final BookmarkRepository repository;

  const AddBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, Bookmark>> call(Bookmark params) async {
    return await repository.addBookmark(params);
  }
}
