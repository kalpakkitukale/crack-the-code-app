import 'package:dartz/dartz.dart';
import 'package:crack_the_code/domain/entities/spelling/spelling_attempt.dart';
import 'package:crack_the_code/domain/entities/spelling/word_mastery.dart';
import 'package:crack_the_code/domain/repositories/spelling_repository.dart';
import 'package:crack_the_code/domain/services/word_mastery_service.dart';

class SubmitSpellingAttemptUseCase {
  final SpellingRepository repository;
  final WordMasteryService masteryService;

  SubmitSpellingAttemptUseCase(this.repository, this.masteryService);

  Future<Either<Exception, WordMastery>> call(SpellingAttempt attempt) async {
    // Save the attempt
    final saveResult = await repository.saveSpellingAttempt(attempt);
    if (saveResult.isLeft()) {
      return Left(saveResult.fold((l) => l, (r) => Exception('Unknown error')));
    }

    // Update mastery
    final masteryResult = await repository.getWordMastery(
      attempt.wordId,
      profileId: attempt.profileId,
    );

    return masteryResult.fold(
      (error) => Left(error),
      (currentMastery) async {
        final updatedMastery = masteryService.updateMastery(
          currentMastery.word.isEmpty
              ? WordMastery(
                  wordId: attempt.wordId,
                  word: attempt.word,
                  profileId: attempt.profileId,
                )
              : currentMastery,
          attempt.isCorrect,
        );

        final saveM = await repository.saveWordMastery(updatedMastery);
        return saveM.fold(
          (error) => Left(error),
          (_) => Right(updatedMastery),
        );
      },
    );
  }
}
