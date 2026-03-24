# Readiness Assessment & Video Recommendation System

## Document Overview
This document defines the complete readiness assessment system that determines which videos students should watch before accessing main content. It includes question bank design, scoring analysis, and video recommendation algorithms.

**Last Updated**: 2026-01-19
**Version**: 1.0

---

## 1. System Architecture

### 1.1 Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    STUDENT STARTS NEW TOPIC                     │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              READINESS ASSESSMENT (5-10 Questions)               │
│  Purpose: Test prerequisite knowledge needed for this topic     │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    ANALYZE RESULTS                              │
│  • Overall Score (0-100%)                                       │
│  • Concept-wise Performance                                     │
│  • Identify Weak Areas                                          │
│  • Determine Learning Path                                      │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              GENERATE PERSONALIZED VIDEO PLAYLIST                │
│                                                                  │
│  Score < 50%:  ➜ Prerequisite Videos (3-5 videos)              │
│                ➜ Basic Concept Videos (2-3 videos)              │
│                                                                  │
│  Score 50-79%: ➜ Concept Review Videos (2-3 videos)            │
│                ➜ Main Topic Videos (3-4 videos)                 │
│                                                                  │
│  Score ≥ 80%:  ➜ Main Topic Videos (4-6 videos)                │
│                ➜ Advanced/Application Videos (1-2 videos)       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                 STUDENT WATCHES VIDEOS                          │
│  • Videos presented in optimal sequence                         │
│  • Quick comprehension checks after key videos                  │
│  • Can skip ahead if demonstrating mastery                      │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   PRACTICE ASSESSMENT                            │
│  • 15-20 questions testing learned concepts                     │
│  • Score ≥ 70% = Topic Mastered ✅                              │
│  • Score < 70% = Additional Videos Recommended 🔄              │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Readiness Question Bank Design

### 2.1 Core Principles

**CRITICAL**: Readiness questions test PREREQUISITES, not the new topic itself.

**Example**:
- ❌ Wrong: Topic = "Multiplication of 2-digit numbers"
  - Readiness Q: "What is 23 × 45?" (This IS the topic!)

- ✅ Correct: Topic = "Multiplication of 2-digit numbers"
  - Readiness Q: "What is 6 × 7?" (Tests single-digit multiplication - prerequisite)
  - Readiness Q: "What is 10 + 10 + 10?" (Tests addition - needed for multiplication)
  - Readiness Q: "What digit is in the tens place in 34?" (Tests place value - needed)

### 2.2 Question Structure Template

```json
{
  "id": "gr4_m4_rq1",
  "topicId": "gr4_m_4_1",
  "topicName": "Place Value (4-digit numbers)",
  "type": "readiness",
  "questionType": "mcq",

  "question": "What is the place value of 5 in the number 253?",

  "options": [
    "5",
    "50",
    "500",
    "Tens place"
  ],

  "correctAnswer": 1,
  "correctAnswerText": "50",

  "explanation": "The digit 5 is in the tens place. To find place value, multiply: 5 × 10 = 50.",

  "difficulty": "basic",
  "estimatedTime": 30,

  "prerequisiteTopicId": "gr3_m_numbers",
  "prerequisiteTopicName": "Place Value (3-digit numbers)",
  "conceptTested": "Place value identification in 3-digit numbers",

  "tags": ["place value", "tens place", "3-digit numbers"],

  "relatedVideos": {
    "remedial": [
      {
        "videoId": "gr3_m_pv_v1",
        "title": "Place Value Basics | Ones, Tens, Hundreds",
        "reason": "Reviews fundamental place value concept"
      },
      {
        "videoId": "gr3_m_pv_v2",
        "title": "Finding Place Value | Math for Kids",
        "reason": "Shows how to calculate place value"
      }
    ]
  },

  "commonMistakes": [
    {
      "mistake": "Answered '5' - confused face value with place value",
      "conceptGap": "Difference between face value and place value",
      "remediation": {
        "videoId": "gr3_m_pv_v3",
        "videoTitle": "Face Value vs Place Value"
      }
    },
    {
      "mistake": "Answered 'Tens place' - gave place name instead of value",
      "conceptGap": "Place value calculation",
      "remediation": {
        "videoId": "gr3_m_pv_v2",
        "videoTitle": "Finding Place Value | Math for Kids"
      }
    }
  ],

  "bloomsLevel": "understand",
  "cognitiveLoad": "low"
}
```

