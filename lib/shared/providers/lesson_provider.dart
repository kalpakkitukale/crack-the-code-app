import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crack_the_code/shared/models/lesson.dart';

final lessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final jsonString =
      await rootBundle.loadString('assets/data/lessons/learn_the_sounds.json');
  final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
  return jsonList
      .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
      .toList();
});

const _boxName = 'lesson_progress';

final lessonProgressProvider =
    NotifierProvider<LessonProgressNotifier, Map<int, LessonProgress>>(
        LessonProgressNotifier.new);

class LessonProgressNotifier extends Notifier<Map<int, LessonProgress>> {
  @override
  Map<int, LessonProgress> build() {
    try {
      final box = Hive.box<String>(_boxName);
      final result = <int, LessonProgress>{};
      for (final key in box.keys) {
        final json = box.get(key);
        if (json != null) {
          final data = jsonDecode(json) as Map<String, dynamic>;
          final progress = LessonProgress.fromJson(data);
          result[progress.lessonId] = progress;
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> _ensureBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<String>(_boxName);
    }
  }

  bool isLessonCompleted(int lessonId) =>
      state[lessonId]?.completed ?? false;

  bool isLessonUnlocked(int lessonId, int? prerequisite) {
    if (prerequisite == null) return true;
    return isLessonCompleted(prerequisite);
  }

  int get completedCount =>
      state.values.where((p) => p.completed).length;

  int get totalLessons => 7;

  Lesson? nextLesson(List<Lesson> lessons) {
    for (final lesson in lessons) {
      if (!isLessonCompleted(lesson.lessonId)) return lesson;
    }
    return null; // all complete
  }

  Future<void> updateProgress(int lessonId, {
    int? phonogramsLearned,
    int? quizScore,
    bool? completed,
  }) async {
    await _ensureBox();
    final current = state[lessonId] ?? LessonProgress(lessonId: lessonId);
    final updated = current.copyWith(
      phonogramsLearned: phonogramsLearned,
      quizScore: quizScore,
      completed: completed,
      completedAt: completed == true ? DateTime.now() : null,
    );
    state = {...state, lessonId: updated};

    final box = Hive.box<String>(_boxName);
    await box.put(lessonId.toString(), jsonEncode(updated.toJson()));
  }

  Future<void> completeLesson(int lessonId, int phonogramCount, int quizScore) async {
    await updateProgress(
      lessonId,
      phonogramsLearned: phonogramCount,
      quizScore: quizScore,
      completed: true,
    );
  }
}
