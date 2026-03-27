# CRACK THE CODE — Complete App Redesign Plan
## From 73 phonograms → 45 sounds · 107 phonograms · 168 characters · 100 rules · 5 levels

---

## THE BIG PICTURE

The app transforms from a flat phonogram explorer into a **character collection game with 5-level progression**.

```
OLD APP:                          NEW APP:
┌──────────┐                     ┌──────────────────┐
│ 73 tiles │                     │ 45 sounds (FREE) │
│ flat grid│                     │       ↓           │
│ no levels│                     │ 168 characters    │
│ 38 rules │                     │ 5 colored levels  │
└──────────┘                     │ 100 rules         │
                                 │ 313 total cards   │
                                 │ Physical + Digital │
                                 └──────────────────┘
```

---

## PHASE 1: DATA FOUNDATION (Sprint 1)

### What Changes

| Data File | Old | New | Action |
|-----------|-----|-----|--------|
| `sounds.json` | Didn't exist | 45 sounds | CREATE |
| `phonograms.json` | 73 phonograms | 107 phonograms | REWRITE |
| `characters.json` | Didn't exist | 168 characters | CREATE |
| `rules.json` | 38 rules | 100 rules | REWRITE |
| `levels.json` | Didn't exist | 5 levels | CREATE |
| `words.json` | 240 words | 10,000+ words (frequency-ranked) | REWRITE |
| `content_config.json` | Basic gating | Level-based gating | UPDATE |

### New Data Models

```dart
// lib/shared/models/sound.dart — NEW
class Sound {
  final String id;           // "s01" through "s45"
  final String notation;     // "/b/", "/ā/", "/sh/"
  final String type;         // "consonant" or "vowel"
  final String subType;      // "short", "long", "diphthong", "r-controlled", "broad"
  final Map<String, String> name; // {"en": "Short A", "hi": "छोटा A", "mr": "छोटा A"}
  final List<String> phonogramIds;  // all phonograms that make this sound
  final List<ExampleWord> exampleWords;
  final int dayNumber;       // which free trial day (1-7) this sound is taught
}

// lib/shared/models/character.dart — NEW
class Character {
  final String id;           // "CHAR-001" through "CHAR-168"
  final String name;         // "ASH", "ACE", "BLITZ"
  final String phonogramId;  // which phonogram this character represents
  final String soundId;      // which sound this character makes
  final int level;           // 1-5
  final String levelColor;   // "green", "blue", "orange", "red", "gold"
  final String pronunciation;// "ash", "ayss", "blitz"
  final Map<String, String> soundEquivalent; // {"hi": "ऐ", "mr": "ॲ"}
  final String artPrompt;    // for character illustration generation
  final List<ExampleWord> exampleWords;
}

// lib/shared/models/level.dart — NEW
class Level {
  final int number;          // 1-5
  final String name;         // "Sound Master"
  final String color;        // "#4CAF50" (green)
  final String colorName;    // "green"
  final int stars;           // 1-5
  final int ageMin;
  final int ageMax;
  final int durationWeeks;
  final List<String> phonogramIds;  // phonograms unlocked at this level
  final List<int> ruleNumbers;      // rules unlocked at this level
  final List<String> characterIds;  // characters unlocked at this level
  final int totalCards;             // cumulative cards available
}

// Update existing models:
// phonogram.dart — add: level, characterIds
// spelling_rule.dart — add: level, reliability, exceptions, teachingTip
```

### Files to Create/Modify

