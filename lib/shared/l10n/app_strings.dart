import 'package:crack_the_code/shared/models/player_profile.dart';

class AppStrings {
  final AppLanguage _lang;
  AppStrings(this._lang);

  String _get(Map<String, String> map) => map[_lang.name] ?? map['en'] ?? '';

  // Navigation
  String get tabHome => _get({'en': 'Home', 'hi': 'होम', 'mr': 'होम'});
  String get tabLearn => _get({'en': 'Learn', 'hi': 'सीखें', 'mr': 'शिका'});
  String get tabPractice => _get({'en': 'Practice', 'hi': 'अभ्यास', 'mr': 'सराव'});
  String get tabGames => _get({'en': 'Games', 'hi': 'खेल', 'mr': 'खेळ'});
  String get tabProgress => _get({'en': 'Progress', 'hi': 'प्रगति', 'mr': 'प्रगती'});

  // Home
  String greeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return _get({
        'en': 'Good morning, $name!',
        'hi': 'सुप्रभात, $name!',
        'mr': 'सुप्रभात, $name!',
      });
    } else if (hour < 17) {
      return _get({
        'en': 'Good afternoon, $name!',
        'hi': 'नमस्ते, $name!',
        'mr': 'नमस्कार, $name!',
      });
    }
    return _get({
      'en': 'Good evening, $name!',
      'hi': 'शुभ संध्या, $name!',
      'mr': 'शुभ संध्याकाळ, $name!',
    });
  }

  // Learn
  String get learnTheSounds => _get({
    'en': 'Learn the 74 Sounds',
    'hi': '74 आवाज़ सीखें',
    'mr': '74 आवाज शिका',
  });
  String get yourPhonogramJourney => _get({
    'en': 'Your phonogram journey',
    'hi': 'आपकी फोनोग्राम यात्रा',
    'mr': 'तुमचा फोनोग्राम प्रवास',
  });
  String get theCourse => _get({
    'en': 'The Course',
    'hi': 'कोर्स',
    'mr': 'कोर्स',
  });
  String get studyTools => _get({
    'en': 'Study Tools',
    'hi': 'अध्ययन उपकरण',
    'mr': 'अभ्यास साधने',
  });
  String get flashcards => _get({'en': 'Flashcards', 'hi': 'फ्लैशकार्ड', 'mr': 'फ्लॅशकार्ड'});
  String get quizzes => _get({'en': 'Quizzes', 'hi': 'क्विज़', 'mr': 'क्विझ'});
  String get mindMaps => _get({'en': 'Mind Maps', 'hi': 'माइंड मैप', 'mr': 'माइंड मॅप'});
  String get glossary => _get({'en': 'Glossary', 'hi': 'शब्दकोश', 'mr': 'शब्दकोश'});

  // Content formats
  String get kkAdventure => _get({
    'en': "KK's Adventure",
    'hi': 'KK का एडवेंचर',
    'mr': 'KK चे अॅडव्हेंचर',
  });
  String get audioLesson => _get({
    'en': 'Audio Lesson',
    'hi': 'ऑडियो पाठ',
    'mr': 'ऑडिओ पाठ',
  });
  String get videoGuide => _get({
    'en': 'Video Guide',
    'hi': 'वीडियो गाइड',
    'mr': 'व्हिडिओ मार्गदर्शक',
  });
  String get premium => _get({'en': 'Premium', 'hi': 'प्रीमियम', 'mr': 'प्रीमियम'});
  String get free => _get({'en': 'FREE', 'hi': 'मुफ़्त', 'mr': 'विनामूल्य'});

  // Practice
  String get spellingBee => _get({'en': 'Spelling Bee', 'hi': 'स्पेलिंग बी', 'mr': 'स्पेलिंग बी'});
  String get dictation => _get({'en': 'Dictation', 'hi': 'डिक्टेशन', 'mr': 'डिक्टेशन'});
  String get unscramble => _get({'en': 'Unscramble', 'hi': 'अनस्क्रैम्बल', 'mr': 'अनस्क्रॅम्बल'});
  String get wordMatch => _get({'en': 'Word Match', 'hi': 'वर्ड मैच', 'mr': 'वर्ड मॅच'});
  String get dailyChallenge => _get({
    'en': 'Daily Challenge',
    'hi': 'दैनिक चुनौती',
    'mr': 'दैनंदिन आव्हान',
  });

  // Games
  String get soundBoard => _get({'en': 'Sound Board', 'hi': 'साउंड बोर्ड', 'mr': 'साउंड बोर्ड'});
  String get comingSoon => _get({'en': 'Coming Soon', 'hi': 'जल्द आ रहा है', 'mr': 'लवकरच येत आहे'});
  String get physicalGames => _get({
    'en': 'My Physical Games',
    'hi': 'मेरे फिज़िकल गेम',
    'mr': 'माझे फिजिकल गेम',
  });
  String get howToPlay => _get({
    'en': 'How to Play',
    'hi': 'कैसे खेलें',
    'mr': 'कसे खेळायचे',
  });

  // Progress
  String get myProgress => _get({'en': 'My Progress', 'hi': 'मेरी प्रगति', 'mr': 'माझी प्रगती'});
  String get phonogramMastery => _get({
    'en': 'Phonogram Mastery',
    'hi': 'फोनोग्राम महारत',
    'mr': 'फोनोग्राम प्रभुत्व',
  });
  String get ruleMastery => _get({
    'en': 'Rule Mastery',
    'hi': 'नियम महारत',
    'mr': 'नियम प्रभुत्व',
  });
  String soundsDiscovered(int count, int total) => _get({
    'en': '$count / $total sounds discovered',
    'hi': '$count / $total आवाज़ खोजे',
    'mr': '$count / $total आवाज सापडले',
  });
  String get streakDays => _get({'en': 'day streak', 'hi': 'दिन की स्ट्रीक', 'mr': 'दिवसांची स्ट्रीक'});

  // Lessons
  String get lessonVowels => _get({'en': 'Vowels', 'hi': 'स्वर', 'mr': 'स्वर'});
  String get lessonConsonants => _get({'en': 'Consonants', 'hi': 'व्यंजन', 'mr': 'व्यंजन'});
  String get lessonConsonantTeams => _get({'en': 'Consonant Teams', 'hi': 'व्यंजन टीम', 'mr': 'व्यंजन टीम'});
  String get lessonVowelTeams => _get({'en': 'Vowel Teams', 'hi': 'स्वर टीम', 'mr': 'स्वर टीम'});
  String get lessonRControlled => _get({'en': 'R-Controlled', 'hi': 'R-नियंत्रित', 'mr': 'R-नियंत्रित'});
  String get lessonGHCombos => _get({'en': 'GH Combos', 'hi': 'GH कॉम्बो', 'mr': 'GH कॉम्बो'});
  String get lessonSpecial => _get({'en': 'Special', 'hi': 'विशेष', 'mr': 'विशेष'});

  // KK messages
  String get kkWelcome => _get({
    'en': "Hey! I'm KK! Let's crack the code!",
    'hi': "हाय! मैं KK हूँ! चलो कोड crack करते हैं!",
    'mr': "हाय! मी KK! चला कोड crack करूया!",
  });
  String kkDiscovery(String phonogram) => _get({
    'en': 'New sound collected! That\'s $phonogram!',
    'hi': 'नया आवाज़ मिला! ये है $phonogram!',
    'mr': 'नवीन आवाज सापडला! हा आहे $phonogram!',
  });
  String kkWordBuilt(String word) => _get({
    'en': 'Great spelling! You built $word!',
    'hi': 'शानदार! आपने $word बनाया!',
    'mr': 'छान! तुम्ही $word बनवले!',
  });
  String get kkTryAgain => _get({
    'en': 'Hmm, not quite. Try different sounds!',
    'hi': 'हम्म, बिल्कुल नहीं। अलग आवाज़ आज़माओ!',
    'mr': 'हम्म, नाही. वेगळे आवाज वापरा!',
  });
  String get kkEncourage => _get({
    'en': 'Keep going! You\'re doing great!',
    'hi': 'जारी रखो! बहुत अच्छा कर रहे हो!',
    'mr': 'चालू ठेवा! खूप छान करत आहात!',
  });
  String kkLessonComplete(int count) => _get({
    'en': 'You learned $count sounds! Amazing!',
    'hi': 'आपने $count आवाज़ सीखे! शानदार!',
    'mr': 'तुम्ही $count आवाज शिकलात! अप्रतिम!',
  });

  // Settings
  String get settings => _get({'en': 'Settings', 'hi': 'सेटिंग्स', 'mr': 'सेटिंग्ज'});
  String get appLanguage => _get({
    'en': 'App Language',
    'hi': 'ऐप की भाषा',
    'mr': 'अॅप भाषा',
  });
  String get forParents => _get({
    'en': 'For Parents',
    'hi': 'माता-पिता के लिए',
    'mr': 'पालकांसाठी',
  });
  String get forTeachers => _get({
    'en': 'For Teachers',
    'hi': 'शिक्षकों के लिए',
    'mr': 'शिक्षकांसाठी',
  });
}
