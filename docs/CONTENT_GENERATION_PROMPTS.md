# Content Generation Prompts for Mathematics (Grades 4 & 5)

## Document Purpose
This document contains reusable prompt templates for systematically generating high-quality mathematics content for StreamShaala application. Use these prompts with AI assistants to create videos, questions, and learning materials.

---

## PROMPT TEMPLATE 1: Video Curation for a Topic

### Usage
Use this prompt to find and catalog quality YouTube videos for a specific mathematics topic.

### Prompt:

```
I need you to curate high-quality educational YouTube videos for the following mathematics topic:

**Grade**: [4 or 5]
**Chapter**: [Chapter Number and Name]
**Topic**: [Specific Topic Name]
**Learning Objectives**:
- [Objective 1]
- [Objective 2]
- [Objective 3]

**Target Audience**: CBSE Grade [4/5] students (age 9-11 years)

Please find 6-8 videos that meet these criteria:

**MUST HAVE**:
1. Aligned with CBSE/NCERT curriculum
2. Clear audio and high-quality visuals
3. Duration: 3-12 minutes (ideal)
4. Age-appropriate language and examples
5. Accurate mathematical content
6. Engaging teaching style

**DIVERSITY REQUIREMENTS**:
- 2 videos: Concept introduction ("What is...")
- 2-3 videos: Worked examples and problem-solving
- 1-2 videos: Real-world applications
- 1 video: Review/summary OR fun song/game (optional)

**PREFERRED CHANNELS** (prioritize these):
Khan Academy India, NCERT Official, BYJU'S, Vedantu, Magnet Brains, Maths with Mr. J, Numberock, HomeschoolPop, Math Antics

**OUTPUT FORMAT** (for each video):
```json
{
  "id": "gr[4/5]_m[chapter]_v[number]",
  "title": "[Video Title]",
  "description": "[Brief description of what the video covers]",
  "youtubeId": "[YouTube Video ID]",
  "youtubeUrl": "[Full YouTube URL]",
  "thumbnailUrl": "https://img.youtube.com/vi/[VIDEO_ID]/hqdefault.jpg",
  "duration": [seconds],
  "durationDisplay": "[MM:SS format]",
  "channelName": "[Channel Name]",
  "channelId": "[YouTube Channel ID]",
  "language": "[English/Hindi/Bilingual]",
  "topicId": "gr[4/5]_m_[chapter]_[topic]",
  "difficulty": "[basic/intermediate/advanced]",
  "examRelevance": ["CBSE", "ICSE"],
  "rating": [estimated 0-5],
  "viewCount": [approximate view count],
  "tags": ["tag1", "tag2", "tag3"],
  "learningObjectives": [
    "[What students will learn from this video]"
  ],
  "prerequisites": ["[Required prior knowledge]"],
  "followUpTopics": ["[Related topics to learn next]"],
  "dateAdded": "[Current date in ISO format]",
  "lastUpdated": "[Current date in ISO format]"
}
```

**VERIFICATION STEPS**:
1. Verify each YouTube link is active and not blocked
2. Watch at least 2 minutes of each video to confirm quality
3. Ensure videos don't have excessive ads or distractions
4. Check that difficulty levels are appropriately distributed

Please provide the complete JSON array with all 6-8 videos.
```

---

## PROMPT TEMPLATE 2: Readiness Question Bank Creation

### Usage
Use this prompt to create diagnostic readiness questions for a topic.

### Prompt:

