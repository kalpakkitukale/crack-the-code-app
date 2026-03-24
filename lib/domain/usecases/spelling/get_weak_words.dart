import 'package:dartz/dartz.dart';
import 'package:crack_the_code/domain/entities/spelling/word.dart';
import 'package:crack_the_code/domain/repositories/spelling_repository.dart';

class GetWeakWordsUseCase {
  final SpellingRepository repository;

  GetWeakWordsUseCase(this.repository);

  Future<Either<Exception, List<Word>>> call({String? profileId, int limit = 20}) {
    return repository.getWeakWords(profileId: profileId, limit: limit);
  }
}