| Action | File | Records |
|--------|------|:-------:|
| CREATE | `lib/shared/models/sound.dart` | 1 class |
| CREATE | `lib/shared/models/character.dart` | 1 class |
| CREATE | `lib/shared/models/level.dart` | 1 class |
| MODIFY | `lib/shared/models/phonogram.dart` | add level, characterIds |
| MODIFY | `lib/shared/models/spelling_rule.dart` | add level, reliability |
| CREATE | `assets/data/sounds.json` | 45 sounds |
| REWRITE | `assets/data/phonograms.json` | 107 phonograms |
| CREATE | `assets/data/characters.json` | 168 characters |
| REWRITE | `assets/data/rules.json` | 100 rules |
| CREATE | `assets/data/levels.json` | 5 levels |
| UPDATE | `assets/data/content_config.json` | level-based gating |
| CREATE | `lib/shared/repositories/sound_repository.dart` | 1 repo |
| CREATE | `lib/shared/repositories/character_repository.dart` | 1 repo |
| CREATE | `lib/shared/repositories/level_repository.dart` | 1 repo |
| UPDATE | `lib/shared/providers/core_providers.dart` | add new providers |

**Phase 1 Total: 15 file operations**

---

## PHASE 2: FREE TRIAL FLOW (7-Day Sound Learning)

### The Flow

```
Day 1                    Day 2                    Day 3
┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│ 10 Consonants│        │ 10 More      │        │ 5 Tricky +   │
│              │        │ Consonants   │        │ Review ALL 25 │
│ /b/ BLITZ    │        │ /p/ PIKE     │        │ /sh/ SHADOW  │
│ /d/ DUSK     │        │ /r/ RIFT     │        │ /ch/ CHIEF   │
│ /f/ FANG     │        │ /s/ SAGE     │        │ /th/ THANE   │
│ /g/ GRIP     │        │ /t/ TALON    │        │ /TH/ THISTLE │
│ /h/ HAWK     │        │ /v/ VIPER    │        │ /ng/ FANG-NG │
│ /j/ JAX      │        │ /w/ WREN     │        │              │
│ /k/ KRAIT    │        │ /y/ YETI     │        │ + Review all │
│ /l/ LYNX     │        │ /z/ ZEPHYR   │        │   25 sounds  │
│ /m/ MACE     │        │ /ks/ SPHINX  │        │              │
│ /n/ NEXUS    │        │ /kw/ QUAKE   │        │              │
└──────────────┘        └──────────────┘        └──────────────┘

Day 4                    Day 5                    Day 6
┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│ 7 Short      │        │ 6 Long       │        │ 7 Remaining  │
│ Vowels       │        │ Vowels       │        │ Vowels       │
│              │        │              │        │              │
│ /ă/ ASH      │        │ /ā/ ACE      │        │ /ow/ OWL     │
│ /ĕ/ ELF      │        │ /ē/ EDEN     │        │ /oy/ DECOY   │
│ /ĭ/ INK      │        │ /ī/ ICE      │        │ /ah/ ALMS    │
│ /ŏ/ OX       │        │ /ō/ ODIN     │        │ /ar/ SCAR    │
│ /ŭ/ OVEN     │        │ /oo/ LOOM    │        │ /or/ THORN   │
│ /ŏŏ/ BROOK   │        │ /ū/ FUSE     │        │ /er/ FERN    │
│ /ə/ RAVEN    │        │              │        │ /air/ GLARE  │
└──────────────┘        └──────────────┘        └──────────────┘

Day 7
┌──────────────────────────────────────┐
│          🎉 CELEBRATION! 🎉          │
│                                      │
│    You mastered ALL 45 SOUNDS!       │
│    ⭐ Sound Explorer Badge           │
│                                      │
│    Review all 45 sounds              │
│    Mini quiz (10 questions)          │
│    Certificate earned                │
│                                      │
│    Next: Level 1 (Phonograms!)      │
└──────────────────────────────────────┘
```

### Screen Design: Daily Sound Lesson