### 2.3 Question Types and Distribution

**Per Readiness Assessment (8-10 questions)**:

| Question Type | Count | % | Purpose | Time |
|---------------|-------|---|---------|------|
| Multiple Choice (MCQ) | 4 | 40% | Quick concept check | 30-45s |
| Fill in the Blank | 3 | 30% | Recall ability | 30-60s |
| True/False | 2 | 20% | Identify misconceptions | 20-30s |
| Match/Order | 1 | 10% | Relationship understanding | 45-60s |

**Total Assessment Time**: 5-8 minutes

### 2.4 Difficulty Distribution

- **60% Basic** (Foundation): Tests if student knows the basics
- **30% Intermediate** (Application): Can they apply basics?
- **10% Advanced** (Integration): Can they connect concepts?

---

## 3. Concept Mapping Framework

### 3.1 Prerequisite Concept Graph

Each topic has a **prerequisite concept graph** that defines what must be known first.

**Example: Grade 4, Chapter 4, Topic 1 - "Place Value (4-digit numbers)"**

```
Target Topic: Place Value (4-digit numbers)
    ↑ Requires ↑

Prerequisite Layer 1 (Direct Prerequisites):
├─ Place Value (3-digit numbers) [CRITICAL]
├─ Number naming (hundreds, tens, ones) [CRITICAL]
└─ Multiplication by 10, 100 [IMPORTANT]
    ↑ Requires ↑

Prerequisite Layer 2 (Foundation):
├─ Counting to 1000
├─ Number recognition
└─ Basic multiplication facts
```

### 3.2 Concept-Question Mapping

Each readiness question maps to ONE specific prerequisite concept:

```json
{
  "topicId": "gr4_m_4_1",
  "topicName": "Place Value (4-digit numbers)",

  "prerequisiteConcepts": [
    {
      "conceptId": "pv_3digit",
      "conceptName": "Place value in 3-digit numbers",
      "importance": "critical",
      "questionsTestingThis": ["rq1", "rq2", "rq3"],
      "remedialVideos": ["v1", "v2", "v3"]
    },
    {
      "conceptId": "mult_by_10_100",
      "conceptName": "Multiplication by 10 and 100",
      "importance": "important",
      "questionsTestingThis": ["rq4", "rq5"],
      "remedialVideos": ["v4", "v5"]
    },
    {
      "conceptId": "number_comparison",
      "conceptName": "Comparing 3-digit numbers",
      "importance": "helpful",
      "questionsTestingThis": ["rq6", "rq7"],
      "remedialVideos": ["v6"]
    }
  ]
}
```

---

## 4. Scoring and Analysis System

### 4.1 Overall Score Calculation

```javascript
function calculateReadinessScore(answers, questions) {
  let totalQuestions = questions.length;
  let correctAnswers = 0;

  for (let i = 0; i < answers.length; i++) {
    if (answers[i] === questions[i].correctAnswer) {
      correctAnswers++;
    }
  }

  let score = (correctAnswers / totalQuestions) * 100;
  return Math.round(score);
}
```

**Score Interpretation**:
- **80-100%**: ✅ **Ready** - Student has strong prerequisite knowledge
- **50-79%**: ⚠️ **Partial** - Student has gaps but can proceed with support
- **0-49%**: ❌ **Not Ready** - Student needs prerequisite review first

### 4.2 Concept-Wise Analysis

More important than overall score is **which concepts are weak**.

