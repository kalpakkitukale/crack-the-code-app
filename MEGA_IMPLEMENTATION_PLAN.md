# CRACK THE CODE — MEGA IMPLEMENTATION PLAN
## From Current App → Complete 5-Level Character Collection Platform

**Date:** 2026-03-27
**Scope:** Complete app redesign in 12 phases
**Current State:** 73 phonograms, 38 rules, 240 words, 1 game
**Target State:** 45 sounds, 107 phonograms, 168 characters, 100 rules, 10,000+ words, 5 levels, 7 games

---

## WHAT EXISTS TODAY (Don't Delete — Upgrade)

| Component | Files | Status |
|-----------|:-----:|--------|
| Shared models | 11 | Upgrade (add Sound, Character, Level) |
| Shared providers | 5 | Upgrade (add level, character providers) |
| Shared repositories | 4 | Upgrade (add sound, character repos) |
| Shared services | 3 | Keep (audio, storage, trie work fine) |
| Sound Board game | 20 | Redesign (45 sounds + characters) |
| Presentation screens | 19 dirs | Modify (level-based navigation) |
| Study tools screens | 9 | Keep (just feed spelling data) |
| Spelling activities | 13 | Keep (wire to level-appropriate words) |
| Quiz system | 21 | Keep (add spelling quizzes) |
| JSON data | 5 files | Rewrite (new numbers) |
| Audio files | 403 | Keep + generate more |
| L10n strings | 1 | Expand |

---

## THE 12 PHASES

```
Phase 0:  DATA GENERATION ─────────────── (offline, scripts)
Phase 1:  DATA MODELS + REPOS ─────────── (code foundation)
Phase 2:  PROVIDERS + CORE LOGIC ──────── (state management)
Phase 3:  7-DAY FREE TRIAL ────────────── (first user experience)
Phase 4:  HOME SCREEN ─────────────────── (level-based daily hub)
Phase 5:  CHARACTER COLLECTION ─────────── (the "Pokemon" hook)
Phase 6:  LEARN TAB ───────────────────── (level-based lessons + course)
Phase 7:  SOUND EXPLORER ──────────────── (replaces old Sound Board)
Phase 8:  PRACTICE TAB ────────────────── (spelling activities + quizzes)
Phase 9:  PROGRESS DASHBOARD ──────────── (5-level journey)
Phase 10: PHYSICAL CARD SCANNER ────────── (digital-physical bridge)
Phase 11: AUDIO GENERATION ────────────── (168 characters + 10K words)
Phase 12: POLISH + LAUNCH PREP ─────────── (animations, haptics, testing)
```

---

## PHASE 0: DATA GENERATION (Offline — Python Scripts)

**Goal:** Generate all JSON data files from REFERENCE_BOOKS source files.

### Files to Generate

| # | Output File | Records | Source | Script |
|---|------------|:-------:|--------|--------|
| 1 | `assets/data/sounds.json` | 45 | `REFERENCE_BOOKS/CONTENT/ALL_SOUNDS_DETAILED.md` | `tools/generate_sounds.py` |
| 2 | `assets/data/phonograms_v2.json` | 107 | `REFERENCE_BOOKS/CONTENT/ALL_PHONOGRAMS_DETAILED.md` | `tools/generate_phonograms.py` |
| 3 | `assets/data/characters.json` | 168 | `REFERENCE_BOOKS/CARDS/ALL_168_CHARACTER_NAMES.md` | `tools/generate_characters.py` |
| 4 | `assets/data/rules_v2.json` | 100 | `REFERENCE_BOOKS/CONTENT/RULES_DETAILED/` | `tools/generate_rules.py` |
| 5 | `assets/data/levels.json` | 5 | `REFERENCE_BOOKS/LEVEL_SYSTEM_COMPLETE.md` | `tools/generate_levels.py` |
| 6 | `assets/data/words_v2.json` | 1000+ (start) | Fry 1000 + phonogram coverage | `tools/generate_words.py` |
| 7 | `assets/data/trial_days.json` | 7 | Manual mapping | Manual |
| 8 | `assets/data/episodes_v2.json` | 28 | Episode mapping + sound drills | Manual |

### Data Schemas

**sounds.json:**
```json
{
  "id": "s01",
  "notation": "/b/",
  "name": {"en": "B sound", "hi": "/ब/ ध्वनि", "mr": "/ब/ ध्वनी"},
  "type": "consonant",
  "subType": "stop",
  "phonogramIds": ["b"],
  "characterIds": ["CHAR-004"],
  "trialDay": 1,
  "mouthPosition": {"en": "Press lips together, then pop!", "hi": "होंठ बंद करो, फिर खोलो!", "mr": "ओठ बंद करा, मग उघडा!"},
  "exampleWords": [
    {"word": "BIG", "emoji": "🐘"},
    {"word": "BAT", "emoji": "🦇"},
    {"word": "BUS", "emoji": "🚌"}
  ]
}
```

**characters.json:**
```json
{
  "id": "CHAR-004",
  "name": "BLITZ",
  "phonogramId": "b",
  "phonogramText": "B",
  "soundId": "s01",
  "soundNotation": "/b/",
  "level": 1,
  "levelColor": "green",
  "pronunciation": "blitz",
  "soundEquivalent": {"hi": "ब (जैसे बैट)", "mr": "ब (जसे बॅट)"},
  "introduction": {"en": "I'm BLITZ! I make the /b/ sound!", "hi": "मैं BLITZ हूँ! मैं /b/ बोलता हूँ!", "mr": "मी BLITZ! मी /b/ बोलतो!"},
  "easyWords": ["BIG", "BAT", "BUS", "BED", "BOX", "BALL", "BIRD", "BOOK"],
  "mediumWords": ["BASKET", "BRIDGE", "BROTHER", "BIRTHDAY", "BEAUTIFUL"],
  "hardWords": ["BUREAUCRACY", "BIBLIOGRAPHY", "BENEVOLENT"],
  "artPrompt": "A lightning-fast blue creature with sparks around it"
}
```

**levels.json:**
```json
{
  "number": 1,
  "name": {"en": "Sound Master", "hi": "साउंड मास्टर", "mr": "साउंड मास्टर"},
  "color": "#4CAF50",
  "colorName": "green",
  "stars": 1,
  "ageMin": 3,
  "ageMax": 7,
  "durationWeeks": 9,
  "phonogramIds": ["a","b","c",...],
  "ruleNumbers": [1,2,3,...,15],
  "characterIds": ["CHAR-001",...,"CHAR-070"],
  "totalCards": 130,
  "episodeIds": ["ep02a","ep02b","ep03","ep03a","ep03b","ep04","ep05"]
}
```