```
┌──────────────────────────────────────┐
│  ← Day 1: Consonant Sounds          │
│  ██████░░░░░░░░░░░░░ 3/10           │
│                                      │
│  ╭──╮ "Meet FANG! He makes          │
│  │KK│  the /f/ sound!"              │
│  ╰──╯                                │
│                                      │
│  ┌────────────────────────────────┐  │
│  │                                │  │
│  │    🐺 FANG                     │  │
│  │                                │  │
│  │    ╔═══════════╗               │  │
│  │    ║     F     ║  /f/          │  │
│  │    ╚═══════════╝               │  │
│  │                                │  │
│  │    "F always makes /f/"        │  │
│  │                                │  │
│  │    🐟 FISH   🦊 FOX   🔥 FIRE │  │  ← tap any = audio
│  │    🍎 FUN    🌺 FLOWER 🎯 FAST│  │
│  │                                │  │
│  │    🔊 Tap card to hear sound   │  │
│  └────────────────────────────────┘  │
│                                      │
│  Sound 3 of 10 today                 │
│                                      │
│  [Next Sound →]                      │
└──────────────────────────────────────┘
```

### Files to Create

| Action | File | Purpose |
|--------|------|---------|
| CREATE | `lib/presentation/screens/trial/free_trial_home.dart` | 7-day trial hub |
| CREATE | `lib/presentation/screens/trial/daily_sound_lesson.dart` | Daily sound learning screen |
| CREATE | `lib/presentation/screens/trial/sound_celebration.dart` | Day 7 celebration |
| CREATE | `lib/shared/providers/trial_provider.dart` | Trial day tracking |
| CREATE | `assets/data/trial_days.json` | Sound assignments per day |

**Phase 2 Total: 5 new files**

---

## PHASE 3: LEVEL-BASED HOME SCREEN

### Home Screen Layout

```
┌──────────────────────────────────────┐
│                                      │
│  🟢 LEVEL 1: Sound Master  ★        │  ← level banner (color changes)
│  Week 3 · Day 18                     │
│                                      │
│  ╭──╮ "Today we meet CHIEF!        │
│  │KK│  He makes the /ch/ sound."    │
│  ╰──╯                          🪙 85│
│                                      │
│  ┌─── TODAY'S CHARACTER ──────────┐  │
│  │  🃏 CHIEF                      │  │
│  │  Phonogram: CH · Sound: /ch/   │  │
│  │  Level 1 🟢 ★                  │  │
│  │  [▶ Meet CHIEF]               │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌─── YOUR COLLECTION ────────────┐  │
│  │  🟢 32/70  🔵 0/60  🟡 0/38   │  │
│  │  🟢🟢🟢🟢🟢🟢🟢🟢⚪⚪⚪⚪...   │  │
│  │  [Open Collection →]           │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌─── CONTINUE LESSON ────────────┐  │
│  │  🟢 Week 3: Consonant Teams    │  │
│  │  SH, CH, TH, CK, NG           │  │
│  │  ████████░░░ 60%               │  │
│  │  [Continue →]                  │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌── PRACTICE ──┐ ┌── GAMES ─────┐  │
│  │ 🐝 Spelling  │ │ 🔊 Sound    │  │
│  │    Bee       │ │    Board     │  │
│  └──────────────┘ └──────────────┘  │
│                                      │
│  ┌─── WATCH EPISODE ──────────────┐  │
│  │  🎧 ep03: Building Blocks      │  │
│  │  3 formats · 3 languages       │  │
│  │  [Watch →]                     │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌─── SCAN CARD ──────────────────┐  │
│  │  📱 Got physical cards?         │  │
│  │  Scan to collect characters!    │  │
│  │  [Open Scanner]                │  │
│  └────────────────────────────────┘  │
│                                      │
│  [🏠] [📖] [✏️] [🎮] [🏆]            │
└──────────────────────────────────────┘
```

### Files to Create/Modify

| Action | File | Purpose |
|--------|------|---------|
| REWRITE | `lib/games/sound_board/screens/sound_board_home.dart` | Level-based home |
| CREATE | `lib/shared/widgets/level_banner.dart` | Colored level bar |
| CREATE | `lib/shared/widgets/character_card.dart` | Character display card |
| CREATE | `lib/presentation/screens/collection/collection_screen.dart` | Character collection |
| CREATE | `lib/presentation/screens/collection/character_detail_screen.dart` | Individual character |
| MODIFY | `lib/games/sound_board/widgets/today_sound_card.dart` | → today_character_card |

