# REMAINING WORK — Implementation Prompts
## 6 items to complete the Crack the Code app

---

## PROMPT 1: DATA COMPLETION (50 characters + 34 phonograms + 9,333 words)

### Context
The app currently has 118/168 characters, 73/107 phonograms, 667/10,000 words. All 3 gaps need to be filled from REFERENCE_BOOKS data.

### What To Do

**Step 1: Generate 50 remaining characters**
Source: `/Users/apple/work/studymatterial/REFERENCE_BOOKS/CARDS/ALL_168_CHARACTER_NAMES.md`

Read the source file. Find all 168 character names. Compare against existing `assets/data/characters.json` (118 entries). Generate the missing 50 characters.

For each new character, create:
```json
{
  "id": "CHAR-XXX",
  "name": "CHARACTER_NAME",
  "phonogram": "phonogram_text",
  "sound": "/sound_notation/",
  "soundId": "sXX",
  "level": N,
  "levelColor": "green|blue|gold",
  "introduction": {
    "en": "I'm NAME! I make the /sound/ sound!",
    "hi": "मैं NAME हूँ! मैं /sound/ बोलता हूँ!",
    "mr": "मी NAME! मी /sound/ बोलतो!"
  },
  "easyWords": ["WORD1", "WORD2", ...8 words],
  "mediumWords": ["WORD1", "WORD2", ...5 words]
}
```

Every character MUST have 8 easyWords and 5 mediumWords. Use the phonogram's example words from `assets/data/phonograms.json`. If the phonogram doesn't exist yet (advanced L5), use the sound's words from `assets/data/sounds.json`.

**Step 2: Generate 34 advanced phonograms**
Source: `/Users/apple/work/studymatterial/REFERENCE_BOOKS/CONTENT/ALL_PHONOGRAMS_DETAILED.md`

Read the source file. Find the 33 advanced phonograms (Level 5). Add them to `assets/data/phonograms.json` following the existing format:
```json
{
  "id": "74",
  "text": "AE",
  "category": "special",
  "colorHex": "#FFD700",
  "sounds": [{
    "soundId": "74a",
    "phonogramId": "74",
    "notation": "/ā/",
    "audioFile": "phonograms/74a.ogg",
    "hindiText": "...",
    "marathiText": "...",
    "exampleWords": [{"word": "AERIAL", "emoji": "✈️", "audioFile": "words/aerial.ogg"}]
  }],
  "detailWords": ["AERIAL", "ALGAE", ...],
  "funFact": "...",
  "hindiText": "...",
  "marathiText": "..."
}
```

Phonogram IDs continue from 74 to 107. Each phonogram needs:
- All sound values with notation
- Hindi and Marathi pronunciation guides (NOT translations — show the SOUND)
- 6+ example words per sound
- Fun fact about the phonogram's origin

**Step 3: Expand words to 10,000**
This is the BIGGEST task. Use Python with these sources:

1. **Dolch Sight Words** (220 words) — Grade K-3 basics
2. **Fry 1000** — Most frequent English words
3. **Oxford 3000** — Core vocabulary
4. **COCA 5000** — Corpus of Contemporary American English top 5000
5. **Academic Word List** (570 words)

For each word, generate:
```json
{
  "word": "BEAUTIFUL",
  "tier": 3,
  "phonogramBreakdown": ["B", "EAU", "TI", "F", "UL"],
  "soundBreakdown": [],
  "ruleNumbers": [],
  "difficulty": 3,
  "frequency": 847,
  "gradeLevel": 4,
  "audioFile": "words/beautiful.ogg",
  "emoji": "",
  "partOfSpeech": "adjective",
  "meanings": {
    "en": {"starter": "Very nice to look at", "explorer": "Extremely pleasing to the senses"},
    "hi": {"starter": "बहुत सुंदर"},
    "mr": {"starter": "खूप सुंदर"}
  },
  "sentences": {
    "en": {"starter": "The garden is beautiful."}
  },
  "spellingNotes": {
    "en": {"starter": "EAU comes from French!"}
  }
}
```

**Tier assignment by frequency:**
- Tier 1 (rank 1-100): FREE level
- Tier 2 (rank 101-500): Level 1
- Tier 3 (rank 501-1000): Level 2
- Tier 4 (rank 1001-2000): Level 3
- Tier 5 (rank 2001-5000): Level 4
- Tier 6 (rank 5001-10000): Level 5

