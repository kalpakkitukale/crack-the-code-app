# CRACK THE CODE — UX Improvement Prompt
## Complete list of issues to fix + improvements to make

---

## CRITICAL BUGS (App-Breaking)

### 1. Practice tab — ALL buttons are dead
**Files:** `lib/presentation/screens/practice/practice_hub_screen.dart`
**Issue:** Spelling Bee, Dictation, Unscramble, Word Match, Daily Challenge, ALL 3 quiz buttons — every `onTap` is `() {}` (empty). User taps, nothing happens.
**Fix:** Wire to existing spelling screens at `lib/presentation/screens/spelling/`:
- Spelling Bee → `SpellingBeeScreen`
- Dictation → `SpellingPracticeScreen`
- Unscramble → `UnscrambleScreen`
- Word Match → `WordMatchScreen`
- Add "Coming Soon" snackbar for quizzes (consistent with Games tab pattern)

### 2. Episode format buttons don't work
**File:** `lib/presentation/screens/learn/episode_list_screen.dart`
**Issue:** Tapping "Audio Lesson", "Video Guide", "KK's Adventure" just closes the bottom sheet. No content plays.
**Fix:** For now, show URLs or "Content coming soon" message. When audio/video URLs are populated in `video_course.json`, open audio player or webview.

### 3. Study Tools not wired
**File:** `lib/presentation/screens/learn/learn_hub_screen.dart`
**Issue:** Flashcards, Glossary, Mind Maps cards have `onTap: () {}` (empty).
**Fix:** Navigate to existing study tool screens with `subjectId: 'spelling'`:
- Flashcards → `FlashcardDecksScreen(subjectId: 'spelling', chapterId: 'phonograms')`
- Glossary → `GlossaryScreen(subjectId: 'spelling', chapterId: 'phonograms')`
- Mind Maps → show premium dialog (already marked isPremium)

### 4. Missing 74th phonogram
**File:** `assets/data/phonograms.json`
**Issue:** Only 73 phonograms. ID "74" (QU) is listed as ID "73". Either one phonogram is missing or IDs are off by one.
**Fix:** Audit all 74 phonograms against the master list in `DATA/sound_cards_data.js` and ensure all 74 are present with correct IDs.

### 5. Onboarding auto-advances
**File:** `lib/games/sound_board/screens/onboarding_flow.dart`
**Issue:** After tapping a phonogram, auto-jumps to next after 800ms. User can't explore.
**Fix:** Remove `Future.delayed(800ms)`. Show the phonogram detail card (like lesson screen). User taps "Next" when ready.

### 6. SCI Hindi pronunciation wrong
**File:** `assets/data/phonograms.json`
**Issue:** SCI shows "स्की" (ski) but SCI makes /sh/ sound (as in "science" = साइंस). The Hindi should be "श (जैसे साइंस)" not "स्की".
**Fix:** Audit ALL Hindi/Marathi pronunciations. They should show the SOUND, not transliterate the letters.

---

## HIGH PRIORITY (Breaks UX)

### 7. Inconsistent "dead link" vs "coming soon" pattern
**Issue:** Games tab shows "Coming Soon" snackbar. Practice tab shows nothing. Learn tab shows nothing.
**Fix:** Unify pattern — ALL unimplemented features show "Coming Soon" snackbar or a styled placeholder screen, never silent empty handlers.

### 8. Locked lessons give no feedback
**File:** `lib/presentation/screens/learn/learn_hub_screen.dart`
**Issue:** Tapping a locked lesson does nothing. User doesn't know WHY it's locked or how to unlock.
**Fix:** Show bottom sheet: "Complete Lesson {N-1} to unlock this lesson!"

### 9. Word grid truncates without notice
**Files:** `phonogram_detail_screen.dart`, `lesson_screen.dart`
**Issue:** `.take(9)` limits words but no "See all X words →" button.
**Fix:** Show count and "See more" link that expands the grid.

### 10. No loading/error states
**Issue:** ALL screens that load from providers show nothing during load and raw error on failure.
**Fix:** Add `Shimmer` loading placeholders and friendly error messages with retry buttons.

### 11. Onboarding not localized
**File:** `lib/games/sound_board/screens/onboarding_flow.dart`
**Issue:** All messages hardcoded in English: "Hey! I'm KK!", "English has 74 secret sound codes..."
**Fix:** Move all strings to `app_strings.dart` with Hindi/Marathi translations.

---

## MEDIUM PRIORITY (Affects Experience)

### 12. Collection tile design needs improvement
**Issue:** Mystery tiles ("?") are too plain. Discovered tiles lack visual reward.
**Fix:**
- Mystery tiles: subtle shimmer animation, "?" with sparkle hint
- Discovered tiles: category-color glow, mastery ring indicator
- First discovery: flip animation (? → phonogram) with gold particles

