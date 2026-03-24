class AppSettings {
  final double soundVolume;
  final bool showExampleWords;
  final bool showImages;
  final bool showHindiPronunciation;
  final bool showMarathiPronunciation;
  final bool backgroundMusic;
  final String tileSize;
  final double autoPlaySpeed;
  final String? parentalPin;

  const AppSettings({
    this.soundVolume = 0.8,
    this.showExampleWords = true,
    this.showImages = true,
    this.showHindiPronunciation = false,
    this.showMarathiPronunciation = false,
    this.backgroundMusic = false,
    this.tileSize = 'medium',
    this.autoPlaySpeed = 3.0,
    this.parentalPin,
  });

  factory AppSettings.defaults() => const AppSettings();

  AppSettings copyWith({
    double? soundVolume,
    bool? showExampleWords,
    bool? showImages,
    bool? showHindiPronunciation,
    bool? showMarathiPronunciation,
    bool? backgroundMusic,
    String? tileSize,
    double? autoPlaySpeed,
    String? parentalPin,
  }) {
    return AppSettings(
      soundVolume: soundVolume ?? this.soundVolume,
      showExampleWords: showExampleWords ?? this.showExampleWords,
      showImages: showImages ?? this.showImages,
      showHindiPronunciation:
          showHindiPronunciation ?? this.showHindiPronunciation,
      showMarathiPronunciation:
          showMarathiPronunciation ?? this.showMarathiPronunciation,
      backgroundMusic: backgroundMusic ?? this.backgroundMusic,
      tileSize: tileSize ?? this.tileSize,
      autoPlaySpeed: autoPlaySpeed ?? this.autoPlaySpeed,
      parentalPin: parentalPin ?? this.parentalPin,
    );
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic> map) {
    return AppSettings(
      soundVolume: (map['soundVolume'] as num?)?.toDouble() ?? 0.8,
      showExampleWords: map['showExampleWords'] as bool? ?? true,
      showImages: map['showImages'] as bool? ?? true,
      showHindiPronunciation:
          map['showHindiPronunciation'] as bool? ?? false,
      showMarathiPronunciation:
          map['showMarathiPronunciation'] as bool? ?? false,
      backgroundMusic: map['backgroundMusic'] as bool? ?? false,
      tileSize: map['tileSize'] as String? ?? 'medium',
      autoPlaySpeed: (map['autoPlaySpeed'] as num?)?.toDouble() ?? 3.0,
      parentalPin: map['parentalPin'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'soundVolume': soundVolume,
        'showExampleWords': showExampleWords,
        'showImages': showImages,
        'showHindiPronunciation': showHindiPronunciation,
        'showMarathiPronunciation': showMarathiPronunciation,
        'backgroundMusic': backgroundMusic,
        'tileSize': tileSize,
        'autoPlaySpeed': autoPlaySpeed,
        'parentalPin': parentalPin,
      };
}
