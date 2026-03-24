import 'package:crack_the_code/shared/models/word_entry.dart';

enum WordBuilderResult { valid, invalid }

class WordBuilderState {
  final List<String> selectedPhonogramIds;
  final List<String> selectedTexts;
  final String? validatedWord;
  final WordEntry? validatedWordEntry;
  final bool isChecking;
  final WordBuilderResult? result;
  final bool isBonusWord;

  const WordBuilderState({
    this.selectedPhonogramIds = const [],
    this.selectedTexts = const [],
    this.validatedWord,
    this.validatedWordEntry,
    this.isChecking = false,
    this.result,
    this.isBonusWord = false,
  });

  factory WordBuilderState.empty() => const WordBuilderState();

  String get assembledText => selectedTexts.join();
  bool get isEmpty => selectedTexts.isEmpty;
  bool get isValid => result == WordBuilderResult.valid;
  bool get isInvalid => result == WordBuilderResult.invalid;

  WordBuilderState copyWith({
    List<String>? selectedPhonogramIds,
    List<String>? selectedTexts,
    String? validatedWord,
    WordEntry? validatedWordEntry,
    bool? isChecking,
    WordBuilderResult? result,
    bool? isBonusWord,
    bool clearResult = false,
    bool clearWordEntry = false,
  }) {
    return WordBuilderState(
      selectedPhonogramIds:
          selectedPhonogramIds ?? this.selectedPhonogramIds,
      selectedTexts: selectedTexts ?? this.selectedTexts,
      validatedWord: clearResult ? null : (validatedWord ?? this.validatedWord),
      validatedWordEntry: clearWordEntry
          ? null
          : (validatedWordEntry ?? this.validatedWordEntry),
      isChecking: isChecking ?? this.isChecking,
      result: clearResult ? null : (result ?? this.result),
      isBonusWord: isBonusWord ?? this.isBonusWord,
    );
  }
}
