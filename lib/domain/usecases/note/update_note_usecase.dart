/// Use case for updating an existing note
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/domain/entities/user/note.dart';
import 'package:crack_the_code/domain/repositories/note_repository.dart';
import 'package:crack_the_code/domain/usecases/base/base_usecase.dart';

/// Update an existing note
class UpdateNoteUseCase implements BaseUseCase<Note, Note> {
  final NoteRepository repository;

  const UpdateNoteUseCase(this.repository);

  @override
  Future<Either<Failure, Note>> call(Note note) async {
    return await repository.updateNote(note);
  }
}