**Phase 3 Total: 6 files**

---

## PHASE 4: CHARACTER COLLECTION SCREEN

### Design

```
┌──────────────────────────────────────┐
│  ← YOUR COLLECTION  32/168          │
│                                      │
│  [ALL] [🟢L1] [🔵L2] [🟠L3] [🔴L4] [🟡L5]│
│                                      │
│  ── 🟢 LEVEL 1: Sound Master ──     │
│  32 of 70 characters collected       │
│                                      │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │ASH │ │ACE │ │ALMS│ │BLITZ│      │
│  │ A  │ │ A  │ │ A  │ │ B  │      │
│  │/ă/ │ │/ā/ │ │/ah/│ │/b/ │      │
│  │ ✅ │ │ ✅ │ │ ✅ │ │ ✅ │      │
│  └────┘ └────┘ └────┘ └────┘       │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │CLAW│ │????│ │DUSK│ │ ?? │      │
│  │ C  │ │ C  │ │ D  │ │    │      │
│  │/k/ │ │/s/ │ │/d/ │ │    │      │
│  │ ✅ │ │ 🔒 │ │ ✅ │ │ 🔒 │      │
│  └────┘ └────┘ └────┘ └────┘       │
│  ...                                 │
│                                      │
│  ── 🔵 LEVEL 2: Pattern Spotter ──  │
│  🔒 Complete Level 1 to unlock       │
│                                      │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │ ?? │ │ ?? │ │ ?? │ │ ?? │      │
│  │    │ │    │ │    │ │    │      │
│  │ 🔒 │ │ 🔒 │ │ 🔒 │ │ 🔒 │      │
│  └────┘ └────┘ └────┘ └────┘       │
│                                      │
└──────────────────────────────────────┘
```

### Character Card Design (When Tapped)

```
┌──────────────────────────────────────┐
│  ←                         🟢 LVL 1 │
│                                      │
│  ┌────────────────────────────────┐  │
│  │                                │  │
│  │      🐺                        │  │  ← character art (placeholder)
│  │                                │  │
│  │      FANG                      │  │  ← character name
│  │                                │  │
│  │    ╔═══════════╗               │  │
│  │    ║     F     ║  → /f/        │  │  ← phonogram → sound
│  │    ╚═══════════╝               │  │
│  │                                │  │
│  │  "F always says /f/. One of    │  │  ← fun fact
│  │   the most reliable letters!"  │  │
│  │                                │  │
│  │  🔊 Tap to hear FANG speak     │  │
│  └────────────────────────────────┘  │
│                                      │
│  WORDS WITH /f/                      │
│  🐟 FISH    🦊 FOX    🔥 FIRE      │  ← tap = audio
│  🍟 FUN     💐 FLOWER  ⚡ FAST      │
│  🧊 LEAF    🏈 HALF   📞 PHONE     │
│                                      │
│  OTHER SPELLINGS OF /f/              │
│  F (FISH) · PH (PHONE) · GH (LAUGH) │  ← all characters for this sound
│                                      │
│  हिंदी: फ़ (जैसे फ़िश)          🔊   │
│  मराठी: फ (जसे फिश)            🔊   │
│                                      │
│  ╭──╮ "FANG is a strong letter!     │
│  │KK│  F is one of the easiest      │
│  ╰──╯  sounds to master!"           │
│                                      │
│  CHAR-011 · Level 1 🟢 ★            │
│                                      │
└──────────────────────────────────────┘
```

### Files to Create

| Action | File | Purpose |
|--------|------|---------|
| CREATE | `lib/presentation/screens/collection/collection_screen.dart` | Level-grouped collection |
| CREATE | `lib/presentation/screens/collection/character_detail_screen.dart` | Full character card |
| CREATE | `lib/shared/widgets/character_card_tile.dart` | Grid tile for collection |
| CREATE | `lib/shared/widgets/level_tab_bar.dart` | Level color filter tabs |