```javascript
function analyzeConceptPerformance(answers, questions, conceptMapping) {
  let conceptScores = {};

  // Group questions by concept
  for (let concept of conceptMapping.prerequisiteConcepts) {
    let conceptQuestions = concept.questionsTestingThis;
    let correct = 0;
    let total = conceptQuestions.length;

    for (let qId of conceptQuestions) {
      let questionIndex = questions.findIndex(q => q.id === qId);
      if (answers[questionIndex] === questions[questionIndex].correctAnswer) {
        correct++;
      }
    }

    conceptScores[concept.conceptId] = {
      conceptName: concept.conceptName,
      importance: concept.importance,
      score: (correct / total) * 100,
      status: getConceptStatus(correct, total, concept.importance),
      remedialVideos: concept.remedialVideos
    };
  }

  return conceptScores;
}

function getConceptStatus(correct, total, importance) {
  let percentage = (correct / total) * 100;

  if (importance === "critical") {
    // Critical concepts need 100% mastery
    return percentage === 100 ? "mastered" : "needs_review";
  } else if (importance === "important") {
    // Important concepts need >= 66% mastery
    return percentage >= 66 ? "adequate" : "needs_review";
  } else {
    // Helpful concepts need >= 50%
    return percentage >= 50 ? "adequate" : "optional_review";
  }
}
```

**Example Output**:
```json
{
  "overallScore": 65,
  "conceptAnalysis": {
    "pv_3digit": {
      "conceptName": "Place value in 3-digit numbers",
      "importance": "critical",
      "score": 66,
      "status": "needs_review",
      "remedialVideos": ["v1", "v2", "v3"]
    },
    "mult_by_10_100": {
      "conceptName": "Multiplication by 10 and 100",
      "importance": "important",
      "score": 100,
      "status": "mastered",
      "remedialVideos": []
    },
    "number_comparison": {
      "conceptName": "Comparing 3-digit numbers",
      "importance": "helpful",
      "score": 50,
      "status": "adequate",
      "remedialVideos": []
    }
  },
  "weakConcepts": ["pv_3digit"],
  "strongConcepts": ["mult_by_10_100"]
}
```

---

## 5. Video Recommendation Algorithm

### 5.1 Recommendation Rules

```javascript
function generateVideoPlaylist(readinessAnalysis, topic, allVideos) {
  let playlist = [];
  let overallScore = readinessAnalysis.overallScore;
  let conceptAnalysis = readinessAnalysis.conceptAnalysis;

  // RULE 1: If overall score < 50%, focus on prerequisites
  if (overallScore < 50) {
    playlist = buildPrerequisitePlaylist(conceptAnalysis, allVideos);
  }

  // RULE 2: If score 50-79%, mix prerequisite review + main topic
  else if (overallScore < 80) {
    playlist = buildMixedPlaylist(conceptAnalysis, topic, allVideos);
  }

  // RULE 3: If score >= 80%, standard topic progression
  else {
    playlist = buildStandardPlaylist(topic, allVideos);
  }

  // RULE 4: Always prioritize CRITICAL weak concepts
  playlist = prioritizeCriticalConcepts(playlist, conceptAnalysis);

  return playlist;
}
```

### 5.2 Prerequisite Playlist (Score < 50%)

**Goal**: Build foundation before attempting main topic

```javascript
function buildPrerequisitePlaylist(conceptAnalysis, allVideos) {
  let playlist = [];

  // Step 1: Add videos for ALL weak concepts, critical first
  let weakConcepts = Object.values(conceptAnalysis)
    .filter(c => c.status === "needs_review")
    .sort((a, b) => {
      let importanceOrder = {"critical": 0, "important": 1, "helpful": 2};
      return importanceOrder[a.importance] - importanceOrder[b.importance];
    });

  for (let concept of weakConcepts) {
    // Add 2-3 remedial videos per weak concept
    let videos = concept.remedialVideos.slice(0, 3);
    playlist.push(...videos.map(vId => ({
      videoId: vId,
      reason: `Review: ${concept.conceptName}`,
      priority: concept.importance === "critical" ? "high" : "medium"
    })));
  }

  // Step 2: Add 1-2 gentle introduction videos to main topic
  let introVideos = allVideos
    .filter(v => v.topicId === topic.id && v.type === "gentle_intro")
    .slice(0, 2);

  playlist.push(...introVideos.map(v => ({
    videoId: v.id,
    reason: "Introduction to new topic",
    priority: "medium"
  })));

  // Limit playlist to 6-7 videos (don't overwhelm)
  return playlist.slice(0, 7);
}
```

