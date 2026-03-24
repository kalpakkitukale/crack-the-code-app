/// Summary repository interface for managing video summaries
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/study_tools/video_summary.dart';

/// Repository interface for video summary operations
abstract class SummaryRepository {
  /// Get summary for a specific video and segment
  Future<Either<Failure, VideoSummary?>> getSummary(String videoId, String segment);

  /// Save or update a video summary
  Future<Either<Failure, VideoSummary>> saveSummary(VideoSummary summary);

  /// Delete summary for a video
  Future<Either<Failure, void>> deleteSummary(String videoId);
}