**Phase 4 Total: 4 files**

---

## PHASE 5: LEARN TAB REDESIGN (Level-Based)

### Design

```
┌──────────────────────────────────────┐
│  Learn                               │
│                                      │
│  ── 45 SOUNDS (FREE) ──────────     │
│  ✅ All 45 sounds mastered!          │
│     [Review sounds →]                │
│                                      │
│  ── 🟢 LEVEL 1: SOUND MASTER ──     │
│                                      │
│  Week 1: Single Vowels               │
│    ✅ Lesson 1.1: Short vowels (7)   │
│    ✅ Lesson 1.2: Long vowels (6)    │
│    ✅ Lesson 1.3: Other vowels (7)   │
│                                      │
│  Week 2-4: Single Consonants         │
│    ✅ Lesson 1.4: Easy consonants    │
│    ▶ Lesson 1.5: Tricky consonants   │  ← current
│    🔒 Lesson 1.6: C and G rules     │
│                                      │
│  Week 5-7: Consonant Teams           │
│    🔒 Lesson 1.7: SH, CH, TH, WH   │
│    🔒 Lesson 1.8: CK, NG, PH, WR   │
│                                      │
│  Week 8-9: First Rules               │
│    🔒 Lesson 1.9: Rules 1-8         │
│    🔒 Lesson 1.10: Rules 9-15       │
│    🔒 Level 1 Final Quiz            │
│                                      │
│  ── 🔵 LEVEL 2: PATTERN SPOTTER ──  │
│  🔒 Complete Level 1 to unlock       │
│                                      │
│  ── THE COURSE ────────────────      │
│  🎧 Audio Lessons · 📺 Video Guides │
│  🎬 KK's Adventures (Premium)        │
│  [Browse 26 episodes →]              │
│                                      │
│  ── STUDY TOOLS ───────────────      │
│  [📝 Flashcards] [📖 Glossary]      │
│  [🗺️ Mind Maps]                      │
│                                      │
└──────────────────────────────────────┘
```

### Files to Modify

| Action | File | Purpose |
|--------|------|---------|
| REWRITE | `lib/presentation/screens/learn/learn_hub_screen.dart` | Level-based lessons |
| REWRITE | `lib/presentation/screens/learn/lesson_screen.dart` | Character-based lessons |
| MODIFY | `assets/data/lessons/learn_the_sounds.json` | 7-day sound structure |
| CREATE | `assets/data/lessons/level_1_lessons.json` | L1 lesson plan |
| CREATE | `assets/data/lessons/level_2_lessons.json` | L2 lesson plan |
| CREATE | `assets/data/lessons/level_3_lessons.json` | L3 lesson plan |

**Phase 5 Total: 6 files**

---

## PHASE 6: SOUND BOARD REDESIGN (45 Sounds + Characters)

### Sound Board becomes a SOUND EXPLORER

Instead of 73 phonogram tiles, show 45 SOUND cards. Each sound card shows all the ways to spell it.

```
┌──────────────────────────────────────┐
│  ← SOUND EXPLORER                    │
│                                      │
│  [CONSONANTS] [VOWELS]               │
│                                      │
│  ── CONSONANT SOUNDS (25) ──        │
│                                      │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │  /b/ │ │  /d/ │ │  /f/ │        │
│  │BLITZ │ │DUSK  │ │FANG  │        │
│  │  🔊  │ │  🔊  │ │  🔊  │        │
│  │      │ │      │ │      │        │
│  │ B    │ │ D    │ │F, PH,│        │  ← shows ALL spellings
│  │      │ │      │ │GH    │        │
│  └──────┘ └──────┘ └──────┘        │
│                                      │
│  Tap /f/ card:                       │
│  ┌────────────────────────────────┐  │
│  │  /f/ — 3 ways to spell it:     │  │
│  │                                │  │
│  │  🐺 FANG (F)     → Level 1 🟢│  │
│  │  🐬 DOLPHIN (PH) → Level 1 🟢│  │
│  │  😂 LAUGH (GH)   → Level 5 🟡│  │
│  │                                │  │
│  │  Each character is tappable    │  │
│  │  → opens character detail card │  │
│  └────────────────────────────────┘  │
│                                      │
└──────────────────────────────────────┘
```