**Example Playlist** (Student scored 45%):
```json
[
  {
    "videoId": "gr3_pv_v1",
    "title": "Place Value Basics",
    "reason": "Review: Place value in 3-digit numbers",
    "priority": "high",
    "duration": "5:30"
  },
  {
    "videoId": "gr3_pv_v2",
    "title": "Finding Place Value",
    "reason": "Review: Place value in 3-digit numbers",
    "priority": "high",
    "duration": "6:15"
  },
  {
    "videoId": "gr3_pv_v3",
    "title": "Face Value vs Place Value",
    "reason": "Review: Place value in 3-digit numbers",
    "priority": "high",
    "duration": "4:45"
  },
  {
    "videoId": "gr4_pv_v1",
    "title": "What are 4-Digit Numbers?",
    "reason": "Introduction to new topic",
    "priority": "medium",
    "duration": "7:00"
  }
]
```

### 5.3 Mixed Playlist (Score 50-79%)

**Goal**: Quick prerequisite review + main topic learning

```javascript
function buildMixedPlaylist(conceptAnalysis, topic, allVideos) {
  let playlist = [];

  // Step 1: Add 1-2 videos for critical weak concepts only
  let criticalWeak = Object.values(conceptAnalysis)
    .filter(c => c.importance === "critical" && c.status === "needs_review");

  for (let concept of criticalWeak) {
    let videos = concept.remedialVideos.slice(0, 2);  // Max 2 per concept
    playlist.push(...videos.map(vId => ({
      videoId: vId,
      reason: `Quick review: ${concept.conceptName}`,
      priority: "high"
    })));
  }

  // Step 2: Add main topic videos (concept intro + examples)
  let topicVideos = allVideos
    .filter(v => v.topicId === topic.id)
    .filter(v => v.type === "concept_intro" || v.type === "worked_examples")
    .slice(0, 4);

  playlist.push(...topicVideos.map(v => ({
    videoId: v.id,
    reason: v.type === "concept_intro" ? "Learn main concept" : "See examples",
    priority: "medium"
  })));

  return playlist.slice(0, 6);
}
```

**Example Playlist** (Student scored 65%):
```json
[
  {
    "videoId": "gr3_pv_v2",
    "title": "Finding Place Value",
    "reason": "Quick review: Place value in 3-digit numbers",
    "priority": "high",
    "duration": "6:15"
  },
  {
    "videoId": "gr4_pv_v1",
    "title": "Introduction to 4-Digit Numbers",
    "reason": "Learn main concept",
    "priority": "medium",
    "duration": "7:00"
  },
  {
    "videoId": "gr4_pv_v2",
    "title": "Place Value in Thousands",
    "reason": "Learn main concept",
    "priority": "medium",
    "duration": "8:30"
  },
  {
    "videoId": "gr4_pv_v3",
    "title": "Worked Examples: Finding Place Value",
    "reason": "See examples",
    "priority": "medium",
    "duration": "6:45"
  },
  {
    "videoId": "gr4_pv_v4",
    "title": "Practice Problems",
    "reason": "See examples",
    "priority": "medium",
    "duration": "5:20"
  }
]
```

### 5.4 Standard Playlist (Score >= 80%)

**Goal**: Efficient topic learning with full coverage

