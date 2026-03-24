import 'package:dartz/dartz.dart';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/domain/repositories/spelling_repository.dart';

class SearchWordsUseCase {
  final SpellingRepository repository;

  SearchWordsUseCase(this.repository);

  Future<Either<Exception, List<Word>>> call(String query) {
    return repository.searchWords(query);
  }
}