### Files to Modify

| Action | File | Purpose |
|--------|------|---------|
| REWRITE | `lib/games/sound_board/screens/full_collection_screen.dart` | Sound-based explorer |
| CREATE | `lib/games/sound_board/widgets/sound_card.dart` | Sound card widget |
| MODIFY | `lib/games/sound_board/providers/sound_board_providers.dart` | Sound-based providers |

**Phase 6 Total: 3 files**

---

## PHASE 7: PROGRESS DASHBOARD

### Design

```
┌──────────────────────────────────────┐
│  YOUR JOURNEY                        │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  🟢 Level 1   ████████░░ 78%  │  │  ← current level
│  │  🔵 Level 2   ░░░░░░░░░ 🔒    │  │
│  │  🟠 Level 3   ░░░░░░░░░ 🔒    │  │
│  │  🔴 Level 4   ░░░░░░░░░ 🔒    │  │
│  │  🟡 Level 5   ░░░░░░░░░ 🔒    │  │
│  └────────────────────────────────┘  │
│                                      │
│  MASTERY                             │
│  Sounds:     45/45  ✅               │
│  Phonograms: 35/107 ████░░░░░       │
│  Characters: 42/168 ██░░░░░░░       │
│  Rules:       8/100 █░░░░░░░░       │
│                                      │
│  🔥 Streak: 14 days                  │
│  ⭐ XP: 2,450 (Level 12)            │
│  🪙 Coins: 340                       │
│                                      │
│  ACHIEVEMENTS                        │
│  🏅 Sound Explorer (45/45)           │
│  🏅 First Character (ASH)            │
│  🔒 Phonogram Pro (50 phonograms)    │
│  🔒 Rule Scholar (38 core rules)     │
│  🔒 Card Collector (100 characters)  │
│  🔒 Legend (all 313 cards)           │
│                                      │
└──────────────────────────────────────┘
```

### Files to Create

| Action | File | Purpose |
|--------|------|---------|
| CREATE | `lib/presentation/screens/progress/progress_dashboard.dart` | Full progress screen |
| CREATE | `lib/presentation/screens/progress/widgets/level_journey.dart` | Level progress bars |
| CREATE | `lib/presentation/screens/progress/widgets/mastery_stats.dart` | Sound/phonogram/rule stats |
| CREATE | `lib/presentation/screens/progress/widgets/achievements_grid.dart` | Badge display |

**Phase 7 Total: 4 files**

---

## PHASE 8: PHYSICAL CARD SCANNER

### Flow

```
User taps "Scan Card" →

    ┌──────────────────────────────────────┐
    │                                      │
    │  📱 SCAN YOUR CARD                   │
    │                                      │
    │  ┌────────────────────────────────┐  │
    │  │                                │  │
    │  │    [Camera viewfinder]         │  │
    │  │    Point at QR code on card    │  │
    │  │                                │  │
    │  └────────────────────────────────┘  │
    │                                      │
    │  OR enter code: [CHAR-___]           │
    │                                      │
    └──────────────────────────────────────┘

Scan successful →

    ┌──────────────────────────────────────┐
    │                                      │
    │         🎉 NEW CHARACTER! 🎉         │
    │                                      │
    │  ┌────────────────────────────────┐  │
    │  │      CHIEF                     │  │
    │  │      CH → /ch/                 │  │
    │  │      Level 1 🟢 ★             │  │
    │  │                                │  │
    │  │      +10 coins! 🪙             │  │
    │  └────────────────────────────────┘  │
    │                                      │
    │  KK: "CHIEF joined your team!        │
    │   CH makes the /ch/ sound!"          │
    │                                      │
    │  [Add to Collection]                 │
    │                                      │
    └──────────────────────────────────────┘
```