**trial_days.json:**
```json
[
  {"day": 1, "title": {"en": "Consonant Sounds 1"}, "soundIds": ["s01","s04","s06","s07","s08","s10","s11","s12","s13","s14"]},
  {"day": 2, "title": {"en": "Consonant Sounds 2"}, "soundIds": ["s16","s18","s19","s20","s22","s23","s25","s26","s09","s17"]},
  {"day": 3, "title": {"en": "Tricky Consonants + Review"}, "soundIds": ["s21","s03","s24","s05","s15"]},
  {"day": 4, "title": {"en": "Short Vowels"}, "soundIds": ["s27","s28","s29","s30","s31","s32","s33"]},
  {"day": 5, "title": {"en": "Long Vowels"}, "soundIds": ["s34","s35","s36","s37","s38","s39"]},
  {"day": 6, "title": {"en": "Remaining Vowels"}, "soundIds": ["s40","s41","s42","s43","s44","s45","s46"]},
  {"day": 7, "title": {"en": "Celebration!"}, "soundIds": [], "isCelebration": true}
]
```

**episodes_v2.json (with sound drills):**
```json
[
  {"id": "ep00", "number": 0, "title": {"en": "The Hidden Code"}, "level": "free", "hasSoundDrill": false},
  {"id": "ep01", "number": 1, "title": {"en": "Why English Looks Impossible"}, "level": "free", "hasSoundDrill": false},
  {"id": "ep02", "number": 2, "title": {"en": "The 45 Sounds"}, "level": "free", "hasSoundDrill": true, "drillType": "overview"},
  {"id": "ep02a", "number": 3, "title": {"en": "Consonant Sound Drill"}, "level": "free", "hasSoundDrill": true, "drillType": "consonants", "soundIds": ["s01"..."s25"]},
  {"id": "ep02b", "number": 4, "title": {"en": "Vowel Sound Drill"}, "level": "free", "hasSoundDrill": true, "drillType": "vowels", "soundIds": ["s27"..."s45"]},
  {"id": "ep03", "number": 5, "title": {"en": "The Missing Toolkit"}, "level": 1},
  ...
]
```

### Execution

```bash
cd APP
python3 tools/generate_sounds.py      # → sounds.json (45 records)
python3 tools/generate_characters.py   # → characters.json (168 records)
python3 tools/generate_phonograms.py   # → phonograms_v2.json (107 records)
python3 tools/generate_rules.py        # → rules_v2.json (100 records)
python3 tools/generate_words.py        # → words_v2.json (1000+ records)
python3 tools/generate_levels.py       # → levels.json (5 records)
# Manual: trial_days.json, episodes_v2.json
```

**Phase 0 Output: 8 JSON files + 6 Python scripts**
**Dependencies: None (can run first)**

---

## PHASE 1: DATA MODELS + REPOSITORIES

**Goal:** Create new Dart models and repos for sounds, characters, levels.

### New Files to Create (8)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/shared/models/sound.dart` | 45 sounds model |
| 2 | `lib/shared/models/character.dart` | 168 characters model |
| 3 | `lib/shared/models/level.dart` | 5 levels model |
| 4 | `lib/shared/models/trial_day.dart` | 7-day trial structure |
| 5 | `lib/shared/repositories/sound_repository.dart` | Load + query sounds |
| 6 | `lib/shared/repositories/character_repository.dart` | Load + query characters |
| 7 | `lib/shared/repositories/level_repository.dart` | Load + query levels |
| 8 | `lib/shared/repositories/trial_repository.dart` | Load trial day data |

### Files to Modify (4)

| # | File | Changes |
|---|------|---------|
| 1 | `lib/shared/models/phonogram.dart` | Add `level`, `characterIds` fields |
| 2 | `lib/shared/models/spelling_rule.dart` | Add `level`, `reliability`, `teachingTip` fields |
| 3 | `lib/shared/models/player_profile.dart` | Add `currentLevel`, `trialDay`, `trialCompleted` fields |
| 4 | `pubspec.yaml` | Add new asset paths |

**Phase 1 Output: 12 file operations**
**Dependencies: Phase 0 (data files must exist)**
**Test: `flutter analyze` passes, repos load data correctly**

---

## PHASE 2: PROVIDERS + CORE LOGIC

**Goal:** Riverpod state management for levels, characters, trial, sounds.

### New Files (4)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/shared/providers/level_provider.dart` | Current level, level progression, level completion |
| 2 | `lib/shared/providers/character_provider.dart` | Character collection, unlock tracking, discovery |
| 3 | `lib/shared/providers/trial_provider.dart` | Trial day tracking, sound mastery per day, completion |
| 4 | `lib/shared/providers/sound_provider.dart` | 45 sounds, mastery per sound, day mapping |

### Files to Modify (3)

| # | File | Changes |
|---|------|---------|
| 1 | `lib/shared/providers/core_providers.dart` | Add sound, character, level, trial repository providers |
| 2 | `lib/shared/providers/content_gating_provider.dart` | Level-based gating instead of tier-based |
| 3 | `lib/shared/services/storage_service.dart` | Add Hive boxes for character_collection, trial_progress, level_progress |

### Files to Modify (1)

| # | File | Changes |
|---|------|---------|
| 1 | `lib/main_dev.dart` | Load new repositories at startup, register providers |

**Phase 2 Output: 8 file operations**
**Dependencies: Phase 1 (models + repos must exist)**
**Test: All providers load without errors, trial state persists across restarts**

---

## PHASE 3: 7-DAY FREE TRIAL FLOW

**Goal:** The first-time user experience. Learn 45 sounds in 7 days.

### New Files (5)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/presentation/screens/trial/trial_home_screen.dart` | 7-day overview, current day, progress |
| 2 | `lib/presentation/screens/trial/daily_sound_lesson_screen.dart` | Learn sounds for today (6-10 per day) |
| 3 | `lib/presentation/screens/trial/sound_drill_screen.dart` | Individual sound: hear, see character, words, repeat |
| 4 | `lib/presentation/screens/trial/trial_celebration_screen.dart` | Day 7: all 45 sounds mastered! |
| 5 | `lib/presentation/screens/trial/level_unlock_screen.dart` | "Unlock Level 1" with pricing |

### Screen Flow

