/// Use case for adding a new note
library;

import 'package:dartz/dartz.dart';
import 'package:streamshaala/core/errors/failures.dart';
import 'package:streamshaala/domain/entities/user/note.dart';
import 'package:streamshaala/domain/repositories/note_repository.dart';
import 'package:streamshaala/domain/usecases/base/base_usecase.dart';

/// Add a new note for a video
class AddNoteUseCase implements BaseUseCase<Note, Note> {
  final NoteRepository repository;

  const AddNoteUseCase(this.repository);

  @override
  Future<Either<Failure, Note>> call(Note note) async {
    return await repository.addNote(note);
  }
}