### Files to Create

| Action | File | Purpose |
|--------|------|---------|
| CREATE | `lib/presentation/screens/scanner/card_scanner_screen.dart` | QR scanner |
| CREATE | `lib/presentation/screens/scanner/character_unlock_screen.dart` | Unlock celebration |
| CREATE | `lib/shared/providers/scanner_provider.dart` | Card code validation |

**Phase 8 Total: 3 files**

---

## PHASE 9: AUDIO GENERATION (New Characters)

Generate audio for all 168 character names + their sounds using edge-tts.

```
For each character:
  1. Character introduction: "I'm FANG! I make the /f/ sound!"
  2. Sound pronunciation: "/f/"
  3. Example words: "FISH, FOX, FIRE"
```

**Phase 9 Total: ~500 new audio files**

---

## PHASE 10: POLISH + LEVEL TRANSITIONS

### Level Completion Celebration

```
┌──────────────────────────────────────┐
│                                      │
│      🎉🎉🎉 LEVEL 1 COMPLETE! 🎉🎉🎉│
│                                      │
│      🟢 SOUND MASTER ★              │
│                                      │
│      50 phonograms learned           │
│      15 rules mastered               │
│      70 characters collected          │
│                                      │
│      🔵 LEVEL 2 UNLOCKED!           │
│      Pattern Spotter ★★             │
│                                      │
│      24 new phonograms               │
│      10 new rules                    │
│      60 new characters               │
│                                      │
│      KK: "Amazing! You're becoming   │
│       a Pattern Spotter!"            │
│                                      │
│      [Enter Level 2 🔵]             │
│                                      │
└──────────────────────────────────────┘
```

---

## COMPLETE FILE MANIFEST

### NEW Files to Create: 31

| # | Phase | File | Purpose |
|---|:-----:|------|---------|
| 1 | 1 | `lib/shared/models/sound.dart` | Sound model |
| 2 | 1 | `lib/shared/models/character.dart` | Character model |
| 3 | 1 | `lib/shared/models/level.dart` | Level model |
| 4 | 1 | `lib/shared/repositories/sound_repository.dart` | Sound repo |
| 5 | 1 | `lib/shared/repositories/character_repository.dart` | Character repo |
| 6 | 1 | `lib/shared/repositories/level_repository.dart` | Level repo |
| 7 | 1 | `assets/data/sounds.json` | 45 sounds |
| 8 | 1 | `assets/data/characters.json` | 168 characters |
| 9 | 1 | `assets/data/levels.json` | 5 levels |
| 10 | 2 | `lib/presentation/screens/trial/free_trial_home.dart` | 7-day trial hub |
| 11 | 2 | `lib/presentation/screens/trial/daily_sound_lesson.dart` | Daily sound lesson |
| 12 | 2 | `lib/presentation/screens/trial/sound_celebration.dart` | Day 7 celebration |
| 13 | 2 | `lib/shared/providers/trial_provider.dart` | Trial tracking |
| 14 | 2 | `assets/data/trial_days.json` | Sound-to-day assignments |
| 15 | 3 | `lib/shared/widgets/level_banner.dart` | Level color bar |
| 16 | 3 | `lib/shared/widgets/character_card.dart` | Character display |
| 17 | 4 | `lib/presentation/screens/collection/collection_screen.dart` | Character collection |
| 18 | 4 | `lib/presentation/screens/collection/character_detail_screen.dart` | Character detail |
| 19 | 4 | `lib/shared/widgets/character_card_tile.dart` | Collection grid tile |
| 20 | 4 | `lib/shared/widgets/level_tab_bar.dart` | Level filter tabs |
| 21 | 5 | `assets/data/lessons/level_1_lessons.json` | L1 lesson plan |
| 22 | 5 | `assets/data/lessons/level_2_lessons.json` | L2 lesson plan |
| 23 | 5 | `assets/data/lessons/level_3_lessons.json` | L3 lesson plan |
| 24 | 6 | `lib/games/sound_board/widgets/sound_card.dart` | Sound card widget |
| 25 | 7 | `lib/presentation/screens/progress/progress_dashboard.dart` | Progress screen |
| 26 | 7 | `lib/presentation/screens/progress/widgets/level_journey.dart` | Level bars |
| 27 | 7 | `lib/presentation/screens/progress/widgets/mastery_stats.dart` | Stats |
| 28 | 7 | `lib/presentation/screens/progress/widgets/achievements_grid.dart` | Badges |
| 29 | 8 | `lib/presentation/screens/scanner/card_scanner_screen.dart` | QR scanner |
| 30 | 8 | `lib/presentation/screens/scanner/character_unlock_screen.dart` | Unlock flow |
| 31 | 8 | `lib/shared/providers/scanner_provider.dart` | Scanner provider |