```
App opens → check trialCompleted?
  NO → TrialHomeScreen
    → Day X lesson → DailySoundLessonScreen
      → For each sound: SoundDrillScreen
        ┌──────────────────────────────────────┐
        │  DAY 1: Consonant Sounds     3/10    │
        │  ████████░░░░░░░░░░                  │
        │                                      │
        │  ╭──╮ "Meet FANG! He makes /f/!"    │
        │  │KK│                                │
        │  ╰──╯                                │
        │                                      │
        │  ┌────────────────────────────────┐  │
        │  │                                │  │
        │  │     🐺 FANG                    │  │
        │  │     F → /f/                    │  │
        │  │     🟢 Level 1 ★              │  │
        │  │                                │  │
        │  │  "F always makes /f/"          │  │
        │  │                                │  │
        │  │  Mouth: Press lips to teeth,   │  │
        │  │  blow air through!             │  │
        │  │                                │  │
        │  │  🐟 FISH  🦊 FOX  🔥 FIRE     │  │
        │  │  🍟 FUN   💐 FLOWER ⚡ FAST    │  │
        │  │  🧊 LEAF  🏈 HALF  📞 PHONE   │  │
        │  │                                │  │
        │  │  Other spellings of /f/:       │  │
        │  │  F (most common)               │  │
        │  │  PH (Greek words)              │  │
        │  │  GH (after AU/OU: LAUGH)       │  │
        │  │                                │  │
        │  │  🔊 Tap card to hear           │  │
        │  └────────────────────────────────┘  │
        │                                      │
        │  हिंदी: फ़ (जैसे फ़िश)           🔊  │
        │  मराठी: फ (जसे फिश)             🔊  │
        │                                      │
        │  [Next Sound →]                      │
        └──────────────────────────────────────┘
      → After all day's sounds: mini review quiz
    → Day 7: TrialCelebrationScreen
      → "All 45 sounds mastered! 🎉"
      → LevelUnlockScreen (pricing, or continue free)
  YES → Normal home screen (SoundBoardHome with level)
```

**Phase 3 Output: 5 new screens**
**Dependencies: Phase 2 (trial provider must exist)**
**Test: Complete 7-day flow, verify 45 sounds marked as mastered**

---

## PHASE 4: HOME SCREEN REDESIGN

**Goal:** Level-based daily hub with character introductions.

### Files to Modify (3)

| # | File | Changes |
|---|------|---------|
| 1 | `lib/games/sound_board/screens/sound_board_home.dart` | Complete rewrite for level-based layout |
| 2 | `lib/games/sound_board/widgets/today_sound_card.dart` | → Rename to `today_character_card.dart` |
| 3 | `lib/games/sound_board/widgets/collection_overview_card.dart` | Show characters by level color |

### New Files (2)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/shared/widgets/level_banner.dart` | Colored banner: "🟢 Level 1: Sound Master ★" |
| 2 | `lib/shared/widgets/scan_card_button.dart` | "📱 Scan your physical card" entry point |

### Home Layout

```
┌──────────────────────────────────────┐
│  🟢 LEVEL 1: Sound Master    ★      │ ← LevelBanner (color from current level)
│  Week 3 · Day 18                     │
│                                      │
│  ╭──╮ "Today we meet CHIEF!"        │ ← KK + character intro
│  │KK│                          🪙 85│
│  ╰──╯                                │
│                                      │
│  ┌─── TODAY'S CHARACTER ──────────┐  │ ← TodayCharacterCard
│  │  🃏 CHIEF · CH → /ch/         │  │
│  │  Level 1 🟢 ★                 │  │
│  │  [▶ Meet CHIEF]              │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌─── CONTINUE LESSON ────────────┐  │ ← ContinueLessonCard
│  │  🟢 Week 3: Consonant Teams    │  │
│  │  ████████░░░ 60%               │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌─── YOUR COLLECTION ────────────┐  │ ← CollectionOverviewCard (level colors)
│  │  🟢 32/70  🔵 0/60  🟡 0/38   │  │
│  │  [Open Collection →]           │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌── PRACTICE ──┐ ┌── GAMES ─────┐  │
│  │ 🐝 Spelling  │ │ 🔊 Sound    │  │
│  │    Bee       │ │    Explorer  │  │
│  └──────────────┘ └──────────────┘  │
│                                      │
│  ┌─── WATCH EPISODE ──────────────┐  │
│  │  🎧 ep03: Building Blocks      │  │
│  │  3 formats · 3 languages       │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌─── SCAN CARD ──────────────────┐  │ ← ScanCardButton
│  │  📱 Got physical cards?         │  │
│  │  Scan to collect characters!    │  │
│  └────────────────────────────────┘  │
│                                      │
│  [🏠] [📖] [✏️] [🎮] [🏆]            │
└──────────────────────────────────────┘
```

**Phase 4 Output: 5 file operations**
**Dependencies: Phase 2 (level + character providers)**
**Test: Home shows correct level color, character of the day rotates**

---

## PHASE 5: CHARACTER COLLECTION SCREEN

**Goal:** Pokemon-style character collection grouped by level.

### New Files (4)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/presentation/screens/collection/collection_screen.dart` | Level-grouped character grid |
| 2 | `lib/presentation/screens/collection/character_detail_screen.dart` | Full character card with words |
| 3 | `lib/shared/widgets/character_card_tile.dart` | Grid tile (collected/mystery) |
| 4 | `lib/shared/widgets/level_tab_bar.dart` | [ALL] [🟢] [🔵] [🟠] [🔴] [🟡] tabs |

### Character Detail Screen

