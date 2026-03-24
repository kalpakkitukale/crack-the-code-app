/// Use case for searching videos
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/content/video.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Search videos with filters
class SearchVideosUseCase implements BaseUseCase<List<Video>, SearchVideosParams> {
  final ContentRepository repository;

  const SearchVideosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Video>>> call(SearchVideosParams params) async {
    return await repository.searchVideos(
      query: params.query,
      difficulty: params.difficulty,
      language: params.language,
      examRelevance: params.examRelevance,
    );
  }
}

/// Parameters for searching videos
class SearchVideosParams {
  final String query;
  final String? difficulty;
  final String? language;
  final List<String>? examRelevance;

  const SearchVideosParams({
    required this.query,
    this.difficulty,
    this.language,
    this.examRelevance,
  });
}