### 13. Detail screen — word cards need phonogram highlighting
**Issue:** Word cards show plain text "SHIP". Should show "**SH**IP" with SH in phonogram color.
**Already partially done:** `_highlightPhonogram()` exists in lesson_screen. Verify it works in phonogram_detail_screen too.

### 14. Audio feedback missing on many interactions
**Issue:** Many taps have no audio feedback:
- Onboarding phonogram tap (uses 800ms delay instead of audio + detail)
- Collection tile tap (plays sound but no UI feedback like glow)
- Word card tap in detail screen (plays word but no visual highlight)
**Fix:** Add visual feedback (brief highlight, scale animation) on every tappable element.

### 15. No haptic feedback
**Issue:** No vibration on phonogram discovery, word builder validation, or achievements.
**Fix:** Use `HapticFeedback.lightImpact()` on discoveries and `HapticFeedback.mediumImpact()` on achievements.

### 16. Home screen doesn't show all content
**Issue:** After onboarding, home shows: Today's Sound, Collection, Word Builder, Tier Progress. Missing:
- "Continue Lesson" (which lesson user is on)
- "Daily Streak" counter
- "Recent Discoveries" (last 5 phonograms)
**Fix:** Add these sections between TodaySoundCard and CollectionOverviewCard.

---

## LOW PRIORITY (Polish)

### 17. Mini collection dots too dense
**File:** `lib/games/sound_board/widgets/collection_overview_card.dart`
**Issue:** 74 dots (12px each + 4px spacing) wraps to many rows on small phones.
**Fix:** Use a fixed 10-column grid, or show category bars instead of individual dots.

### 18. Multi-sound dots too small
**File:** `lib/shared/widgets/phonogram_tile_widget.dart`
**Issue:** Sound indicator dots are 4x4px — barely visible.
**Fix:** Increase to 5-6px, use brighter colors.

### 19. No scroll-to-top in collection
**Fix:** Add FAB or double-tap app bar to scroll to top.

### 20. Hardcoded strings throughout
**Files:** Nearly every screen has English-only hardcoded strings.
**Fix:** Move ALL user-facing strings to `app_strings.dart`. Priority:
- Onboarding messages (user's first impression)
- Section headers ("WORDS WITH", "MORE WORDS TO LEARN")
- Button labels ("Next Sound →", "CHECK WORD ✓")
- Error messages ("Hmm, not a word!")

### 21. Dark theme contrast issues
**Issue:** Some text (white at 40% opacity on navy background) may fail WCAG AA contrast ratio.
**Fix:** Audit all text colors. Minimum opacity for readable text on #0A0618: 60%.

### 22. No swipe gestures
**Issue:** In lesson screen, can't swipe left/right between phonograms. Must tap "Next".
**Fix:** Add `PageView` with swipe support in addition to Next button.

### 23. Word Builder only shows discovered phonograms
**Issue:** This is by design but there's no visual cue showing "discover more sounds to build more words!"
**Fix:** Add a banner at bottom of grid: "Discover more sounds in the collection to unlock them here!"

---

## DATA FIXES NEEDED

### 24. Verify all 74 phonograms present
Compare `phonograms.json` against this master list:
```
Single Vowels (6): A, E, I, O, U, Y
Single Consonants (20): B, C, D, F, G, H, J, K, L, M, N, P, Q, R, S, T, V, W, X, Z
Consonant Teams (14): SH, TH, CH, WH, PH, CK, NG, NK, GH, KN, WR, GN, DGE, TCH
Vowel Teams (18): EE, EA, OA, OI, OY, OU, OW, AU, AW, EW, OO, AI, AY, EI, EY, IE, UE, UI
R-Controlled (5): AR, ER, IR, UR, OR
GH Combos (4): GH, IGH, OUGH, AUGH
Special (7): TI, CI, SI, SCI, ED, QU, (1 more?)
```

### 25. Audit ALL Hindi/Marathi pronunciations
Key rule: Hindi/Marathi text must show the SOUND, not the letter names.
- SCI should be "श (जैसे साइंस)" NOT "स्की"
- TI should be "श (जैसे नेशन)" NOT "टी आई"
- ED should show 3 sounds: /ed/ /d/ /t/

### 26. Words need more coverage
Current: 240 words. Many phonograms have only 3-4 example words.
Target: Every phonogram should have 8-15 example words across difficulty levels.

---

## FEATURE PRIORITIES FOR NEXT SESSION

1. **Fix all dead buttons** (Practice, Learn, Episodes) — 1 hour
2. **Fix onboarding** (remove auto-advance, show detail card) — 30 min
3. **Fix Hindi/Marathi data** (audit all pronunciations) — 1 hour
4. **Add Continue Lesson to Home** — 30 min
5. **Add "Coming Soon" to all unimplemented features** — 30 min
6. **Localize all hardcoded strings** — 2 hours
7. **Wire Study Tools to spelling data** — 1 hour
8. **Add loading/error states** — 1 hour
9. **Add swipe navigation in lessons** — 30 min
10. **Polish animations and transitions** — 1 hour