```
┌──────────────────────────────────────┐
│  ←                         🟢 LVL 1 │
│                                      │
│  ┌────────────────────────────────┐  │
│  │                                │  │
│  │      🐺 FANG                   │  │ ← character art (placeholder for now)
│  │                                │  │
│  │    ╔═══════════╗               │  │
│  │    ║     F     ║  → /f/        │  │ ← phonogram → sound mapping
│  │    ╚═══════════╝               │  │
│  │                                │  │
│  │  "F always says /f/. One of    │  │
│  │   the most reliable letters!"  │  │
│  │                                │  │
│  │  🔊 Tap to hear FANG speak     │  │
│  └────────────────────────────────┘  │
│                                      │
│  ── EASY WORDS ──                    │
│  🐟 FISH  🦊 FOX  🔥 FIRE  🍟 FUN  │
│  💐 FLOWER  ⚡ FAST  🎯 FIVE  🐸 FROG│
│                                      │
│  ── MORE WORDS ──                    │
│  FAMILY  FOREST  FINISH  FORGET     │
│  FOLLOW  FESTIVAL  FREEDOM          │
│                                      │
│  ── CHALLENGE WORDS ──               │
│  PHILOSOPHY  PHENOMENON  SUFFICIENT  │
│                                      │
│  ── OTHER SPELLINGS OF /f/ ──        │
│  🐬 DOLPHIN (PH)  😂 LAUGH (GH)    │
│                                      │
│  हिंदी: फ़ (जैसे फ़िश)          🔊   │
│  मराठी: फ (जसे फिश)             🔊   │
│                                      │
│  ╭──╮ "FANG is strong and reliable! │
│  │KK│  F almost always says /f/."   │
│  ╰──╯                                │
│                                      │
│  CHAR-011 · Level 1 🟢 ★            │
└──────────────────────────────────────┘
```

**Phase 5 Output: 4 new files**
**Dependencies: Phase 2 (character provider)**
**Test: Browse 168 characters, level-grouped, mystery tiles for locked levels**

---

## PHASE 6: LEARN TAB REDESIGN

**Goal:** Level-based lesson progression with sound drills + course episodes.

### Files to Modify (2)

| # | File | Changes |
|---|------|---------|
| 1 | `lib/presentation/screens/learn/learn_hub_screen.dart` | Level-based lesson groups instead of flat list |
| 2 | `lib/presentation/screens/learn/lesson_screen.dart` | Character-based lessons (show character with each phonogram) |

### New Files (4)

| # | File | Purpose |
|---|------|---------|
| 1 | `assets/data/lessons/level_1_lessons.json` | L1: 10 lessons covering 50 phonograms + 15 rules |
| 2 | `assets/data/lessons/level_2_lessons.json` | L2: 8 lessons covering 24 new phonograms + 10 rules |
| 3 | `assets/data/lessons/level_3_lessons.json` | L3: 6 lessons covering 13 rules |
| 4 | `lib/presentation/screens/learn/sound_drill_episode_screen.dart` | Watch sound drill episodes |

**Phase 6 Output: 6 file operations**
**Dependencies: Phase 2 + Phase 3 (level provider + trial must work)**

---

## PHASE 7: SOUND EXPLORER (Replaces Old Sound Board)

**Goal:** 45 sound cards instead of 73 phonogram tiles.

### Files to Modify (2)

| # | File | Changes |
|---|------|---------|
| 1 | `lib/games/sound_board/screens/full_collection_screen.dart` | → Sound-based grid showing 45 sounds |
| 2 | `lib/games/sound_board/providers/sound_board_providers.dart` | Sound-based mastery + character collection |

### New Files (1)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/games/sound_board/widgets/sound_card_widget.dart` | Sound card: shows sound + all spellings + characters |

### Sound Explorer Design

```
┌──────────────────────────────────────┐
│  ← SOUND EXPLORER                    │
│                                      │
│  [ALL] [CONSONANTS] [VOWELS]         │
│                                      │
│  ── CONSONANT SOUNDS (25) ──         │
│                                      │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │  /b/ │ │  /d/ │ │  /f/ │        │
│  │BLITZ │ │DUSK  │ │FANG  │        │
│  │  B   │ │  D   │ │F,PH, │        │
│  │  🔊  │ │  🔊  │ │GH 🔊│        │
│  └──────┘ └──────┘ └──────┘        │
│                                      │
│  Tap /f/:                            │
│  ┌────────────────────────────────┐  │
│  │  /f/ — 3 ways to spell:        │  │
│  │  🐺 FANG (F)      🟢 Level 1  │  │
│  │  🐬 DOLPHIN (PH)  🟢 Level 1  │  │
│  │  😂 LAUGH (GH)    🟡 Level 5  │  │
│  │                                │  │
│  │  9 easy · 7 medium · 4 hard    │  │
│  │  [See all 20 words →]          │  │
│  └────────────────────────────────┘  │
│                                      │
│  ── VOWEL SOUNDS (20) ──             │
│  ┌──────┐ ┌──────┐ ┌──────┐        │
│  │ /ă/  │ │ /ĕ/  │ │ /ĭ/  │        │
│  │ ASH  │ │ ELF  │ │ INK  │        │
│  │A     │ │E     │ │I     │        │
│  └──────┘ └──────┘ └──────┘        │
│  ...                                 │
└──────────────────────────────────────┘
```

**Phase 7 Output: 3 file operations**
**Dependencies: Phase 1 + 2 (sound model + provider)**

---

## PHASE 8: PRACTICE TAB INTEGRATION

**Goal:** All activities use level-appropriate frequency-ranked words.

### Files to Modify (1)

| # | File | Changes |
|---|------|---------|
| 1 | `lib/presentation/screens/practice/practice_hub_screen.dart` | Show activities filtered by current level's word list |

### Logic Change

```dart
// Current: hardcoded wordListId: 'grade_1'
// New: dynamically select based on current level
final currentLevel = ref.watch(levelProvider).currentLevel;
final wordListId = 'level_${currentLevel.number}';

// Spelling Bee: only uses words from current level (frequency-ranked)
// Dictation: same
// Unscramble: same
// Word Match: same
```

**Phase 8 Output: 1 file modified**
**Dependencies: Phase 2 (level provider)**

---

## PHASE 9: PROGRESS DASHBOARD

**Goal:** 5-level journey visualization with mastery stats.

### New Files (4)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/presentation/screens/progress/progress_dashboard.dart` | Full progress screen |
| 2 | `lib/presentation/screens/progress/widgets/level_journey.dart` | 5-level colored progress bars |
| 3 | `lib/presentation/screens/progress/widgets/mastery_stats.dart` | Sounds/phonograms/characters/rules counts |
| 4 | `lib/presentation/screens/progress/widgets/achievements_grid.dart` | Badge collection |

### Progress Design

