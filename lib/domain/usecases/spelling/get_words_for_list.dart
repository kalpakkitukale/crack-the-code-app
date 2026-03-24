import 'package:dartz/dartz.dart';
import 'package:streamshaala/domain/entities/spelling/word.dart';
import 'package:streamshaala/domain/repositories/spelling_repository.dart';

class GetWordsForListUseCase {
  final SpellingRepository repository;

  GetWordsForListUseCase(this.repository);

  Future<Either<Exception, List<Word>>> call(String wordListId) {
    return repository.getWordsForList(wordListId);
  }
}
