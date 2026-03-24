# StreamShaala Database Schema Analysis

**Generated:** Phase 6.1 - Database Consolidation
**Current Version:** 18
**Total Tables:** 29

---

## Version History

| Version | Changes | Tables Added/Modified |
|---------|---------|----------------------|
| v1 | Base tables | bookmarks, notes, progress, collections, collection_videos, preferences, search_history |
| v2 | Progress metadata | Added title, channel_name, thumbnail_url to progress |
| v3 | Quiz system | questions_offline, quizzes_offline, quiz_sessions |
| v4 | Quiz sessions | Added selected_question_ids to quiz_sessions |
| v5 | Quiz history | quiz_attempts |
| v6 | Question review | Added questions_data to quiz_attempts |
| v7 | Quiz status | Added status to quiz_attempts |
| v8 | Quiz titles | Added title to quizzes_offline |
| v9 | App state | app_state |
| v10 | Pedagogy system | concept_mastery, spaced_repetition, learning_paths, gamification, xp_events, badges, video_learning_sessions, pre_assessments, chapter_assessments |
| v11 | Recommendations | recommendations_history + quiz attempt metadata |
| v12 | Learning paths | Added metadata to learning_paths |
| v13 | Assessment types | Added assessment_type to quiz_sessions |
| v14 | Junior app | user_profile_junior, parental_controls, screen_time_log |
| v15 | Multi-profile | Added profile_id to progress, bookmarks |
| v16 | Multi-profile complete | Added profile_id to notes, collections, search_history |
| v17 | Study tools | video_summaries, glossary_terms, video_qa, mind_map_nodes, flashcard_decks, flashcards, flashcard_progress |
| v18 | Chapter study | chapter_summaries, chapter_notes |

---

## Table Categories

### 1. User Data Tables (8)

| Table | Description | Indexes | Foreign Keys |
|-------|-------------|---------|--------------|
| bookmarks | Video bookmarks | video_id, profile_id, created_at | - |
| notes | Video timestamp notes | video_id, profile_id, updated_at | - |
| progress | Video watch progress | video_id, profile_id, last_watched, completed | - |
| collections | User playlists | profile_id, created_at | - |
| collection_videos | Videos in playlists | collection_id, video_id, added_at | collections(id) |
| preferences | Key-value settings | - (primary key only) | - |
| search_history | Search queries | profile_id, query, timestamp | - |
| app_state | App config/migrations | - (primary key only) | - |

### 2. Quiz System Tables (4)

| Table | Description | Indexes | Foreign Keys |
|-------|-------------|---------|--------------|
| questions_offline | Cached questions | difficulty, topic_ids | - |
| quizzes_offline | Cached quizzes | entity_id, level | - |
| quiz_sessions | Active quiz state | student_id, quiz_id, start_time | - |
| quiz_attempts | Completed quizzes | student_id, quiz_id, completed_at, subject_id, passed, score + 4 composite | - |

### 3. Pedagogy System Tables (10)

| Table | Description | Indexes | Foreign Keys |
|-------|-------------|---------|--------------|
| concept_mastery | Student mastery scores | student_id, concept_id, is_gap, next_review | - |
| spaced_repetition | SM-2 algorithm state | student_id, next_review + composite | - |
| learning_paths | Generated learning paths | student_id, status | - |
| gamification | XP, levels, streaks | student_id, level | - |
| xp_events | XP award audit log | student_id, timestamp, event_type | - |
| badges | Badge progress | student_id, is_unlocked | - |
| video_learning_sessions | Video learning state | student_id, video_id, started_at | - |
| pre_assessments | Subject pre-tests | student_id, subject_id | - |
| chapter_assessments | Chapter tests | student_id, chapter_id, subject_id | - |
| recommendations_history | Video recommendations | quiz_attempt_id, user_id, assessment_type + composite | quiz_attempts(id) |

### 4. Junior App Tables (3)

| Table | Description | Indexes | Foreign Keys |
|-------|-------------|---------|--------------|
| user_profile_junior | Child profiles | grade | - |
| parental_controls | PIN and limits | user_id, is_enabled | user_profile_junior(id) |
| screen_time_log | Daily usage | user_id, date + composite | user_profile_junior(id) |

### 5. Study Tools Tables (9)

| Table | Description | Indexes | Foreign Keys |
|-------|-------------|---------|--------------|
| video_summaries | Auto/manual summaries | video_id, segment | - |
| glossary_terms | Vocabulary | chapter_id, segment, term | - |
| video_qa | Q&A per video | video_id, profile_id, status | - |
| mind_map_nodes | Visual concept maps | chapter_id, parent_id, segment | - |
| flashcard_decks | Flashcard collections | topic_id, chapter_id, segment | - |
| flashcards | Individual cards | deck_id, order | flashcard_decks(id) |
| flashcard_progress | SM-2 for flashcards | card_id, profile_id, next_review + composite | flashcards(id) |
| chapter_summaries | Chapter summaries | chapter_id, subject_id, segment | - |
| chapter_notes | Personal/curated notes | chapter_id, profile_id, note_type, segment + composite | - |

---

## Index Summary

**Total Indexes:** 80+

### Index Types:
- **Single column indexes:** Most common, for frequent WHERE clauses
- **Composite indexes:** For complex queries (student_id + completed_at, etc.)
- **DESC indexes:** For time-based sorting (completed_at DESC, etc.)

---

## Schema Health Assessment

### Strengths

1. **Comprehensive Indexing** - All tables have appropriate indexes for query patterns
2. **Foreign Key Constraints** - Used where appropriate (collections, flashcards, recommendations)
3. **Idempotent Migrations** - All migrations check before creating (prevents duplicate columns)
4. **Platform Abstraction** - Works on mobile (sqflite) and desktop (sqflite_ffi)
5. **Multi-Profile Support** - profile_id added to user data tables

### Potential Improvements

1. **Schema Validation** - Add startup health check to verify all tables/columns exist
2. **Backup Before Migration** - Export data before schema changes
3. **Consolidated Fresh Install** - For new users, create all tables at once vs 18 migrations

---

## Migration Safety

All migrations are **safe and idempotent**:
- Table existence checks before CREATE
- Column existence checks before ALTER TABLE
- Proper error handling and logging
- Transaction safety via SQLite

---

## Recommendations

### Phase 6.2: Database Health Check
Add `verifySchema()` method to check:
- All expected tables exist
- All expected columns exist
- All expected indexes exist

### Phase 6.3: Backup Utility
Add `backupDatabase()` method to:
- Export database to JSON
- Allow import for recovery
- Run before migrations

### Phase 6.4: Migration Consolidation
- Keep incremental migrations for existing users
- Add optional "fresh install" path that creates v18 schema directly
- Reduces startup time for new installations