```
┌──────────────────────────────────────┐
│  YOUR JOURNEY                        │
│                                      │
│  🟢 Level 1  ████████████░░ 78%     │
│     Sound Master ★                   │
│     50 phonograms · 15 rules         │
│     32/70 characters collected        │
│                                      │
│  🔵 Level 2  ░░░░░░░░░░░░░ 🔒       │
│     Pattern Spotter ★★               │
│                                      │
│  🟠🔴🟡 Levels 3-5  🔒🔒🔒          │
│                                      │
│  ─── MASTERY ───                     │
│  Sounds:     45/45  ████████████ ✅  │
│  Phonograms: 35/107 ████░░░░░░░     │
│  Characters: 42/168 ██░░░░░░░░░     │
│  Rules:       8/100 █░░░░░░░░░░     │
│  Words:     287/10K ██░░░░░░░░░     │
│                                      │
│  ─── STATS ───                       │
│  🔥 14 day streak                    │
│  ⭐ 2,450 XP (Level 12)             │
│  🪙 340 coins                        │
│  📚 Top 500 words mastered           │
│     = 75% reading coverage!          │
│                                      │
│  ─── ACHIEVEMENTS ───                │
│  🏅 Sound Explorer (45/45)           │
│  🏅 First Character (ASH)            │
│  🔒 Collector 50 (50 characters)     │
│  🔒 Rule Scholar (38 core rules)     │
│  🔒 Word Master (1000 words)         │
│  🔒 Legend (all 313 cards)           │
└──────────────────────────────────────┘
```

**Phase 9 Output: 4 new files**
**Dependencies: Phase 2 (all providers)**

---

## PHASE 10: PHYSICAL CARD SCANNER

**Goal:** Scan QR on physical card → unlock character in app.

### New Files (3)

| # | File | Purpose |
|---|------|---------|
| 1 | `lib/presentation/screens/scanner/card_scanner_screen.dart` | Camera QR scanner + manual code entry |
| 2 | `lib/presentation/screens/scanner/character_unlock_screen.dart` | Celebration when character unlocked |
| 3 | `lib/shared/providers/scanner_provider.dart` | Validate card code, unlock character |

### Dependencies

Add to pubspec.yaml:
```yaml
mobile_scanner: ^5.0.0  # QR code scanning
```

**Phase 10 Output: 3 new files + 1 dependency**
**Dependencies: Phase 5 (character collection must exist)**

---

## PHASE 10A: VIDEO COURSE INTEGRATION

**Goal:** 28 episodes in 3 formats × 3 languages, level-grouped, with sound drills.

### How the Video Course Works

```
Each episode has 3 formats:
  🎬 KK's Adventure    → Premium animated (Flow/Veo 3)
  🎧 Audio Lesson      → FREE podcast-style (NLM audio)
  📺 Video Guide       → FREE presentation (NLM video)

Each format in 3 languages:
  [English] [हिंदी] [मराठी]

Total: 28 episodes × 3 formats × 3 languages = 252 content URLs
```

### Episode Screen Design

```
┌──────────────────────────────────────┐
│  ← ep05: When Letters Change         │
│  🟢 Level 1 · Rules 1-4             │
│                                      │
│  ┌─── WATCH ───────────────────────┐ │
│  │                                  │ │
│  │  🎬 KK's Adventure       👑     │ │
│  │     12 min · Premium animated    │ │
│  │                                  │ │
│  │  🎧 Audio Lesson         FREE   │ │
│  │     15 min · Like a podcast      │ │
│  │                                  │ │
│  │  📺 Video Guide          FREE   │ │
│  │     15 min · Visual guide        │ │
│  │                                  │ │
│  │  🌐 [English] [हिंदी] [मराठी]    │ │
│  └──────────────────────────────────┘ │
│                                      │
│  SOUND DRILL (if episode has one):   │
│  ┌──────────────────────────────────┐│
│  │  Practice the sounds from this   ││
│  │  episode with interactive drill   ││
│  │  [▶ Start Sound Drill]          ││
│  └──────────────────────────────────┘│
│                                      │
│  AFTER WATCHING:                     │
│  ✅ Flashcards for Rules 1-4        │
│  ✅ Quiz: Test Rules 1-4            │
│  ✅ Related characters unlocked     │
│                                      │
└──────────────────────────────────────┘
```

### Files

| # | Action | File | Purpose |
|---|--------|------|---------|
| 1 | MODIFY | `lib/presentation/screens/learn/episode_list_screen.dart` | Level-grouped episodes with sound drill badges |
| 2 | CREATE | `lib/presentation/screens/learn/episode_detail_screen.dart` | 3-format × 3-language player + sound drill link |
| 3 | CREATE | `lib/presentation/screens/learn/sound_drill_episode_screen.dart` | Interactive sound drill linked from episode |
| 4 | MODIFY | `assets/data/episodes/video_course.json` | Add level, soundDrill, format URLs per language |

**Phase 10A Output: 4 files**

---

## PHASE 10B: FLASHCARD SYSTEM (Character + Sound + Rule Decks)

**Goal:** 168 character cards + 45 sound cards + 100 rule cards, level-grouped with spaced repetition.

### Flashcard Deck Types

| Deck | Cards | Front | Back |
|------|:-----:|-------|------|
| **Character Cards** | 168 | Character name + art | Phonogram → Sound + 6 words |
| **Sound Cards** | 45 | Sound notation /f/ | All phonograms that spell it + words |
| **Rule Cards** | 100 | Rule number + title | Full explanation + examples + exceptions |
| **Word Cards** | 1000+ | Word + emoji | Phonogram breakdown + meaning + spelling note |

### Flashcard Design

```
CHARACTER FLASHCARD:

FRONT:                          BACK:
┌──────────────────┐           ┌──────────────────┐
│                  │           │                  │
│    🐺 FANG       │           │  F → /f/         │
│                  │           │                  │
│    🟢 Level 1    │           │  "F always       │
│                  │           │   says /f/"      │
│                  │           │                  │
│  Tap to flip     │           │  🐟 FISH         │
│                  │           │  🦊 FOX          │
│                  │           │  🔥 FIRE         │
│                  │           │  🍟 FUN          │
│                  │           │  💐 FLOWER       │
│                  │           │  ⚡ FAST         │
│                  │           │                  │
│                  │           │  Other: PH, GH   │
└──────────────────┘           └──────────────────┘

SOUND FLASHCARD:

FRONT:                          BACK:
┌──────────────────┐           ┌──────────────────┐
│                  │           │  3 ways to        │
│     /f/          │           │  spell /f/:       │
│                  │           │                  │
│  How do you      │           │  F  → FISH 🐟   │
│  spell this      │           │  PH → PHONE 📞  │
│  sound?          │           │  GH → LAUGH 😂  │
│                  │           │                  │
│  Tap to flip     │           │  F is most       │
│                  │           │  common (90%)    │
└──────────────────┘           └──────────────────┘

RULE FLASHCARD:

FRONT:                          BACK:
┌──────────────────┐           ┌──────────────────┐
│                  │           │  C says /s/       │
│  Rule 1          │           │  before E, I, Y   │
│                  │           │                  │
│  When does C     │           │  ✅ CITY, ICE,   │
│  say /s/?        │           │  PENCIL, CEILING │
│                  │           │                  │
│  Tap to flip     │           │  100% reliable!  │
│                  │           │  No exceptions.  │
│                  │           │                  │
│                  │           │  Compare:        │
│                  │           │  CAT (before A)  │
│                  │           │  = /k/ sound     │
└──────────────────┘           └──────────────────┘
```

