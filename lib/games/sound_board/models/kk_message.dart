enum KKMood { happy, excited, encouraging, thinking }

class KKMessage {
  final String text;
  final KKMood mood;

  const KKMessage({required this.text, this.mood = KKMood.happy});

  static KKMessage greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return const KKMessage(
          text: 'Good morning! Ready to discover sounds?',
          mood: KKMood.happy);
    } else if (hour < 17) {
      return const KKMessage(
          text: 'Good afternoon! Let\'s explore some sounds!',
          mood: KKMood.happy);
    } else {
      return const KKMessage(
          text: 'Good evening! Time for some sound fun!',
          mood: KKMood.happy);
    }
  }

  static KKMessage discovery(String phonogramText) => KKMessage(
      text: 'New sound collected! That\'s $phonogramText!',
      mood: KKMood.excited);

  static KKMessage wordBuilt(String word) => KKMessage(
      text: 'Great spelling! You built $word!', mood: KKMood.excited);

  static KKMessage bonusWord(String word, int tier) => KKMessage(
      text: 'Wow! $word is from Tier $tier! That\'s advanced!',
      mood: KKMood.excited);

  static KKMessage wordInvalid() => const KKMessage(
      text: 'Hmm, not quite. Try different sounds!',
      mood: KKMood.encouraging);

  static KKMessage tierUnlocked(int tier, String name) => KKMessage(
      text: 'TIER $tier UNLOCKED! $name — 500 new words!',
      mood: KKMood.excited);

  static KKMessage masteryAdvice(String phonogram, String advice) =>
      KKMessage(text: '$phonogram: $advice', mood: KKMood.thinking);

  static KKMessage suggestPhonogram(String text) => KKMessage(
      text: 'Try tapping $text — you haven\'t heard this one yet!',
      mood: KKMood.encouraging);
}
