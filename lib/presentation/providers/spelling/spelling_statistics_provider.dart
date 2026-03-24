import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/domain/entities/spelling/spelling_statistics.dart';
import 'package:crack_the_code/infrastructure/di/injection_container.dart';

class SpellingStatsState {
  final SpellingStatistics? stats;
  final bool isLoading;
  final String? error;

  const SpellingStatsState({this.stats, this.isLoading = false, this.error});

  SpellingStatsState copyWith({SpellingStatistics? stats, bool? isLoading, String? error}) {
    return SpellingStatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SpellingStatsNotifier extends StateNotifier<SpellingStatsState> {
  SpellingStatsNotifier() : super(const SpellingStatsState());

  Future<void> load({String? profileId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await injectionContainer.getSpellingStatisticsUseCase(profileId: profileId);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error.toString()),
        (stats) => state = state.copyWith(isLoading: false, stats: stats),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final spellingStatsProvider =
    StateNotifierProvider<SpellingStatsNotifier, SpellingStatsState>(
  (ref) => SpellingStatsNotifier(),
);
