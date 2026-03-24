import 'package:dartz/dartz.dart';
import 'package:streamshaala/domain/entities/spelling/spelling_statistics.dart';
import 'package:streamshaala/domain/repositories/spelling_repository.dart';

class GetSpellingStatisticsUseCase {
  final SpellingRepository repository;

  GetSpellingStatisticsUseCase(this.repository);

  Future<Either<Exception, SpellingStatistics>> call({String? profileId}) {
    return repository.getStatistics(profileId: profileId);
  }
}
