/// Use case for deleting a note
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/repositories/note_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Delete a note by ID
class DeleteNoteUseCase implements BaseUseCase<void, String> {
  final NoteRepository repository;

  const DeleteNoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String noteId) async {
    return await repository.deleteNote(noteId);
  }
}
