# Quiz Data Structure

This directory contains sample quiz data files demonstrating the hierarchical quiz system.

## File Structure

Quiz data files follow this JSON structure:

```json
{
  "quiz": {
    "id": "unique_quiz_id",
    "level": "video|topic|chapter|subject",
    "entityId": "entity_id_this_quiz_belongs_to",
    "title": "Quiz Title",
    "questionIds": ["q1", "q2", "..."],
    "timeLimit": 600,
    "passingScore": 0.7
  },
  "questions": [
    {
      "id": "q1",
      "questionText": "Question text here?",
      "questionType": "mcq",
      "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
      "correctAnswer": "Option 2",
      "explanation": "Detailed explanation here",
      "hints": ["Hint 1", "Hint 2"],
      "difficulty": "basic|intermediate|advanced",
      "conceptTags": ["concept1", "concept2"],
      "topicIds": ["topic_id_1", "topic_id_2"],
      "videoTimestamp": null,
      "points": 1
    }
  ]
}
```

## Quiz Levels

- **video**: 5 questions (specific to a single video)
- **topic**: 10 questions (questions tagged with topic ID)
- **chapter**: 20 questions (questions from all topics in the chapter)
- **subject**: 50 questions (questions from all chapters in the subject)

## Difficulty Distribution

The recommended difficulty distribution for quizzes is:
- **40%** Basic difficulty
- **40%** Intermediate difficulty
- **20%** Advanced difficulty

For example, a topic quiz with 10 questions should have:
- 4 basic questions
- 4 intermediate questions
- 2 advanced questions

## Field Descriptions

### Quiz Object

- `id`: Unique identifier for the quiz
- `level`: One of: video, topic, chapter, subject
- `entityId`: ID of the entity this quiz belongs to (e.g., topic ID for topic quiz)
- `title`: Human-readable title for the quiz
- `questionIds`: Array of question IDs included in this quiz
- `timeLimit`: Time limit in seconds (600 = 10 minutes)
- `passingScore`: Minimum score to pass (0.7 = 70%)

### Question Object

- `id`: Unique identifier for the question
- `questionText`: The question text
- `questionType`: Type of question (currently "mcq" for multiple choice)
- `options`: Array of answer choices
- `correctAnswer`: The correct answer (must match one of the options exactly)
- `explanation`: Detailed explanation of why the answer is correct
- `hints`: Array of hints to help students (optional)
- `difficulty`: One of: basic, intermediate, advanced
- `conceptTags`: Tags for concept tracking and analytics
- `topicIds`: **CRITICAL** - Array of topic IDs this question belongs to
- `videoTimestamp`: Link to specific time in video (optional, can be null)
- `points`: Number of points for this question (typically 1 for basic/intermediate, 2 for advanced)

## Hierarchical Structure

### Example: Topic Quiz

```json
{
  "quiz": {
    "id": "quiz_topic_newtons_first_law",
    "level": "topic",
    "entityId": "topic_newtons_first_law",
    "questionIds": ["q_nfl_001", "q_nfl_002", ..., "q_nfl_010"]
  },
  "questions": [
    {
      "id": "q_nfl_001",
      "difficulty": "basic",
      "topicIds": ["topic_newtons_first_law"]
    }
  ]
}
```

### Example: Chapter Quiz (Reusing Topic Questions)

```json
{
  "quiz": {
    "id": "quiz_chapter_laws_of_motion",
    "level": "chapter",
    "entityId": "chapter_laws_of_motion",
    "questionIds": [
      "q_nfl_001", "q_nfl_002", ..., // From Newton's First Law topic
      "q_nsl_001", "q_nsl_002", ..., // From Newton's Second Law topic
      "q_ntl_001", "q_ntl_002"  ...  // From Newton's Third Law topic
    ]
  },
  "questions": [
    {
      "id": "q_nfl_001",
      "topicIds": ["topic_newtons_first_law"]
    },
    {
      "id": "q_nsl_001",
      "topicIds": ["topic_newtons_second_law"]
    },
    {
      "id": "q_ntl_001",
      "topicIds": ["topic_newtons_third_law"]
    }
  ]
}
```

## Using the Quiz Generation Service

Instead of manually creating quiz files with pre-selected questions, you can use the `QuizGenerationService` to dynamically select questions:

```dart
final service = DefaultQuizGenerationService();

final params = QuizGenerationParams(
  level: QuizLevel.chapter,
  entityId: 'chapter_laws_of_motion',
  topicIds: [
    'topic_newtons_first_law',
    'topic_newtons_second_law',
    'topic_newtons_third_law'
  ],
);

final availableQuestions = await questionDao.getAll();

final result = await service.generateQuiz(
  params: params,
  availableQuestions: availableQuestions,
);

// result.selectedQuestionIds contains 20 questions with 40-40-20 distribution
```

## Sample Files

- `sample_topic_quiz.json`: Complete example of a topic-level quiz about Newton's First Law
  - 10 questions total
  - 4 basic (40%)
  - 4 intermediate (40%)
  - 2 advanced (20%)
  - All questions tagged with `topic_newtons_first_law`

## Creating Your Own Quiz Data

1. **Create Questions**:
   - Write clear, educational questions
   - Assign appropriate difficulty levels
   - **Tag with topicIds** for hierarchical reuse
   - Include helpful explanations
   - Add hints for student support

2. **Group Questions by Topic**:
   - Aim for 10+ questions per topic
   - Ensure variety in difficulty
   - Cover all key concepts

3. **Build Chapter Quizzes**:
   - Aggregate questions from multiple topics
   - Aim for 20 questions from 2-3 topics
   - Maintain 40-40-20 difficulty distribution

4. **Build Subject Quizzes**:
   - Aggregate questions from multiple chapters
   - Aim for 50 questions from 5+ chapters
   - Maintain difficulty distribution

## Best Practices

1. **Question Reusability**: Always include `topicIds` so questions can be reused at higher levels
2. **Difficulty Balance**: Follow the 40-40-20 distribution guideline
3. **Clear Explanations**: Provide detailed explanations to help learning
4. **Multiple Hints**: Offer progressive hints without giving away the answer
5. **Concept Tags**: Use consistent concept tags for analytics and recommendations
6. **Points System**: Use 1 point for basic/intermediate, 2 points for advanced questions

## Loading Quiz Data

Quiz data files can be loaded through the `QuizJsonDataSource`:

```dart
final quizData = await quizJsonDataSource.loadQuizByEntityId('topic_newtons_first_law');
```

The quiz data is then cached in the local database for offline access.