### How Flashcards Connect to Levels

```
Level 1 🟢: 70 character cards + 15 rule cards + 45 sound cards = 130 flashcards
Level 2 🔵: +60 character cards + 10 rule cards = 70 new flashcards
Level 3 🟠: +13 rule cards = 13 new flashcards
Level 4 🔴: +42 rule cards = 42 new flashcards
Level 5 🟡: +38 character cards + 20 rule cards = 58 new flashcards

Total: 313 flashcards = exactly matches the 313-card physical set!
```

### Spaced Repetition Integration

```
Existing FlashcardStudyScreen already has:
  - Card flip animation
  - "Again / Hard / Good / Easy" rating buttons
  - Spaced repetition algorithm
  - Due card tracking

We just need to feed it CHARACTER/SOUND/RULE card data
instead of NCERT chapter data. The screen works as-is!
```

### Files

| # | Action | File | Purpose |
|---|--------|------|---------|
| 1 | CREATE | `assets/data/study_tools/flashcards/spelling_characters_flashcards.json` | 168 character cards grouped by level |
| 2 | CREATE | `assets/data/study_tools/flashcards/spelling_sounds_flashcards.json` | 45 sound cards |
| 3 | UPDATE | `assets/data/study_tools/flashcards/spelling_rules_flashcards.json` | Expand from 38 → 100 rules |
| 4 | UPDATE | `assets/data/study_tools/flashcards/spelling_words_flashcards.json` | Expand from 110 → 1000+ word cards |
| 5 | MODIFY | `lib/presentation/screens/learn/learn_hub_screen.dart` | Wire flashcard button to character deck |

**Phase 10B Output: 5 files**
**Dependencies: Phase 0 (data), uses existing FlashcardStudyScreen as-is**

---

## PHASE 10C: MIND MAP SYSTEM (Phonogram Family Trees by Level)

**Goal:** Visual maps showing how sounds connect to phonograms, organized by level.

### Mind Map Types

| Map | Nodes | What It Shows |
|-----|:-----:|--------------|
| **Sound → Spelling Map** | ~200 | Each sound branches to all phonograms that spell it |
| **Level 1 Phonogram Tree** | ~80 | All 50 Level 1 phonograms with characters |
| **Level 2 Addition Tree** | ~50 | 24 new phonograms added at Level 2 |
| **Rule Category Map** | ~110 | 6 rule categories → individual rules |
| **Word Family Map** | ~150 | Common word families (-at, -an, -ig, -op, etc.) |

### Mind Map Design

```
Sound → Spelling Map for /f/:

                    ┌─ FISH 🐟
            ┌── F ──┤
            │       └─ FOX 🦊
            │
   /f/ ─────┤       ┌─ PHONE 📞
            ├── PH ─┤
            │       └─ DOLPHIN 🐬
            │
            │       ┌─ LAUGH 😂
            └── GH ─┤
                    └─ COUGH 😷

Each node:
  - Tappable → plays audio
  - Shows level color (🟢/🔵/🟡)
  - Character avatar on phonogram nodes
```

### Files

| # | Action | File | Purpose |
|---|--------|------|---------|
| 1 | CREATE | `assets/data/study_tools/mind_maps/spelling_sound_spelling_map.json` | Sound → all spellings |
| 2 | UPDATE | `assets/data/study_tools/mind_maps/spelling_phonogram_families_mindmap.json` | Update to 107 phonograms with levels |
| 3 | UPDATE | `assets/data/study_tools/mind_maps/spelling_rules_overview_mindmap.json` | Update to 100 rules |
| 4 | CREATE | `assets/data/study_tools/mind_maps/spelling_word_families_mindmap.json` | Word family trees |
| 5 | MODIFY | `lib/presentation/screens/learn/learn_hub_screen.dart` | Wire mind map button |

**Phase 10C Output: 5 files**
**Dependencies: Phase 0 (data), uses existing MindMapScreen as-is**

---

## PHASE 10D: QUIZ SYSTEM (Level-Appropriate Spelling Quizzes)

**Goal:** Dynamic quizzes generated from phonogram, rule, and word data.

### Quiz Types

| Type | Question | Answer Options | Level |
|------|----------|---------------|:-----:|
| **Sound Recognition** | "Which sound does SH make?" (plays audio) | 4 sound options | All |
| **Phonogram Identification** | "Which phonogram spells /f/ in PHONE?" | PH, SH, TH, GH | L1+ |
| **Rule Application** | "C says /s/ before which letters?" | E,I,Y / A,O,U / B,D,G / All | L1+ |
| **Word Spelling** | "Spell: [plays BEAUTIFUL]" | Type answer | L2+ |
| **Character Match** | "Which character makes /sh/?" | SHADOW, FANG, BLITZ, ACE | All |
| **Exception Finder** | "Which word BREAKS Rule 2?" | GET, GEM, GIANT, GENTLE | L3+ |
| **Fill Blank** | "___ I P (it's a boat)" | SH | All |
| **Word Origin** | "PHONE comes from which language?" | Greek, Latin, French, German | L4+ |

### Quiz Screen Design

```
┌──────────────────────────────────────┐
│  ← Rule Quiz · Question 4/10        │
│  ████████░░░░░░░░                    │
│                                      │
│  Rule 1:                             │
│  C says /s/ before...                │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  A)  A, O, U                  │  │
│  └────────────────────────────────┘  │
│  ┌────────────────────────────────┐  │
│  │  B)  E, I, Y    ✅ CORRECT!  │  │  ← green highlight
│  └────────────────────────────────┘  │
│  ┌────────────────────────────────┐  │
│  │  C)  B, D, G                  │  │
│  └────────────────────────────────┘  │
│  ┌────────────────────────────────┐  │
│  │  D)  All consonants           │  │
│  └────────────────────────────────┘  │
│                                      │
│  KK: "Right! 100% reliable rule!"    │
│  Examples: CITY, ICE, PENCIL         │
│                                      │
│  +10 XP · +5 coins                   │
│                                      │
│  [Next Question →]                   │
└──────────────────────────────────────┘
```