```javascript
function buildStandardPlaylist(topic, allVideos) {
  let playlist = [];

  // Step 1: Concept introduction (1-2 videos)
  let introVideos = allVideos
    .filter(v => v.topicId === topic.id && v.type === "concept_intro")
    .slice(0, 2);

  // Step 2: Worked examples (2-3 videos)
  let exampleVideos = allVideos
    .filter(v => v.topicId === topic.id && v.type === "worked_examples")
    .slice(0, 3);

  // Step 3: Real-world application (1-2 videos)
  let applicationVideos = allVideos
    .filter(v => v.topicId === topic.id && v.type === "real_world")
    .slice(0, 2);

  // Step 4: Challenge/advanced (1 video) - for strong students
  let challengeVideo = allVideos
    .filter(v => v.topicId === topic.id && v.type === "challenge")
    .slice(0, 1);

  playlist.push(
    ...introVideos.map(v => ({videoId: v.id, reason: "Learn concept", priority: "high"})),
    ...exampleVideos.map(v => ({videoId: v.id, reason: "See examples", priority: "medium"})),
    ...applicationVideos.map(v => ({videoId: v.id, reason: "Real-world use", priority: "medium"})),
    ...challengeVideo.map(v => ({videoId: v.id, reason: "Challenge yourself", priority: "low"}))
  );

  return playlist;
}
```

**Example Playlist** (Student scored 85%):
```json
[
  {
    "videoId": "gr4_pv_v1",
    "title": "Introduction to 4-Digit Numbers",
    "reason": "Learn concept",
    "priority": "high",
    "duration": "7:00"
  },
  {
    "videoId": "gr4_pv_v2",
    "title": "Place Value in Thousands",
    "reason": "Learn concept",
    "priority": "high",
    "duration": "8:30"
  },
  {
    "videoId": "gr4_pv_v3",
    "title": "Worked Examples: Finding Place Value",
    "reason": "See examples",
    "priority": "medium",
    "duration": "6:45"
  },
  {
    "videoId": "gr4_pv_v4",
    "title": "Practice Problems",
    "reason": "See examples",
    "priority": "medium",
    "duration": "5:20"
  },
  {
    "videoId": "gr4_pv_v5",
    "title": "Word Problems with Large Numbers",
    "reason": "See examples",
    "priority": "medium",
    "duration": "7:15"
  },
  {
    "videoId": "gr4_pv_v6",
    "title": "Place Value in Real Life",
    "reason": "Real-world use",
    "priority": "medium",
    "duration": "5:50"
  },
  {
    "videoId": "gr4_pv_v7",
    "title": "Challenge: 5-Digit Numbers Preview",
    "reason": "Challenge yourself",
    "priority": "low",
    "duration": "6:00"
  }
]
```

---

## 6. Adaptive Learning Features

### 6.1 Mid-Playlist Comprehension Checks

After watching 2-3 videos, ask 1-2 quick questions:

```json
{
  "checkpointAfterVideo": "gr4_pv_v3",
  "quickQuestions": [
    {
      "question": "What is the place value of 7 in 4,726?",
      "options": ["7", "70", "700", "7000"],
      "correctAnswer": 2,
      "ifWrong": {
        "action": "add_remedial_video",
        "videoId": "gr4_pv_v2",
        "message": "Let's review place value in the hundreds"
      }
    }
  ]
}
```

### 6.2 Skip-Ahead Logic

If student demonstrates mastery in checkpoints:

```javascript
if (comprehensionCheckScore === 100 && consecutiveCorrect >= 2) {
  // Skip next basic video, jump to application
  skipVideos = ["gr4_pv_v4"];  // Skip basic practice
  jumpTo = "gr4_pv_v6";  // Go to real-world application
}
```

### 6.3 Re-assessment Trigger

After watching recommended videos, offer re-assessment:

```
Student watches 3-4 remedial videos
    ↓
"Want to try the readiness quiz again?"
    ↓
If score improves to >= 80%: Unlock standard playlist
If score still low: Suggest more practice or prerequisite topic completion
```

---

## 7. Example: Complete Flow for One Student

### Student: Priya (Grade 4)
**Topic**: Place Value (4-digit numbers)

#### Step 1: Readiness Assessment