### Files to MODIFY: 12

| # | Phase | File | Changes |
|---|:-----:|------|---------|
| 1 | 1 | `lib/shared/models/phonogram.dart` | Add level, characterIds |
| 2 | 1 | `lib/shared/models/spelling_rule.dart` | Add level, reliability |
| 3 | 1 | `lib/shared/providers/core_providers.dart` | Add sound, character, level providers |
| 4 | 1 | `assets/data/phonograms.json` | Rewrite with 107 phonograms |
| 5 | 1 | `assets/data/rules.json` | Rewrite with 100 rules |
| 6 | 1 | `assets/data/content_config.json` | Level-based gating |
| 7 | 3 | `lib/games/sound_board/screens/sound_board_home.dart` | Level-based home |
| 8 | 5 | `lib/presentation/screens/learn/learn_hub_screen.dart` | Level-based lessons |
| 9 | 5 | `lib/presentation/screens/learn/lesson_screen.dart` | Character-based lessons |
| 10 | 5 | `assets/data/lessons/learn_the_sounds.json` | 7-day sound structure |
| 11 | 6 | `lib/games/sound_board/screens/full_collection_screen.dart` | Sound-based explorer |
| 12 | 6 | `lib/games/sound_board/providers/sound_board_providers.dart` | Sound-based providers |

### Data Files to CREATE/REWRITE: 8

| # | File | Records | Action |
|---|------|:-------:|--------|
| 1 | `assets/data/sounds.json` | 45 | CREATE |
| 2 | `assets/data/phonograms.json` | 107 | REWRITE |
| 3 | `assets/data/characters.json` | 168 | CREATE |
| 4 | `assets/data/rules.json` | 100 | REWRITE |
| 5 | `assets/data/levels.json` | 5 | CREATE |
| 6 | `assets/data/trial_days.json` | 7 | CREATE |
| 7-9 | `assets/data/lessons/level_*.json` | 3 files | CREATE |

---

## EXECUTION ORDER

```
Phase 1: Data Foundation ──────────────────── (MUST BE FIRST)
    ↓
Phase 2: Free Trial + Phase 3: Home ────────── (parallel)
    ↓
Phase 4: Collection + Phase 5: Learn ───────── (parallel)
    ↓
Phase 6: Sound Board ──────────────────────── (depends on Phase 1)
    ↓
Phase 7: Progress ─────────────────────────── (depends on Phase 4)
    ↓
Phase 8: Scanner ──────────────────────────── (independent)
    ↓
Phase 9: Audio ────────────────────────────── (independent)
    ↓
Phase 10: Polish ──────────────────────────── (last)
```

**Total: 43 new files + 12 modified = 55 file operations**
**Estimated: 5 phases can be parallelized → 3-4 days of focused development**

---

## THE CORE EXPERIENCE IN ONE SENTENCE

A child opens the app, learns 45 sounds in 7 free days, then collects 168 Pokemon-style characters — each representing a phonogram-sound pair — across 5 colored levels, while watching KK's animated adventures, playing 7 games, practicing spelling, and scanning physical cards to unlock characters in the digital collection.
