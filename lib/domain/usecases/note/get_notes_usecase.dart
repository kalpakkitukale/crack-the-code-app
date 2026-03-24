/// Use case for getting notes by video ID
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/note.dart';
import 'package:crack_the_code/domain/repositories/note_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Get all notes for a specific video
class GetNotesUseCase implements BaseUseCase<List<Note>, String> {
  final NoteRepository repository;

  const GetNotesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Note>>> call(String videoId) async {
    return await repository.getNotesByVideoId(videoId);
  }
}
