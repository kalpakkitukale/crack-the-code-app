import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crack_the_code/games/daily_decoder/models/daily_puzzle.dart';

final todayPuzzleProvider = Provider<DailyPuzzle>((ref) {
  return DailyPuzzle(date: DateTime.now());
});

const _boxName = 'daily_decoder_progress';

final decoderProgressProvider =
    NotifierProvider<DecoderProgressNotifier, DecoderProgress>(DecoderProgressNotifier.new);

class DecoderProgressNotifier extends Notifier<DecoderProgress> {
  @override
  DecoderProgress build() {
    try {
      final box = Hive.box<String>(_boxName);
      final json = box.get('progress');
      if (json == null) return const DecoderProgress();
      return DecoderProgress.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return const DecoderProgress();
    }
  }

  Future<void> completeToday(int score) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    state = state.withScore(today, score);
    try {
      final box = Hive.box<String>(_boxName);
      await box.put('progress', jsonEncode(state.toJson()));
    } catch (_) {}
  }
}