```
Create a readiness assessment quiz for the following mathematics topic:

**Grade**: [4 or 5]
**Chapter**: [Chapter Number and Name]
**Topic**: [Specific Topic Name]
**Prerequisites**: [List prerequisite topics/concepts]

**PURPOSE**: These questions should assess whether students have the prerequisite knowledge to learn this new topic. They are diagnostic, not evaluative.

**REQUIREMENTS**:
- Total questions: 8-10
- Question types:
  * 40% Multiple Choice (4 questions)
  * 30% Fill in the Blanks (3 questions)
  * 20% True/False (2 questions)
  * 10% Match the Following (1 question)
- Difficulty: Mix of basic (60%) and intermediate (40%)
- Time: Each question should take 30-60 seconds
- Focus on PREREQUISITE concepts, not the new topic itself

**OUTPUT FORMAT** (for each question):
```json
{
  "id": "gr[4/5]_m[chapter]_rq[number]",
  "topicId": "gr[4/5]_m_[chapter]_[topic]",
  "type": "readiness",
  "questionType": "[mcq/fill_blank/true_false/match]",
  "question": "[Clear question text]",
  "options": ["Option 1", "Option 2", "Option 3", "Option 4"],  // For MCQ only
  "correctAnswer": [index or answer],
  "explanation": "[Why this is the correct answer, simple language]",
  "difficulty": "[basic/intermediate]",
  "prerequisiteTopic": "[Which prerequisite concept this tests]",
  "estimatedTime": [seconds],
  "tags": ["tag1", "tag2"],
  "learningObjective": "[What concept this tests]",
  "conceptTested": "[Specific concept being assessed]",
  "relatedVideos": ["video_id1", "video_id2"],  // Videos that teach this prerequisite
  "commonMistakes": [
    {
      "mistake": "[Common wrong answer or misconception]",
      "remediation": "[How to correct this - suggest video or concept]"
    }
  ]
}
```

**SCORING INTERPRETATION**:
- Score >= 80%: Student is ready for this topic
- Score 50-79%: Partial readiness, review prerequisites first
- Score < 50%: Not ready, complete prerequisite topics

Please create 8-10 high-quality readiness questions in JSON format.
```

---

## PROMPT TEMPLATE 3: Practice Question Bank Creation

### Usage
Use this prompt to create practice questions for reinforcing learned concepts.

### Prompt:

```
Create a practice question bank for the following mathematics topic:

**Grade**: [4 or 5]
**Chapter**: [Chapter Number and Name]
**Topic**: [Specific Topic Name]
**Learning Objectives**:
- [Objective 1]
- [Objective 2]
- [Objective 3]

**PURPOSE**: These questions help students apply and reinforce concepts they've just learned from videos.

**REQUIREMENTS**:
- Total questions: 15-20
- Question types:
  * 30% Multiple Choice (6 questions)
  * 25% Numerical Answer (5 questions)
  * 20% Fill in the Blanks (4 questions)
  * 15% Word Problems (3 questions)
  * 10% Match/Order (2 questions)
- Difficulty progression:
  * 40% Basic (direct application)
  * 40% Intermediate (multi-step)
  * 20% Advanced (problem-solving)
- Time: 30-90 seconds per question

**OUTPUT FORMAT** (for each question):
```json
{
  "id": "gr[4/5]_m[chapter]_pq[number]",
  "topicId": "gr[4/5]_m_[chapter]_[topic]",
  "type": "practice",
  "questionType": "[mcq/numerical/fill_blank/word_problem/match]",
  "question": "[Clear, concise question text]",
  "options": ["Option 1", "Option 2", "Option 3", "Option 4"],  // For MCQ
  "correctAnswer": [index or numerical answer],
  "explanation": "[Step-by-step explanation of the solution]",
  "difficulty": "[basic/intermediate/advanced]",
  "estimatedTime": [seconds],
  "tags": ["tag1", "tag2", "tag3"],
  "learningObjective": "[What this question reinforces]",
  "conceptTested": "[Specific concept being practiced]",
  "hints": [
    "[Hint 1 - guides toward solution]",
    "[Hint 2 - more specific guidance]"
  ],
  "relatedVideos": ["video_id1", "video_id2"],  // Videos that explain this concept
  "solution": {
    "steps": [
      "Step 1: [First step with explanation]",
      "Step 2: [Second step with explanation]",
      "Step 3: [Final step with answer]"
    ],
    "videoExplanation": "[video_id]"  // Optional video showing solution
  },
  "bloomLevel": "[remember/understand/apply/analyze]",
  "cbseType": "[objective/subjective]",
  "marksWeightage": [1-5]
}
```

**PROGRESSION EXAMPLE**:
- Question 1-6 (Basic): "What is 345 + 567?"
- Question 7-14 (Intermediate): "If Raj has 345 marbles and Priya has 567, how many do they have together?"
- Question 15-20 (Advanced): "A shop had 912 items. If they sold 345 toys and 567 books, how many items are left?"

Please create 15-20 progressive practice questions in JSON format.
```

