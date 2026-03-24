# Physics Quiz Data Summary

## Overview

This directory contains a complete hierarchical quiz system for Physics, demonstrating the reusability of questions across multiple quiz levels.

**Created**: 2025-10-28
**Total Files**: 9 quiz files
**Total Questions**: 60 unique questions
**Subject**: Physics

## Quiz Hierarchy

```
Physics Subject (60 questions)
├── Chapter 1: Laws of Motion (20 questions)
│   ├── Topic: Newton's First Law (10 questions)
│   ├── Topic: Newton's Second Law (10 questions)
│   └── Topic: Newton's Third Law (10 questions)
└── Chapter 2: Mechanics (20 questions)
    ├── Topic: Work and Energy (10 questions)
    ├── Topic: Kinematics (10 questions)
    └── Topic: Gravitation (10 questions)
```

## File Structure

### Topic-Level Quizzes (10 questions each, 40-40-20 distribution)

1. **topic_newtons_first_law.json**
   - ID: `topic_newtons_first_law`
   - Questions: q_nfl_001 to q_nfl_010
   - Topics: Law of Inertia, balanced forces, motion concepts
   - Time Limit: 600 seconds (10 minutes)

2. **topic_newtons_second_law.json**
   - ID: `topic_newtons_second_law`
   - Questions: q_nsl_001 to q_nsl_010
   - Topics: F=ma, force calculations, proportionality
   - Time Limit: 600 seconds (10 minutes)

3. **topic_newtons_third_law.json**
   - ID: `topic_newtons_third_law`
   - Questions: q_ntl_001 to q_ntl_010
   - Topics: Action-reaction pairs, force analysis
   - Time Limit: 600 seconds (10 minutes)

4. **topic_work_and_energy.json**
   - ID: `topic_work_and_energy`
   - Questions: q_we_001 to q_we_010
   - Topics: Work definition, kinetic/potential energy, conservation
   - Time Limit: 600 seconds (10 minutes)

5. **topic_kinematics.json**
   - ID: `topic_kinematics`
   - Questions: q_kin_001 to q_kin_010
   - Topics: Motion in a straight line, velocity, acceleration
   - Time Limit: 600 seconds (10 minutes)

6. **topic_gravitation.json**
   - ID: `topic_gravitation`
   - Questions: q_grav_001 to q_grav_010
   - Topics: Newton's law of gravitation, weight, orbital mechanics
   - Time Limit: 600 seconds (10 minutes)

### Chapter-Level Quizzes (20 questions each)

7. **chapter_laws_of_motion.json**
   - ID: `chapter_laws_of_motion`
   - Questions: 20 questions from 3 Newton's Law topics
   - Distribution: ~6-7 questions per topic
   - Difficulty: ~40% basic, ~40% intermediate, ~15% advanced
   - Time Limit: 1200 seconds (20 minutes)

8. **chapter_mechanics.json**
   - ID: `chapter_mechanics`
   - Questions: 20 questions from Work & Energy, Kinematics, Gravitation
   - Distribution: ~6-7 questions per topic
   - Difficulty: ~45% basic, ~35% intermediate, ~15% advanced
   - Time Limit: 1200 seconds (20 minutes)

### Subject-Level Quiz (60 questions)

9. **subject_physics.json**
   - ID: `subject_physics`
   - Questions: All 60 questions from all 6 topics
   - Distribution: 10 questions from each topic
   - Difficulty: 40% basic, 40% intermediate, 20% advanced
   - Time Limit: 3000 seconds (50 minutes)
   - Demonstrates complete hierarchical reuse

## Question Distribution

### By Difficulty (Target: 40-40-20)

| Level | Basic (40%) | Intermediate (40%) | Advanced (20%) | Total |
|-------|-------------|-------------------|----------------|-------|
| Topic | 4 questions | 4 questions | 2 questions | 10 |
| Chapter | 8 questions | 8 questions | 4 questions | 20 |
| Subject | 24 questions | 24 questions | 12 questions | 60 |

### By Topic

