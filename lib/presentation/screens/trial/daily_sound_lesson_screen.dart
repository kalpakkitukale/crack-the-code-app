import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/core_providers.dart';
import 'package:crack_the_code/shared/providers/trial_provider.dart';
import 'package:crack_the_code/shared/models/sound.dart';
import 'package:crack_the_code/shared/models/character.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_avatar.dart';
import 'package:crack_the_code/games/sound_board/widgets/kk_speech_bubble.dart';
import 'package:crack_the_code/games/sound_board/models/kk_message.dart';

class DailySoundLessonScreen extends ConsumerStatefulWidget {
  final TrialDay trialDay;
  const DailySoundLessonScreen({super.key, required this.trialDay});

  @override
  ConsumerState<DailySoundLessonScreen> createState() => _DailySoundLessonScreenState();
}

class _DailySoundLessonScreenState extends ConsumerState<DailySoundLessonScreen> {
  int _currentIndex = 0;
  bool _soundHeard = false;

  List<Sound> _sounds = [];
  Map<String, Character?> _characters = {};

  @override
  void initState() {
    super.initState();
    _loadSounds();
  }

  void _loadSounds() {
    final soundRepo = ref.read(soundRepositoryProvider);
    final charRepo = ref.read(characterRepositoryProvider);
    _sounds = widget.trialDay.soundIds
        .map((id) => soundRepo.getById(id))
        .whereType<Sound>()
        .toList();

    // Find character for each sound
    for (final s in _sounds) {
      final chars = charRepo.getAll().where((c) => c.soundId == s.id).toList();
      _characters[s.id] = chars.isNotEmpty ? chars.first : null;
    }
  }

  Sound? get _currentSound => _currentIndex < _sounds.length ? _sounds[_currentIndex] : null;
  Character? get _currentChar => _currentSound != null ? _characters[_currentSound!.id] : null;
  bool get _isComplete => _currentIndex >= _sounds.length;
  String get _lang => ref.read(playerProfileProvider).language.name;

  @override
  Widget build(BuildContext context) {
    if (widget.trialDay.isCelebration) return _buildCelebration();
    if (_isComplete) return _buildDayComplete();

    final sound = _currentSound!;
    final character = _currentChar;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0618),
        foregroundColor: Colors.white,
        title: Text('Day ${widget.trialDay.day}: ${widget.trialDay.titleForLang(_lang)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('${_currentIndex + 1}/${_sounds.length}',
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) / _sounds.length,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // KK + character intro
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const KKAvatar(size: 40, animate: false),
                        const SizedBox(width: 10),
                        Expanded(
                          child: KKSpeechBubble(
                            message: KKMessage(
                              text: character != null
                                  ? character.introForLang(_lang)
                                  : 'Listen to this sound: ${sound.notation}',
                              mood: KKMood.excited,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sound card
                    GestureDetector(
                      onTap: () {
                        ref.read(audioRepositoryProvider).playPhonogram(
                          sound.id,
                          notation: sound.notation,
                          exampleWord: sound.exampleWords.isNotEmpty
                              ? sound.exampleWords.first.word
                              : null,
                        );
                        setState(() => _soundHeard = true);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xFFFFD700).withValues(alpha: 0.12),
                            const Color(0xFFFFD700).withValues(alpha: 0.04),
                          ]),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _soundHeard
                                ? const Color(0xFFFFD700).withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.1),
                            width: _soundHeard ? 2 : 1,
                          ),
                          boxShadow: _soundHeard
                              ? [BoxShadow(color: const Color(0xFFFFD700).withValues(alpha: 0.2), blurRadius: 20)]
                              : null,
                        ),
                        child: Column(
                          children: [
                            if (character != null)
                              Text(character.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFFFD700))),
                            const SizedBox(height: 8),
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.3), width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  sound.notation,
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFFFFD700)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(sound.nameForLang(_lang),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text('🔊 Tap to hear',
                                style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4))),
                            if (_soundHeard) ...[
                              const SizedBox(height: 12),
                              Text(sound.mouthFor(_lang),
                                  style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6)),
                                  textAlign: TextAlign.center),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Example words (shown after hearing)
                    if (_soundHeard && sound.exampleWords.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: sound.exampleWords.map((w) {
                          return GestureDetector(
                            onTap: () => ref.read(audioRepositoryProvider).playWord(w.word),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (w.emoji.isNotEmpty) Text(w.emoji, style: const TextStyle(fontSize: 18)),
                                  if (w.emoji.isNotEmpty) const SizedBox(width: 6),
                                  Text(w.word, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                  const SizedBox(width: 4),
                                  Icon(Icons.volume_up, size: 14, color: Colors.white.withValues(alpha: 0.3)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Phonogram spellings
                    if (_soundHeard && sound.phonogramIds.length > 1) ...[
                      const SizedBox(height: 16),
                      Text(
                        '${sound.phonogramIds.length} ways to spell ${sound.notation}:',
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4)),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: sound.phonogramIds.map((p) {
                          return Chip(
                            label: Text(p.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w700)),
                            backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.1),
                            side: BorderSide(color: const Color(0xFFFFD700).withValues(alpha: 0.2)),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _soundHeard ? _onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0A0618),
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.05),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _soundHeard ? 'Next Sound →' : '👆 Tap the card to hear first!',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    final sound = _currentSound;
    if (sound != null) {
      ref.read(trialProgressProvider.notifier).masterSound(sound.id);
    }
    setState(() {
      _currentIndex++;
      _soundHeard = false;
    });
  }

  Widget _buildDayComplete() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text('Day ${widget.trialDay.day} Complete!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                Text('${widget.trialDay.soundCount} sounds mastered today!',
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(trialProgressProvider.notifier).completeDay(widget.trialDay.day);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF0A0618),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCelebration() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0618),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 20),
                const Text('ALL 45 SOUNDS\nMASTERED!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFFFFD700)),
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                const Text('⭐ Sound Explorer Badge',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 24),
                const KKAvatar(size: 56),
                const SizedBox(height: 12),
                Text('Now learn HOW these sounds are spelled!',
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6)),
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(trialProgressProvider.notifier).completeTrial();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF0A0618),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('🚀 Start Learning!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