---

## PROMPT TEMPLATE 4: Complete Topic Content Package

### Usage
Use this comprehensive prompt to generate ALL content for a topic in one go.

### Prompt:

```
I need a complete content package for a mathematics topic in the StreamShaala app.

## TOPIC DETAILS

**Board**: CBSE Elementary
**Grade**: [4 or 5]
**Subject**: Mathematics
**Chapter**: [Chapter Number: Chapter Name]
**Topic**: [Topic Name]

**Learning Objectives**:
1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

**Prerequisites**: [List prerequisite topics from previous grades/chapters]
**NCERT Reference**: [Chapter and page numbers from Maths Mela textbook]

---

## DELIVERABLES

Please create the following content:

### 1. VIDEOS (6-8 videos)
- 2 Concept Introduction videos
- 2-3 Worked Examples videos
- 1-2 Real-world Application videos
- 1 Review/Fun video (optional)

**Requirements**:
- YouTube links only (verify they work)
- Mix of English (70%), Hindi (20%), Bilingual (10%)
- Preferred channels: Khan Academy India, NCERT, BYJU'S, Vedantu, Magnet Brains
- Duration: 3-12 minutes each
- Complete metadata as per schema

### 2. READINESS QUESTIONS (8-10 questions)
- Test prerequisite knowledge only
- Mix: 40% MCQ, 30% Fill Blanks, 20% T/F, 10% Match
- Includes remediation guidance
- Linked to prerequisite videos

### 3. PRACTICE QUESTIONS (15-20 questions)
- Progressive difficulty (40% basic, 40% intermediate, 20% advanced)
- Mix: 30% MCQ, 25% Numerical, 20% Fill, 15% Word Problems, 10% Match
- Step-by-step solutions
- Hints for struggling students

### 4. RECOMMENDATION MAPPING
- Map each readiness question to relevant videos
- Map each practice question to explanatory videos
- Define remediation paths for weak areas

---

## OUTPUT FORMAT

Provide three separate JSON files:

**File 1: videos_gr[4/5]_ch[X]_topic[Y].json**
```json
{
  "chapterId": "gr[4/5]_math_ch[X]",
  "topicId": "gr[4/5]_m_[X]_[Y]",
  "topicName": "[Topic Name]",
  "subjectId": "mathematics_gr[4/5]",
  "videos": [
    { /* video 1 */ },
    { /* video 2 */ },
    // ... 6-8 videos total
  ]
}
```

**File 2: readiness_questions_gr[4/5]_ch[X]_topic[Y].json**
```json
{
  "topicId": "gr[4/5]_m_[X]_[Y]",
  "topicName": "[Topic Name]",
  "type": "readiness",
  "totalQuestions": 10,
  "estimatedTime": 600,
  "passingScore": 80,
  "questions": [
    { /* question 1 */ },
    { /* question 2 */ },
    // ... 8-10 questions total
  ]
}
```

**File 3: practice_questions_gr[4/5]_ch[X]_topic[Y].json**
```json
{
  "topicId": "gr[4/5]_m_[X]_[Y]",
  "topicName": "[Topic Name]",
  "type": "practice",
  "totalQuestions": 20,
  "estimatedTime": 1200,
  "difficultyDistribution": {
    "basic": 8,
    "intermediate": 8,
    "advanced": 4
  },
  "questions": [
    { /* question 1 */ },
    { /* question 2 */ },
    // ... 15-20 questions total
  ]
}
```

---

## QUALITY CHECKLIST

Before submitting, verify:
- [ ] All YouTube videos are accessible and not region-blocked
- [ ] Video metadata is complete (all required fields filled)
- [ ] Readiness questions test PREREQUISITES, not new content
- [ ] Practice questions have progressive difficulty
- [ ] All questions have clear explanations
- [ ] Every question links to 1-2 relevant videos
- [ ] JSON syntax is valid (no trailing commas, proper escaping)
- [ ] Content is age-appropriate for Grade [4/5] students
- [ ] Aligned with CBSE/NCERT curriculum

Please generate the complete content package now.
```