**Questions and Answers**:
1. What is the place value of 5 in 253? ✅ Correct (50)
2. What is the place value of 8 in 687? ✅ Correct (80)
3. Which is greater: 456 or 465? ✅ Correct (465)
4. What is 7 × 100? ❌ Wrong (Answered: 70, Correct: 700)
5. What is the digit in the hundreds place in 834? ✅ Correct (8)
6. What is 10 × 10? ❌ Wrong (Answered: 20, Correct: 100)
7. Write 456 in words: ✅ Correct (Four hundred fifty-six)
8. What comes after 999? ❌ Wrong (Answered: 9999, Correct: 1000)

**Score**: 5/8 = 62.5% (Rounded: 63%)

#### Step 2: Concept Analysis

```json
{
  "overallScore": 63,
  "readinessLevel": "partial",
  "conceptAnalysis": {
    "pv_3digit": {
      "score": 75,
      "status": "adequate",
      "questionsWrong": []
    },
    "mult_by_10_100": {
      "score": 0,
      "status": "needs_review",
      "questionsWrong": ["Q4", "Q6"]
    },
    "number_sequence": {
      "score": 0,
      "status": "needs_review",
      "questionsWrong": ["Q8"]
    }
  },
  "weakConcepts": ["mult_by_10_100", "number_sequence"],
  "recommendation": "Review multiplication by 10/100 before learning 4-digit place value"
}
```

#### Step 3: Generated Playlist

```json
{
  "studentName": "Priya",
  "playlistType": "mixed",
  "totalVideos": 6,
  "estimatedTime": "38 minutes",

  "videos": [
    {
      "order": 1,
      "videoId": "gr3_mult_v1",
      "title": "Multiplication by 10 and 100",
      "duration": "6:30",
      "reason": "Review: Multiplication by 10/100",
      "priority": "high",
      "mustWatch": true
    },
    {
      "order": 2,
      "videoId": "gr3_mult_v2",
      "title": "Patterns in Multiplying by 10",
      "duration": "5:15",
      "reason": "Review: Multiplication by 10/100",
      "priority": "high",
      "mustWatch": true
    },
    {
      "order": 3,
      "videoId": "gr4_pv_v1",
      "title": "Introduction to 4-Digit Numbers",
      "duration": "7:00",
      "reason": "Learn main concept",
      "priority": "medium",
      "mustWatch": true
    },
    {
      "order": 4,
      "videoId": "gr4_pv_v2",
      "title": "Place Value: Thousands Place",
      "duration": "8:30",
      "reason": "Learn main concept",
      "priority": "medium",
      "mustWatch": true
    },
    {
      "order": 5,
      "videoId": "gr4_pv_v3",
      "title": "Worked Examples",
      "duration": "6:45",
      "reason": "See examples",
      "priority": "medium",
      "mustWatch": false
    },
    {
      "order": 6,
      "videoId": "gr4_pv_v4",
      "title": "Practice Problems",
      "duration": "5:20",
      "reason": "Practice",
      "priority": "low",
      "mustWatch": false
    }
  ],

  "learningPath": {
    "phase1": "Review multiplication by 10/100 (Videos 1-2)",
    "checkpoint1": "Quick quiz after video 2",
    "phase2": "Learn 4-digit place value (Videos 3-4)",
    "checkpoint2": "Quick quiz after video 4",
    "phase3": "Practice (Videos 5-6)",
    "finalAssessment": "Practice quiz (15 questions)"
  }
}
```

#### Step 4: After Watching Videos

Priya watches videos 1-4 (core videos)

**Checkpoint after Video 2**:
- Q: "What is 9 × 100?" → Answered: 900 ✅
- Status: Multiplication concept understood, proceed

**Checkpoint after Video 4**:
- Q: "What is the place value of 3 in 3,456?" → Answered: 3000 ✅
- Status: Main concept understood, can skip basic practice

**Final Action**: Skip video 5, proceed directly to practice quiz

---

## 8. Implementation in Code

### 8.1 Database Schema

