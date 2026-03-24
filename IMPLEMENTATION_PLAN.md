# CRACK THE CODE — Definitive Implementation Plan
# Version: FINAL · Date: 2026-03-24

---

## THE APP IN ONE SENTENCE

A complete English spelling mastery platform where children learn 74 phonograms through structured lessons, practice with flashcards/quizzes/games, watch premium animated episodes, and track their journey from zero to spelling mastery — with configurable free/premium gating that you control without app updates.

---

## THE THREE PILLARS

```
┌─────────────────────────────────────────────────────────┐
│                                                          │
│  PILLAR 1: LEARN          PILLAR 2: PRACTICE             │
│  (Knowledge)              (Skills)                       │
│                                                          │
│  • 7 Free Lessons         • Spelling Bee                 │
│    (74 sounds)            • Dictation                    │
│  • 26 Premium Episodes    • Unscramble                   │
│    (why English works)    • Word Match                   │
│  • Flashcards             • Quizzes                      │
│  • Mind Maps              • Daily Challenge              │
│  • Glossary               • Word Builder                 │
│                                                          │
│              PILLAR 3: PLAY                               │
│              (Fun)                                        │
│                                                          │
│              • Sound Board (collect sounds)               │
│              • 6 Digital Games (coming)                   │
│              • Physical Game Companion                    │
│              • Daily Decoder                              │
│                                                          │
│         ┌─────────────────────────┐                      │
│         │ UNIFIED MASTERY SYSTEM  │                      │
│         │ Every activity feeds →  │                      │
│         │ phonogram + rule mastery│                      │
│         └─────────────────────────┘                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## NAVIGATION: 5 TABS

```
[🏠 Home]  [📖 Learn]  [✏️ Practice]  [🎮 Games]  [🏆 Progress]
```

| Tab | Screen | What User Sees |
|-----|--------|---------------|
| Home | SoundBoardHome | KK greeting, continue learning, today's sound, collection preview, daily challenge, tier progress |
| Learn | LearnHubScreen | "Learn the 74 Sounds" (7 free lessons) + Premium Course (26 episodes) + Study Tools (flashcards, mind maps, glossary) |
| Practice | PracticeHubScreen | Spelling Bee, Dictation, Unscramble, Word Match, Quizzes, Daily Challenge |
| Games | GamesHubScreen | Sound Board (playable) + 6 coming soon + Physical Game Companion |
| Progress | ProgressScreen | Phonogram mastery grid, rule mastery, tiers, streaks, XP, achievements |

---

## CONFIGURABLE CONTENT GATING

One JSON file controls everything. Change strategy without app update.

```json
{
  "version": 1,
  "free": {
    "learnTheSoundsAllLessons": true,
    "soundBoardFull": true,
    "dailyDecoderFull": true,
    "freeEpisodes": [0, 1, 2],
    "previewDurationSeconds": 120,
    "flashcardsPerDay": 50,
    "quizzesPerDay": 5,
    "spellingBeeMaxTier": 2,
    "glossaryMaxWords": 1000,
    "physicalGameFreeModes": 6,
    "wordBuilderFull": true,
    "dailyChallengeFull": true
  },
  "premium": {
    "allEpisodes": true,
    "allGames": true,
    "unlimitedFlashcards": true,
    "unlimitedQuizzes": true,
    "allTiers": true,
    "allGlossary": true,
    "allPhysicalModes": true,
    "offlineMode": true,
    "familyProfiles": 5,
    "parentAnalytics": true,
    "mindMaps": true
  },
  "pricing": {
    "yearly": 499,
    "monthly": 99,
    "trialDays": 7,
    "currency": "INR"
  }
}
```

**Change `"freeEpisodes": [0, 1, 2]` to `[0, 1, 2, 3, 4]` → instantly 5 episodes free.**
**Change `"quizzesPerDay": 5` to `999` → unlimited quizzes for A/B testing.**

---

## EXECUTION: 10 PHASES

### Overview

| Phase | What | New Files | Modified | Data Files | Can Parallel? |
|:-----:|------|:---------:|:--------:|:----------:|:-------------:|
| 0 | Content gating config | 0 | 1 | 1 | Yes |
| 1 | Study tools data (flashcards, mind maps, glossary) | 0 | 0 | 7 | Yes |
| 2 | "Learn the 74 Sounds" lesson data + model | 1 | 0 | 1 | Yes |
| 3 | Video course episode data | 0 | 0 | 1 | Yes |
| 4 | Providers (gating, lessons, episodes) | 3 | 0 | 0 | After 0,2,3 |
| 5 | Hub screens (Learn, Practice, Games, Lesson, Episodes) | 5 | 0 | 0 | After 4 |
| 6 | Navigation restructure (5 tabs) | 0 | 2 | 0 | After 5 |
| 7 | Home screen swap | 0 | 1 | 0 | After 6 |
| 8 | Quiz provider + mastery bridge | 2 | 0 | 0 | Parallel with 5 |
| 9 | Progress screen overhaul | 2 | 1 | 0 | After 8 |
| 10 | Games hub + polish + dev entry | 0 | 3 | 0 | After 6,9 |
| **Total** | | **13** | **7** | **10** | |

**30 file operations total. ~13 new Dart files + 10 data files + 7 modifications.**

---

### PHASE 0: Content Config + pubspec

**Create:** `assets/data/content_config.json`
**Modify:** `pubspec.yaml` (add new asset directories)

### PHASE 1: Spelling Data for Study Tools (7 JSON files)

These follow the EXACT format of existing NCERT study tool files — no code changes needed.

| File | Content | Records |
|------|---------|:-------:|
| `flashcards/spelling_phonograms_flashcards.json` | 74 phonogram flashcards in 7 decks | 74 |
| `flashcards/spelling_rules_flashcards.json` | 38 rule flashcards in 6 decks | 38 |
| `flashcards/spelling_words_flashcards.json` | Word flashcards by tier | 200 |
| `mind_maps/spelling_phonogram_families_mindmap.json` | Phonogram family tree | 82 nodes |
| `mind_maps/spelling_rules_overview_mindmap.json` | Rules by category | 45 nodes |
| `glossary/spelling_phonograms_glossary.json` | 74 phonogram definitions | 74 |
| `glossary/spelling_vocabulary_glossary.json` | 200 key word definitions | 200 |

### PHASE 2: "Learn the 74 Sounds" (FREE — the most important feature)

**Create:** `assets/data/lessons/learn_the_sounds.json`
**Create:** `lib/shared/models/lesson.dart`

7 structured lessons:
```
Lesson 1: Vowels          → A, E, I, O, U, Y (6 phonograms)
Lesson 2: Consonants       → B, C, D, F... Z (20 phonograms)
Lesson 3: Consonant Teams  → SH, TH, CH, WH... (14 phonograms)
Lesson 4: Vowel Teams      → EE, EA, OA, OI... (18 phonograms)
Lesson 5: R-Controlled     → AR, ER, IR, UR, OR (5 phonograms)
Lesson 6: GH Combos        → GH, IGH, OUGH, AUGH (4 phonograms)
Lesson 7: Special          → TI, CI, SI, SCI, ED, QU (7 phonograms)
```

Each lesson flow:
1. KK introduces the group
2. Listen & Tap: hear each phonogram, see example word
3. Flashcard practice (5 cards)
4. Mini quiz (5 questions)
5. Celebration → phonograms unlock in Sound Board

### PHASE 3: Video Course Episode Data

**Create:** `assets/data/episodes/video_course.json`

26 episodes with metadata. First 2-3 free (configurable), rest premium.
No actual video playback yet — just metadata + placeholder.

### PHASE 4: Providers (3 new files)

| File | Purpose |
|------|---------|
| `lib/shared/providers/content_gating_provider.dart` | Reads config, exposes `isFree(type, id)` |
| `lib/shared/providers/lesson_provider.dart` | Lesson progress, current step, completion |
| `lib/shared/providers/episode_provider.dart` | Episode list, locked/unlocked state |

### PHASE 5: Hub Screens (5 new files)

| File | Tab | What It Shows |
|------|-----|--------------|
| `learn_hub_screen.dart` | Learn | 7 lessons + course + study tools |
| `lesson_screen.dart` | Learn → | Step-by-step lesson with Sound Board |
| `episode_list_screen.dart` | Learn → | 26 episodes, free/locked |
| `practice_hub_screen.dart` | Practice | 4 activities + quizzes + daily challenge |
| `physical_games_screen.dart` | Games → | 5 physical games catalog |

### PHASE 6: Navigation (2 modified files)

| File | Change |
|------|--------|
| `route_constants.dart` | Add learn, games, lesson, episode, physical routes |
| `app_router.dart` | 5-tab shell, new routes, SoundBoardHome as home |

### PHASE 7: Home Screen (1 modified file)

| File | Change |
|------|--------|
| `home_screen.dart` | Return SoundBoardHome instead of SpellingHomeScreen |

### PHASE 8: Quiz + Mastery (2 new files, parallel with Phase 5)

| File | Purpose |
|------|---------|
| `spelling_quiz_provider.dart` | Generate quizzes from phonogram/rule data |
| `unified_mastery_provider.dart` | Aggregate all mastery into single view |

### PHASE 9: Progress Screen (2 new + 1 modified)

| File | Purpose |
|------|---------|
| `phonogram_mastery_grid.dart` | 74-tile colored mastery grid |
| `rule_mastery_list.dart` | 38-rule progress list |
| `progress_screen.dart` | Replace NCERT progress with spelling mastery |

### PHASE 10: Polish (3 modified files)

| File | Change |
|------|--------|
| `games_hub_screen.dart` | Wire Sound Board to actual screen, add physical games |
| `sound_board_home.dart` | Add navigation awareness for tab context |
| `main_dev.dart` | Use 5-tab router for dev testing |

---

## WHAT ALREADY EXISTS & REUSES

| Feature | Files | Status |
|---------|:-----:|--------|
| Sound Board game | 20 | ✅ Complete, no changes |
| Shared Foundation | 28 | ✅ Complete, minor additions |
| Flashcard screens | 9 | ✅ Reuse with new JSON data |
| Mind Map screens | 2 | ✅ Reuse with new JSON data |
| Glossary screens | 2 | ✅ Reuse with new JSON data |
| Quiz screens | 5 + 16 widgets | ✅ Reuse with new quiz provider |
| Spelling Bee | 2 | ✅ Already spelling-focused |
| Dictation | 2 | ✅ Already spelling-focused |
| Unscramble | 1 | ✅ Already spelling-focused |
| Word Match | 1 | ✅ Already spelling-focused |
| Gamification | 8 | ✅ XP, streaks, badges |
| Parental controls | 5 | ✅ Screen time, PIN |
| Progress tracking | 3 + 11 widgets | ⚠️ Needs Phase 9 update |

---

## FREE USER JOURNEY

```
Day 1: Download → KK greets → Start Lesson 1: Vowels
       Learn A (/a/, /ay/, /ah/) → hear, see CAT 🐱, CAKE 🎂, DAD 👨
       Learn E, I, O, U, Y → same
       Mini quiz → "6 vowels mastered!" 🎉
       Sound Board: 6 vowels now discoverable