### Files

| # | Action | File | Purpose |
|---|--------|------|---------|
| 1 | CREATE | `lib/shared/providers/spelling_quiz_provider.dart` | Generate quiz questions dynamically from repos |
| 2 | CREATE | `lib/presentation/screens/quiz/spelling_quiz_screen.dart` | Quiz taking screen for spelling |
| 3 | CREATE | `lib/presentation/screens/quiz/quiz_results_screen.dart` | Results with mastery update |
| 4 | MODIFY | `lib/presentation/screens/practice/practice_hub_screen.dart` | Wire quiz buttons to spelling_quiz_screen |

**Phase 10D Output: 4 files**
**Dependencies: Phase 1 (repos), Phase 2 (providers)**

---

## PHASE 10E: DIGITAL GAMES ARCHITECTURE

**Goal:** Framework for 7 games, level-gated with shared data.

### The 7 Games

| # | Game | Engine | Level | Status |
|---|------|:------:|:-----:|--------|
| 0 | **Sound Explorer** | Flutter | FREE + All | Phase 7 (redesigned Sound Board) |
| 1 | **Sound Quest** | Flutter + Flame | L1+ | Needs implementation |
| 2 | **Rule Master** | Flutter + Flame | L1+ | Needs implementation |
| 3 | **Word Crusher** | Flame | L2+ | Needs implementation |
| 4 | **Rule Runner** | Flame | L2+ | Needs implementation |
| 5 | **Daily Decoder** | Flutter | FREE | Needs implementation |
| 6 | **Classroom Arena** | Flutter + WebSocket | L1+ | Needs implementation |

### How Games Connect to Levels

```
FREE:
  Sound Explorer → browse 45 sounds (free) / all phonograms + characters (paid)
  Daily Decoder → 1 puzzle per day using current level's content

Level 1 🟢:
  Sound Quest → 7 worlds, one per phonogram category
                World 1-3 use Level 1 phonograms (50)
  Rule Master → Puzzles for Rules 1-15

Level 2 🔵:
  Sound Quest → Worlds 4-5 use Level 2 phonograms (+24)
  Rule Master → Puzzles for Rules 16-25
  Word Crusher → Match-3 with Level 1+2 words
  Rule Runner → Endless runner with Level 1+2 content

Level 3+ 🟠🔴🟡:
  All games unlock more content as levels progress
  Classroom Arena available at any paid level
```

### Game Implementation Order

```
Phase 7:  Sound Explorer (redesigned Sound Board) ← ALREADY IN PLAN
Phase ?:  Daily Decoder (daily puzzle, pure Flutter) ← BUILD NEXT
Phase ?:  Sound Quest (adventure, Flutter + Flame) ← BIGGEST GAME
Phase ?:  Rule Master (puzzles, Flutter + Flame)
Phase ?:  Word Crusher (match-3, Flame)
Phase ?:  Rule Runner (endless runner, Flame)
Phase ?:  Classroom Arena (multiplayer, WebSocket)
```

### Files (Framework Only — Individual Games Built Later)

| # | Action | File | Purpose |
|---|--------|------|---------|
| 1 | MODIFY | `lib/presentation/screens/games/games_hub_screen.dart` | Level-gated game cards with progress |
| 2 | CREATE | `lib/shared/providers/game_access_provider.dart` | Which games are accessible at current level |
| 3 | MODIFY | `lib/presentation/screens/games/games_hub_screen.dart` | Show level requirement per game |

**Phase 10E Output: 3 files (framework only, individual games are separate sprints)**

---

## PHASE 10F: PHYSICAL GAME COMPANION (Beyond QR Scanner)

**Goal:** Complete physical game experience in the app.

### Features

```
┌──────────────────────────────────────┐
│  MY PHYSICAL GAMES                   │
│                                      │
│  ── YOUR CARD COLLECTION ──          │
│  Physical cards scanned: 45/313      │
│  🟢 35  🔵 8  🟠 0  🔴 0  🟡 2    │
│                                      │
│  ── GAME MODES ──                    │
│                                      │
│  🃏 Power Cards (40 modes)           │
│    ▶ Snap — Same Sound!             │
│    ▶ Word Builder                    │
│    ▶ Trump & Memory Match            │
│    ▶ Decode Race                     │
│    ▶ Team Battle                     │
│    🔒 34 more modes (Premium)        │
│                                      │
│  ♟️ Rule Breaker Board (50 modes)    │
│    ▶ Classic Board Game              │
│    🔒 49 more modes (Premium)        │
│                                      │
│  🗼 Crack the Tower (50 modes)       │
│  👋 Phonogram Slam (34 modes)        │
│  📊 Sticker Chart (25 modes)         │
│                                      │
│  ── HOW TO PLAY ──                   │
│  Each game has:                      │
│    🎧 Audio instructions (3 lang)    │
│    📺 Video demo (3 lang)            │
│    📖 Written rules                  │
│                                      │
│  ── SCORE TRACKER ──                 │
│  Record your physical game scores!   │
│  [+ New Game Session]               │
│                                      │
│  ── BUY GAMES ──                     │
│  [🛒 Order from website]            │
│                                      │
└──────────────────────────────────────┘
```

### Files

| # | Action | File | Purpose |
|---|--------|------|---------|
| 1 | CREATE | `lib/presentation/screens/games/physical_games_hub.dart` | Physical game browser |
| 2 | CREATE | `lib/presentation/screens/games/game_modes_screen.dart` | Mode list per physical game |
| 3 | CREATE | `lib/presentation/screens/games/how_to_play_screen.dart` | Audio/video/text instructions |
| 4 | CREATE | `lib/presentation/screens/games/score_tracker_screen.dart` | Manual score entry |
| 5 | CREATE | `assets/data/physical_games.json` | 10 games × modes × instructions |

**Phase 10F Output: 5 files**

---

## UPDATED PHASE SUMMARY

### Original 12 Phases + 6 New Sub-Phases