**IMPORTANT:** The phonogramBreakdown must be CORRECT. Use the digraph detection algorithm that checks for multi-letter phonograms (SH, TH, CH, etc.) before splitting into single letters. Priority: 4-letter → 3-letter → 2-letter → 1-letter.

**Meanings:** At minimum, provide English starter meaning. Hindi and Marathi meanings for Tier 1-3 words (top 1000). Meanings must be age-adaptive.

### Files to Modify
- `assets/data/characters.json` — add 50 characters
- `assets/data/phonograms.json` — add 34 phonograms
- `assets/data/words.json` — expand to 10,000

### How to Execute
Write a Python script `tools/complete_data.py` that:
1. Reads REFERENCE_BOOKS source files
2. Reads existing JSON files
3. Generates missing entries
4. Merges and saves

### Testing
- `characters.json` must have exactly 168 entries
- Every character must have 8+ easyWords
- `phonograms.json` must have 107 entries
- `words.json` must have 10,000+ entries
- All phonogramBreakdowns must use valid phonogram texts
- Run `flutter analyze` — zero errors

---

## PROMPT 2: DAILY DECODER GAME (Priority digital game — pure Flutter)

### Context
Daily Decoder is the #1 game to build next because:
- It's the daily engagement hook (like Wordle)
- It's pure Flutter (no Flame engine needed)
- It uses existing phonogram + word data
- It's FREE (drives daily active users)

### Game Design

**One puzzle per day, 3 rotating types:**

**Type A: Decode the Word (Phonogram Wordle)**
- Show: "This word has N phonograms" + N color-coded hints
- Phonogram keyboard (6 rows by category)
- Player selects phonograms, taps SUBMIT
- Feedback: Green = correct position, Yellow = right phonogram wrong position, Gray = not in word
- Max 6 guesses
- Scoring: 1 guess=100pts, 2=80, 3=60, 4=40, 5=25, 6=15

**Type B: Rule of the Day**
- Show a spelling rule with explanation
- 5 multiple-choice words, pick the one that does NOT follow the rule
- Scoring: Correct=50pts

**Type C: Sound Pair-Up**
- 12 phonogram tiles face-down
- Pairs: (phonogram text, sound notation) e.g., (SH, "/sh/")
- Flip tiles, match pairs — memory game
- Scoring: Pairs found / total × 50pts

**Rotation:** Day 1=A, Day 2=B, Day 3=C, Day 4=A, ...

### Screens
1. `DailyDecoderScreen` — Today's puzzle with timer
2. `TypeAScreen` — Phonogram Wordle
3. `TypeBScreen` — Rule quiz
4. `TypeCScreen` — Memory match
5. `DailyResultsScreen` — Score + streak

### File Structure
```
lib/games/daily_decoder/
  models/
    daily_puzzle.dart
    decoder_progress.dart
  providers/
    daily_decoder_providers.dart
  screens/
    daily_decoder_screen.dart
    type_a_wordle_screen.dart
    type_b_rule_screen.dart
    type_c_memory_screen.dart
    daily_results_screen.dart
```

### Key Algorithm: Seeded RNG
```dart
// Same puzzle for everyone on the same day
final seed = DateTime.now().toIso8601String().substring(0, 10).hashCode;
final random = Random(seed);
```

### Integration
- Wire from Games tab (replace "Coming Soon" for Daily Decoder)
- FREE for all users (1 puzzle/day)
- Feeds unified mastery tracking

---

## PROMPT 3: SOUND QUEST GAME (Biggest game — Flutter + Flame)

### Context
Sound Quest is the main adventure game. It has 7 worlds (one per phonogram category), 5 levels per phonogram, and boss battles.

### Game Design

**Structure:** 7 worlds × ~15 phonograms per world × 5 levels = ~525 levels

**5 Level Types per Phonogram:**
1. **Hear It** — Audio plays, pick correct phonogram from 4 options
2. **See It** — Word shown, identify which phonogram is used
3. **Build It** — Drag phonogram tiles to spell a word
4. **Decode It** — Phonogram sequence shown, type the word
5. **Boss Battle** — Timed quiz, Flame sprite animation (KK vs enemy)