Day 2: Lesson 2: Consonants → B, C, D, F...
       20 consonants learned
       Flashcard review of yesterday's vowels (spaced repetition)

Day 3: Lesson 3: Consonant Teams → SH, TH, CH...
       KK teaser: "Want to know WHY SH makes /sh/? Watch the course!"
       Free episode preview available

Day 4-7: Complete remaining lessons
       ALL 74 PHONOGRAMS KNOWN ✅

Day 8+: Daily practice:
       Spelling Bee (Tier 1 words)
       Daily Challenge
       Sound Board exploration
       Word Builder
       Flashcard reviews (spaced repetition)

Day 14: KK: "14-day streak! 🔥 You've mastered 42 phonograms!"
        Premium tease: "The course teaches 38 RULES..."
        [Continue free] [Start free trial]
```

**The free user NEVER feels blocked.** They get a complete phonogram education. Premium adds the DEPTH (why English works) and the FUN (5 more games).

---

## PREMIUM ENCOURAGEMENT (Not Blocking)

| Trigger | What User Sees |
|---------|---------------|
| After Lesson 3 | "Want to see HOW consonant teams were invented? Watch ep05!" |
| After all 7 lessons | "You know 74 sounds! The course teaches 38 RULES that connect them." |
| After 7-day streak | "Amazing streak! Premium adds 26 animated adventures with KK." |
| After mastering 50 phonograms | "You're halfway! Premium unlocks 5 spelling games." |
| In Episode List | First 2-3 episodes FREE, rest show 2-min preview + "Unlock" |
| In Games tab | Sound Board + Daily Decoder free, 5 games show "Premium" badge |
| In Progress | "Your child mastered 42 phonograms! Premium adds..." (parent-facing) |

---

## AFTER THIS PLAN: WHAT COMES NEXT

| Next Step | When |
|-----------|------|
| Expand words from 240 → 500 (Tier 1 complete) | After Phase 10 |
| Build Daily Decoder game | After testing |
| Build Sound Quest game | After Daily Decoder |
| Build remaining 4 games | One at a time |
| Produce animated videos (Flow/Veo 3) | In parallel with games |
| Host NLM audio/video | When videos ready |
| Physical game QR scanning | When camera integration ready |
| Firebase project setup | Before Play Store launch |
| Expand words to 5000 (Tiers 2-10) | Ongoing |
| Hindi/Marathi UI localization | Before India launch |

---

## EXECUTION TIMELINE

```
Phase 0-3: Data files (parallel)     ██████
Phase 4: Providers                         ████
Phase 5: Hub screens                           ████████
Phase 8: Quiz + Mastery (parallel)         ████████
Phase 6: Navigation                                  ████
Phase 7: Home swap                                       ██
Phase 9: Progress                                        ████
Phase 10: Polish                                             ████
                                                                 🎯 TESTABLE
```
