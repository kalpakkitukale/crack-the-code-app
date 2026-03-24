import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/models/lesson.dart';

final episodesProvider = FutureProvider<List<Episode>>((ref) async {
  final jsonString =
      await rootBundle.loadString('assets/data/episodes/video_course.json');
  final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
  return jsonList
      .map((e) => Episode.fromJson(e as Map<String, dynamic>))
      .toList();
});

final episodeByIdProvider =
    Provider.family<Episode?, String>((ref, episodeId) {
  final episodes = ref.watch(episodesProvider).valueOrNull ?? [];
  return episodes.where((e) => e.id == episodeId).firstOrNull;
});