**World Map:** Vertical scrollable, locked/unlocked worlds
**Stars:** 3 per level (correct first try, under 30s, no hints)
**Level gating:** Must complete Level 1 of phonogram before Level 2

### File Structure
```
lib/games/sound_quest/
  models/
    world.dart
    quest_level.dart
    quest_progress.dart
  providers/
    sound_quest_providers.dart
  screens/
    world_map_screen.dart
    level_selection_screen.dart
    hear_it_screen.dart
    see_it_screen.dart
    build_it_screen.dart
    decode_it_screen.dart
    boss_battle_screen.dart
    quest_results_screen.dart
  widgets/
    world_card.dart
    level_card.dart
    star_display.dart
```

### Prerequisite
- Add `flame: ^1.18.0` to pubspec.yaml
- Boss battle uses Flame for sprite animation (KK character running, dodging obstacles)
- All other levels are pure Flutter

### Level gating by app level
- Worlds 1-3: Level 1 🟢 (50 phonograms)
- Worlds 4-5: Level 2 🔵
- Worlds 6-7: Level 3 🟠

---

## PROMPT 4: EPISODE VIDEO/AUDIO PLAYBACK

### Context
The app has 28 episodes in `episodes_v2.json` but no URLs and no playback. Each episode should support 3 formats × 3 languages.

### What To Do

**Step 1: Add URL fields to episode data**
Each episode gets:
```json
{
  "audioLessonUrl": {
    "en": "https://r2.crackthecode.app/audio/ep03_en.mp3",
    "hi": "https://r2.crackthecode.app/audio/ep03_hi.mp3",
    "mr": "https://r2.crackthecode.app/audio/ep03_mr.mp3"
  },
  "videoGuideUrl": {
    "en": "https://youtube.com/watch?v=xxxxx",
    "hi": "https://youtube.com/watch?v=yyyyy",
    "mr": "https://youtube.com/watch?v=zzzzz"
  },
  "kkAdventureUrl": {
    "en": "https://r2.crackthecode.app/video/ep03_animated.mp4"
  }
}
```

For now, URLs are placeholder empty strings. When content is produced, just update the JSON — no code change needed.

**Step 2: Create EpisodePlayerScreen**
When URL is available: play audio via just_audio or open video via InAppWebView.
When URL is empty: show "This episode is being produced. Coming soon!"

**Step 3: Wire format buttons in EpisodeListScreen**
Currently buttons close the bottom sheet. Wire to EpisodePlayerScreen.

### Screens
```
lib/presentation/screens/learn/
  episode_player_screen.dart  — Audio/video player
```

### Audio Player
Use existing `just_audio` for audio episodes. For video, use `flutter_inappwebview` (already in pubspec) to open YouTube URLs.

---

## PROMPT 5: QR CAMERA SCANNER

### Context
Card scanner currently shows "QR Scanner coming soon" with manual text entry. Need real camera scanning.

### What To Do

**Step 1: Add mobile_scanner package**
```yaml
dependencies:
  mobile_scanner: ^5.0.0
```

**Step 2: Replace placeholder with real camera**
In `card_scanner_screen.dart`, replace the placeholder Container with:
```dart
MobileScanner(
  onDetect: (capture) {
    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final code = barcode.rawValue;
      if (code != null) {
        _lookupByCode(code);
        break;
      }
    }
  },
)
```

**Step 3: QR code format on physical cards**
Each card's QR encodes: `CTC:CHAR-001` (prefix + character ID)
Parse: strip "CTC:" prefix, look up character by ID.

**Step 4: Keep manual entry as fallback**
Some users may not have camera access. Keep the text field below the camera.

### Files to Modify
- `pubspec.yaml` — add mobile_scanner
- `lib/presentation/screens/scanner/card_scanner_screen.dart` — add camera

---

## PROMPT 6: REMAINING 5 GAMES (Rule Master, Word Crusher, Rule Runner, Classroom Arena)

### Build Order
1. **Rule Master** — Puzzle game, pure Flutter, uses existing rules data
2. **Word Crusher** — Match-3, needs Flame engine
3. **Rule Runner** — Endless runner, needs Flame engine
4. **Classroom Arena** — Multiplayer, needs WebSocket (most complex, build last)

### Rule Master (Next after Daily Decoder)