| Phase | What | Files |
|:-----:|------|:-----:|
| 0 | Data Generation | 14 |
| 1 | Data Models + Repos | 12 |
| 2 | Providers + Core Logic | 8 |
| 3 | 7-Day Free Trial | 5 |
| 4 | Home Screen | 5 |
| 5 | Character Collection | 4 |
| 6 | Learn Tab | 6 |
| 7 | Sound Explorer | 3 |
| 8 | Practice Integration | 1 |
| 9 | Progress Dashboard | 4 |
| 10 | Physical Card Scanner | 3 |
| **10A** | **Video Course Integration** | **4** |
| **10B** | **Flashcard System** | **5** |
| **10C** | **Mind Map System** | **5** |
| **10D** | **Quiz System** | **4** |
| **10E** | **Digital Games Framework** | **3** |
| **10F** | **Physical Game Companion** | **5** |
| 11 | Audio Generation | ~1200 |
| 12 | Polish | ~20 |
| **TOTAL** | | **~1310** |

## PHASE 11: AUDIO GENERATION

**Goal:** Generate audio for all new content.

### Audio Files Needed

| Category | Files | Content | Tool |
|----------|:-----:|---------|------|
| 45 sound pronunciations | 45 | "/b/", "/sh/", "/ā/" | edge-tts |
| 168 character introductions | 168 | "I'm BLITZ! I make /b/!" | edge-tts |
| 168 character sound files | 168 | Just the sound "/b/" | edge-tts |
| 1000 word pronunciations | ~700 new | Words not yet generated | edge-tts |
| Hindi sounds (45) | 45 | Hindi equivalent | edge-tts (hi-IN) |
| Marathi sounds (45) | 45 | Marathi equivalent | edge-tts (mr-IN) |
| **Total** | **~1,200** | | |

### Script

```bash
python3 tools/generate_character_audio.py  # 168 character intros
python3 tools/generate_sound_audio.py      # 45 pure sounds
python3 tools/generate_word_audio.py       # 700+ new words
```

**Phase 11 Output: ~1,200 audio files**
**Dependencies: Phase 0 (character data must exist)**
**Can run in PARALLEL with Phases 3-10**

---

## PHASE 12: POLISH + LAUNCH PREP

**Goal:** Final quality, animations, accessibility, testing.

### Tasks

| # | Task | Files |
|---|------|:-----:|
| 1 | Level transition celebrations (gold confetti, KK animation) | 1 |
| 2 | Character unlock animation (card flip, sparkle) | 1 |
| 3 | Haptic feedback on discoveries | modify 3 |
| 4 | All strings localized (EN/HI/MR) | modify 1 |
| 5 | Accessibility audit (contrast, screen reader) | modify 5 |
| 6 | Loading states + error states on all screens | modify 8 |
| 7 | App icon updated with character | 1 |
| 8 | Splash screen with level colors | 1 |
| 9 | Full end-to-end test flow | test files |

**Phase 12 Output: ~20 file modifications**

---

## COMPLETE FILE MANIFEST

| Phase | New Files | Modified | Data Files | Total |
|:-----:|:---------:|:--------:|:----------:|:-----:|
| 0 | 6 scripts | 0 | 8 JSON | 14 |
| 1 | 8 | 4 | 0 | 12 |
| 2 | 4 | 4 | 0 | 8 |
| 3 | 5 | 0 | 0 | 5 |
| 4 | 2 | 3 | 0 | 5 |
| 5 | 4 | 0 | 0 | 4 |
| 6 | 1 | 2 | 3 | 6 |
| 7 | 1 | 2 | 0 | 3 |
| 8 | 0 | 1 | 0 | 1 |
| 9 | 4 | 0 | 0 | 4 |
| 10 | 3 | 0 | 0 | 3 |
| 11 | 3 scripts | 0 | ~1200 audio | 1203 |
| 12 | 2 | 17 | 0 | 19 |
| **TOTAL** | **43** | **33** | **1211** | **1287** |

---

## PARALLELIZATION

```
Phase 0  ─────────────────────────── (run first, offline)
    ↓
Phase 1  ─────── Phase 11 ──────── (parallel: code + audio)
    ↓
Phase 2  ─────────────────────────
    ↓
Phase 3 ─── Phase 4 ─── Phase 5 ── (parallel: trial + home + collection)
              ↓
         Phase 6 ─── Phase 7 ───── (parallel: learn + sound explorer)
              ↓
         Phase 8 ─── Phase 9 ───── (parallel: practice + progress)
              ↓
         Phase 10 ─────────────────
              ↓
         Phase 12 ───────────────── (last)
```

**Critical path: 0 → 1 → 2 → 3/4/5 → 6/7 → 8/9 → 10 → 12**
**Estimated: 5-7 days of focused development**

---

## TEST FLOW (After All Phases)

```
1. Open app → 7-day trial screen (not seen before)
2. Day 1: Learn 10 consonant sounds with character cards
   - Tap BLITZ → hear /b/ → see BIG, BAT, BUS
   - Tap FANG → hear /f/ → see FISH, FOX, FIRE
3. Complete Day 1 → Day 2 unlocks
4. ... Days 2-6 ...
5. Day 7: ALL 45 SOUNDS MASTERED! 🎉
   - Sound Explorer badge
   - "Start Level 1" or "Continue free"
6. Home screen: Level 1 🟢 banner
   - Today's character: CHIEF
   - Continue Lesson: Week 1, Consonant Teams
   - Collection: 0/70 🟢 characters
7. Learn tab: Level-grouped lessons
   - Lesson 1.1: Single Vowels → learn with characters
   - Each phonogram has a character (ASH, ACE, ALMS for A)
8. Collection: 168 characters grouped by level color
   - Tap FANG → full detail with 20+ words
9. Sound Explorer: 45 sound cards
   - Tap /f/ → see F (FANG), PH (DOLPHIN), GH (LAUGH)
10. Practice: Spelling Bee with Level 1 words (top 500)
11. Progress: 5-level journey + mastery + achievements
12. Scan physical card → character unlocks!
13. Complete Level 1 → Level 2 🔵 UNLOCKED! 🎉
```

---

## THE VISION

> A child downloads the free app. KK greets them: "English has 45 secret sounds. Master them all in 7 days!" Each day, they meet characters like BLITZ (/b/), FANG (/f/), and ASH (/ă/). By Day 7, they know every English sound. Their parent buys Level 1. Now they collect 70 GREEN characters, each teaching a phonogram. CHIEF teaches /ch/. SHADOW teaches /sh/. Every character shows dozens of real words the child actually uses. They scan their physical card — CHIEF appears in the app! By Level 5, they've collected all 168 characters, mastered 107 phonograms, learned 100 rules, and can spell 10,000 of the most common English words. They've cracked the code.