```sql
-- Readiness Questions Table
CREATE TABLE readiness_questions (
  id VARCHAR(20) PRIMARY KEY,
  topic_id VARCHAR(20) NOT NULL,
  question_type ENUM('mcq', 'fill_blank', 'true_false', 'match'),
  question_text TEXT NOT NULL,
  options JSON,  -- For MCQ
  correct_answer VARCHAR(100),
  explanation TEXT,
  difficulty ENUM('basic', 'intermediate', 'advanced'),
  prerequisite_concept_id VARCHAR(20),
  related_videos JSON,  -- Array of video IDs
  common_mistakes JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Student Readiness Attempts Table
CREATE TABLE readiness_attempts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  topic_id VARCHAR(20) NOT NULL,
  overall_score INT,  -- 0-100
  concept_scores JSON,  -- {"concept_id": score}
  weak_concepts JSON,  -- Array of concept IDs
  recommended_playlist JSON,  -- Array of video objects
  attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Video Watch Progress Table
CREATE TABLE video_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  video_id VARCHAR(20) NOT NULL,
  watch_percentage INT DEFAULT 0,  -- 0-100
  completed BOOLEAN DEFAULT FALSE,
  comprehension_check_score INT,  -- If applicable
  watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 8.2 API Endpoints

```javascript
// Submit readiness assessment
POST /api/assessment/readiness/submit
Body: {
  studentId: 123,
  topicId: "gr4_m_4_1",
  answers: [1, 2, 0, 3, 1, 2, 0, 3]  // Answer indices
}
Response: {
  score: 63,
  readinessLevel: "partial",
  conceptAnalysis: {...},
  recommendedPlaylist: [...],
  message: "Review multiplication by 10/100 before continuing"
}

// Get personalized video playlist
GET /api/videos/playlist/{studentId}/{topicId}
Response: {
  videos: [...],
  totalDuration: 2280,  // seconds
  mustWatchCount: 4,
  optionalCount: 2
}

// Update video progress
POST /api/videos/progress
Body: {
  studentId: 123,
  videoId: "gr4_pv_v1",
  watchPercentage: 85,
  completed: false
}

// Submit comprehension checkpoint
POST /api/assessment/checkpoint/submit
Body: {
  studentId: 123,
  checkpointId: "gr4_pv_checkpoint1",
  answers: [2, 1]
}
Response: {
  allCorrect: true,
  skipVideos: ["gr4_pv_v5"],
  continueFrom: "gr4_pv_v6"
}
```

---

## 9. Quality Metrics

### 9.1 System Effectiveness Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Readiness prediction accuracy | >85% | % of students who pass practice quiz after following playlist |
| Playlist relevance score | >4/5 | Student feedback on video helpfulness |
| Time to mastery | 30-45 min | Average time from readiness to practice quiz pass |
| Re-assessment improvement | >25% | Score increase after watching remedial videos |
| Concept identification accuracy | >90% | Weak concepts correctly identified |

### 9.2 Content Quality Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Question clarity | >4.5/5 | Student feedback |
| Video-question alignment | 100% | Manual review |
| Explanation helpfulness | >4/5 | Student feedback |
| Prerequisite accuracy | 100% | Expert review |

---

## 10. Next Steps for Implementation

### Phase 1: Pilot (Week 1)
- [ ] Create readiness assessment for ONE topic (Grade 4, Ch 4, Topic 1)
- [ ] Curate 8-10 videos (prerequisite + main topic)
- [ ] Write 8-10 readiness questions
- [ ] Implement scoring algorithm
- [ ] Test with 5 students

### Phase 2: Refinement (Week 2)
- [ ] Analyze pilot results
- [ ] Adjust question difficulty
- [ ] Refine video recommendations
- [ ] Improve playlist generation logic

### Phase 3: Scale (Weeks 3-10)
- [ ] Create readiness assessments for all Grade 4 topics
- [ ] Create readiness assessments for all Grade 5 topics
- [ ] Build automated playlist generator
- [ ] Integrate with main app

---

## Document End

This system ensures students are properly prepared before learning new topics, resulting in more effective learning and higher success rates.