**Game Design:**
- 6 Wings (one per rule category)
- Each wing has levels (one per rule)
- Level types: multiple choice, fill blank, sort words, find exception, match rule
- Boss battle per wing

**File Structure:**
```
lib/games/rule_master/
  models/
    rule_master_progress.dart
    puzzle_level.dart
  providers/
    rule_master_providers.dart
  screens/
    wing_map_screen.dart
    puzzle_screen.dart
    boss_screen.dart
    results_screen.dart
```

### Word Crusher (Candy Crush + Phonograms)

**Game Design:**
- Grid of phonogram tiles (5×6)
- Swipe to spell words
- Valid word → tiles crush, gravity, refill
- Chain combos for multiplier
- 5 worlds × 10 levels

**Needs:** `flame: ^1.18.0` for tile physics

### Rule Runner (Endless Runner)

**Game Design:**
- KK runs automatically (3 lanes)
- Obstacles: choose correct spelling/rule
- Wrong = stumble, lose life
- Speed increases with distance
- Power-ups: shield, double points, slow-mo

**Needs:** `flame: ^1.18.0` for parallax scrolling

### Classroom Arena (Multiplayer Quiz)

**Game Design:**
- Teacher hosts on their phone (WebSocket server via dart:io)
- Students join with 6-digit code
- Kahoot-style: question on teacher screen, 4 colored buttons on student screens
- Up to 40 players

**Needs:** `web_socket_channel: ^3.0.0`, `dart:io` for local WiFi server

### Implementation Prompts for Each Game
Each game already has a detailed GDD at:
```
/Users/apple/work/studymatterial/DIGITAL_GAMES/implementation_prompts/
  02_GAME1_SOUND_QUEST.md
  03_GAME2_RULE_MASTER.md
  04_GAME3_WORD_CRUSHER.md
  05_GAME4_RULE_RUNNER.md
  06_GAME5_DAILY_DECODER.md
  07_GAME6_CLASSROOM_ARENA.md
```

These are 40-60KB each with EXACT specifications for every screen, algorithm, animation, and data model. Use them directly.

---

## EXECUTION ORDER

```
1. Data Completion (Prompt 1)     ← DO FIRST (everything depends on data)
   - 50 characters (2 hours)
   - 34 phonograms (2 hours)
   - 10,000 words (4 hours, mostly automated)

2. Daily Decoder (Prompt 2)       ← DO SECOND (daily engagement)
   - Pure Flutter, ~8 files
   - Estimated: 3-4 hours

3. Episode Player (Prompt 4)      ← DO THIRD (enables course content)
   - 1 new screen + wire existing
   - Estimated: 1-2 hours

4. QR Scanner (Prompt 5)          ← DO FOURTH (physical-digital bridge)
   - 1 package + modify 1 file
   - Estimated: 1 hour

5. Sound Quest (Prompt 3)         ← DO FIFTH (biggest game)
   - Flutter + Flame, ~15 files
   - Estimated: 6-8 hours

6. Remaining Games (Prompt 6)     ← DO LAST (can be parallel)
   - Rule Master: 4-6 hours
   - Word Crusher: 6-8 hours (Flame)
   - Rule Runner: 6-8 hours (Flame)
   - Classroom Arena: 8-10 hours (WebSocket)
```

**Total estimated: 40-50 hours of development**

---

## THE FINAL VISION

When all 6 prompts are complete:

```
✅ 168 characters in 5 levels
✅ 107 phonograms (74 basic + 33 advanced)
✅ 100 rules (38 core + 62 advanced)
✅ 10,000+ frequency-ranked words
✅ 7 digital games (Sound Board + Daily Decoder + Sound Quest + Rule Master + Word Crusher + Rule Runner + Classroom Arena)
✅ Physical card QR scanning
✅ Episode playback (3 formats × 3 languages)
✅ 7-day free trial
✅ 5-level progression
✅ Complete practice suite (Spelling Bee, Dictation, Unscramble, Word Match, 3 Quiz types)
✅ Progress dashboard with real mastery tracking
✅ Trilingual (EN/HI/MR)
✅ Configurable free/paid gating
✅ 403+ audio files
```

The app becomes the COMPLETE English spelling mastery platform — from a 3-year-old tapping their first sound to a 14-year-old mastering "onomatopoeia."
