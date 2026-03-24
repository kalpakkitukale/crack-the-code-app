import 'package:dartz/dartz.dart';
import 'package:crack_the_code/domain/entities/spelling/phonics_pattern.dart';
import 'package:crack_the_code/domain/repositories/spelling_repository.dart';

class GetPhonicsPatterns {
  final SpellingRepository repository;

  GetPhonicsPatterns(this.repository);

  Future<Either<Exception, List<PhonicsPattern>>> call({int? gradeLevel}) {
    return repository.getPhonicsPatterns(gradeLevel: gradeLevel);
  }
}