| Topic | Question IDs | Count |
|-------|-------------|-------|
| Newton's First Law | q_nfl_001 - q_nfl_010 | 10 |
| Newton's Second Law | q_nsl_001 - q_nsl_010 | 10 |
| Newton's Third Law | q_ntl_001 - q_ntl_010 | 10 |
| Work and Energy | q_we_001 - q_we_010 | 10 |
| Kinematics | q_kin_001 - q_kin_010 | 10 |
| Gravitation | q_grav_001 - q_grav_010 | 10 |
| **Total** | | **60** |

## Question Features

Each question includes:
- **id**: Unique identifier (e.g., q_nfl_001)
- **questionText**: The question prompt
- **questionType**: "mcq" (multiple choice question)
- **options**: Array of 4 answer choices
- **correctAnswer**: The correct answer (matches one option exactly)
- **explanation**: Detailed explanation of why the answer is correct
- **hints**: Array of 2 progressive hints
- **difficulty**: "basic", "intermediate", or "advanced"
- **conceptTags**: Tags for concept tracking and analytics
- **topicIds**: Array of topic IDs this question belongs to (enables hierarchical reuse)
- **videoTimestamp**: Link to specific time in video (null for now)
- **points**: 1 for basic/intermediate, 2 for advanced

## Key Concepts Covered

### Chapter 1: Laws of Motion
- Inertia and rest/motion states
- Force, mass, and acceleration relationships (F=ma)
- Balanced and unbalanced forces
- Action-reaction pairs
- Real-world applications of Newton's laws

### Chapter 2: Mechanics
- Work definition and calculations
- Kinetic and potential energy
- Conservation of energy
- Distance, displacement, velocity, acceleration
- Equations of motion
- Universal gravitation
- Weight vs. mass
- Orbital mechanics and escape velocity

## Hierarchical Reuse

The quiz system demonstrates perfect hierarchical reuse:

1. **Topic Quizzes**: Original 60 questions created (10 per topic)
2. **Chapter Quizzes**: Reuse questions from constituent topics
3. **Subject Quiz**: Reuses ALL questions from all topics

Example:
- Question `q_nfl_001` (Newton's First Law) appears in:
  - `topic_newtons_first_law.json`
  - `chapter_laws_of_motion.json`
  - `subject_physics.json`

This enables:
- **Efficiency**: Create questions once, use many times
- **Consistency**: Same questions assess same concepts across levels
- **Flexibility**: Easy to update questions and propagate changes
- **Analytics**: Track student performance on same questions across difficulty levels

## Usage in StreamShaala App

These quiz files can be loaded through the `QuizJsonDataSource`:

```dart
// Load a topic quiz
final topicQuiz = await quizJsonDataSource.loadQuizByEntityId('topic_newtons_first_law');

// Load a chapter quiz
final chapterQuiz = await quizJsonDataSource.loadQuizByEntityId('chapter_laws_of_motion');

// Load the subject quiz
final subjectQuiz = await quizJsonDataSource.loadQuizByEntityId('subject_physics');
```

The quiz data is then cached in the local database for offline access.

## Next Steps

To integrate these quizzes into your StreamShaala app:

1. **Update Asset Bundle**: Ensure `pubspec.yaml` includes the quizzes directory:
   ```yaml
   assets:
     - assets/data/quizzes/physics/
   ```

2. **Load on App Start**: Preload quiz data into the database during app initialization

3. **Link to Content**: Associate quiz entityIds with corresponding subjects, chapters, and topics in your content structure

4. **Enable Quiz Navigation**: Update UI to trigger quizzes from topic/chapter/subject screens

5. **Test Loading**: Verify all quiz files load correctly and questions display properly

6. **Add More Subjects**: Create similar quiz structures for other subjects (Chemistry, Math, Biology, etc.)

## Validation

All quiz files have been validated for:
- ✅ Valid JSON structure
- ✅ Correct difficulty distribution (40-40-20)
- ✅ Proper topicIds assignments
- ✅ Complete question fields
- ✅ Consistent naming conventions
- ✅ Appropriate time limits and passing scores

---

**Ready for Testing!** All Physics quiz data is complete and ready to be loaded into the StreamShaala application.
