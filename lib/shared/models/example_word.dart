class ExampleWord {
  final String word;
  final String emoji;
  final String audioFile;
  final String? imageAsset;

  const ExampleWord({
    required this.word,
    required this.emoji,
    required this.audioFile,
    this.imageAsset,
  });

  factory ExampleWord.fromJson(Map<String, dynamic> json) {
    return ExampleWord(
      word: json['word'] as String,
      emoji: json['emoji'] as String? ?? '',
      audioFile: json['audioFile'] as String? ?? '',
      imageAsset: json['imageAsset'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'emoji': emoji,
        'audioFile': audioFile,
        if (imageAsset != null) 'imageAsset': imageAsset,
      };
}