---

## PROMPT TEMPLATE 5: Video Recommendation Algorithm

### Usage
Use this to create the recommendation logic for a specific topic.

### Prompt:

```
Create a video recommendation algorithm for the following topic:

**Topic**: [Topic Name]
**Grade**: [4 or 5]
**Chapter**: [Chapter Number and Name]

**Available Videos**: [List video IDs and their types/difficulty]
**Readiness Questions**: [List question IDs and concepts they test]

**REQUIREMENTS**:

Define recommendation rules based on:
1. Readiness quiz score (0-100%)
2. Specific wrong answers (identify weak concepts)
3. Student's learning pace (slow/medium/fast)
4. Language preference (English/Hindi)

**OUTPUT FORMAT**:

```javascript
const recommendationRules = {
  topicId: "gr[X]_m_[Y]_[Z]",

  // Score-based baseline recommendations
  scoreRanges: [
    {
      range: [0, 50],
      recommendationType: "prerequisite_focus",
      videoTypes: ["prerequisite_review", "basic_concept"],
      maxVideos: 5,
      description: "Student needs foundation building"
    },
    {
      range: [50, 79],
      recommendationType: "concept_reinforcement",
      videoTypes: ["concept_introduction", "worked_examples"],
      maxVideos: 6,
      description: "Student has partial readiness"
    },
    {
      range: [80, 100],
      recommendationType: "standard_learning",
      videoTypes: ["concept_introduction", "worked_examples", "real_world"],
      maxVideos: 7,
      description: "Student is ready to learn"
    }
  ],

  // Concept-specific remediation
  conceptRemediation: {
    "concept_name_1": {
      weakSignal: ["rq1", "rq3"],  // Question IDs that indicate weakness
      recommendVideos: ["v2", "v5"],  // Videos that address this
      difficulty: "basic"
    },
    "concept_name_2": {
      weakSignal: ["rq4", "rq7"],
      recommendVideos: ["v3", "v6"],
      difficulty: "intermediate"
    }
  },

  // Playlist generation logic
  playlistGenerator: {
    alwaysInclude: ["v1"],  // Mandatory intro video
    adaptiveSelection: {
      ifWeak: ["v2", "v3", "v4"],  // Extra support videos
      ifStrong: ["v7", "v8"]  // Challenge videos
    },
    sequencing: "difficulty_ascending"  // Order videos by difficulty
  }
};
```

Please create the complete recommendation algorithm for this topic.
```

---

## EXAMPLE: Complete Workflow for One Topic

### Topic: "Place Value" (Grade 4, Chapter 4)

**Step 1**: Use PROMPT TEMPLATE 1 to curate 7 videos
**Step 2**: Use PROMPT TEMPLATE 2 to create 10 readiness questions
**Step 3**: Use PROMPT TEMPLATE 3 to create 18 practice questions
**Step 4**: Use PROMPT TEMPLATE 5 to create recommendation algorithm
**Step 5**: Test with sample student data
**Step 6**: Refine based on results

---

## Quick Reference: Prompt Selector

| Need | Use Template | Expected Output |
|------|--------------|-----------------|
| Find videos only | Template 1 | 6-8 video JSON objects |
| Create readiness quiz | Template 2 | 8-10 readiness question JSON |
| Create practice quiz | Template 3 | 15-20 practice question JSON |
| Complete topic package | Template 4 | 3 complete JSON files |
| Recommendation logic | Template 5 | JavaScript algorithm |

---

## Tips for Best Results

1. **Be Specific**: Always provide exact chapter numbers, topic names, and learning objectives
2. **Verify Output**: Always check YouTube links work before adding to database
3. **Iterate**: Start with one topic, test, refine prompts, then scale
4. **Cross-Reference**: Ensure readiness questions align with practice questions
5. **Student-Test**: Have actual Grade 4/5 students try the content
6. **Update Regularly**: YouTube videos get deleted; plan for quarterly reviews

---

## Document End

For questions or improvements to these prompts, refer to:
- Main strategy document: `MATHEMATICS_CONTENT_STRATEGY_GRADE_4_5.md`
- JSON schema files in: `assets/data/content/`
