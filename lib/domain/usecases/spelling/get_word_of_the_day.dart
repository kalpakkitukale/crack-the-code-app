import 'package:dartz/dartz.dart';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/domain/repositories/spelling_repository.dart';

class GetWordOfTheDayUseCase {
  final SpellingRepository repository;

  GetWordOfTheDayUseCase(this.repository);

  Future<Either<Exception, Word>> call() {
    return repository.getWordOfTheDay();
  }
}
