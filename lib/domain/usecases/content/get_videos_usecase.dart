/// Use case for getting videos for a chapter
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/content/video.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Parameters for GetVideosUseCase
class GetVideosParams {
  final String subjectId;
  final String chapterId;

  const GetVideosParams({
    required this.subjectId,
    required this.chapterId,
  });
}

/// Get all videos for a specific chapter
class GetVideosUseCase implements BaseUseCase<List<Video>, GetVideosParams> {
  final ContentRepository repository;

  const GetVideosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Video>>> call(GetVideosParams params) async {
    return await repository.getVideos(
      subjectId: params.subjectId,
      chapterId: params.chapterId,
    );
  }
}
