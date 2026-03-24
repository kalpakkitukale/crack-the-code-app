import 'package:dartz/dartz.dart';
import 'package:streamshaala/domain/entities/spelling/word_list.dart';
import 'package:streamshaala/domain/repositories/spelling_repository.dart';

class GetWordListsUseCase {
  final SpellingRepository repository;

  GetWordListsUseCase(this.repository);

  Future<Either<Exception, List<WordList>>> call({int? gradeLevel, String? category}) {
    return repository.getWordLists(gradeLevel: gradeLevel, category: category);
  }
}
