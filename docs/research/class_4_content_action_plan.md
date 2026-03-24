# Class 4 Content Action Plan

## Priority Matrix

### HIGH PRIORITY (Weeks 1-4)

| # | Task | Subject | Details | Status |
|---|------|---------|---------|--------|
| 1 | Restructure Math chapters | Mathematics | Align 5 existing chapters to NCERT naming | [ ] |
| 2 | Add 9 missing Math chapters | Mathematics | Ch 1-5, 7, 8, 12, 14 | [ ] |
| 3 | Source Math videos | Mathematics | ~170 videos total | [ ] |
| 4 | Create Math study tools | Mathematics | Summaries, flashcards, quizzes | [ ] |
| 5 | Add priority EVS chapters | EVS | Ch 1, 3, 4, 13, 14, 18, 21 | [ ] |
| 6 | Source EVS videos | EVS | ~70 videos for priority chapters | [ ] |

### MEDIUM PRIORITY (Weeks 5-8)

| # | Task | Subject | Details | Status |
|---|------|---------|---------|--------|
| 7 | Add remaining EVS chapters | EVS | Remaining 20 chapters | [ ] |
| 8 | Source remaining EVS videos | EVS | ~150 videos | [ ] |
| 9 | Add English stories | English | 9 Marigold stories | [ ] |
| 10 | Add English poems | English | 10 Marigold poems | [ ] |
| 11 | Expand English grammar | English | Full grammar curriculum | [ ] |
| 12 | Source English videos | English | ~150 videos | [ ] |

### LOWER PRIORITY (Weeks 9-12)

| # | Task | Subject | Details | Status |
|---|------|---------|---------|--------|
| 13 | Add Hindi chapters | Hindi | 14 Rimjhim chapters | [ ] |
| 14 | Complete Hindi grammar | Hindi | Full grammar | [ ] |
| 15 | Source Hindi videos | Hindi | ~110 videos | [ ] |
| 16 | Create all study tools | All | Complete study tools for all | [ ] |
| 17 | Create assessments | All | Pre-assessments, quizzes, tests | [ ] |
| 18 | Quality review | All | Review all content | [ ] |

---

## Detailed Task Breakdown

### Task 1: Restructure Mathematics Chapters

**Current Structure:**
```
1. Large Numbers
2. Addition and Subtraction
3. Multiplication and Division
4. Fractions
5. Geometry
```

**Target NCERT Structure:**
```
1. Building with Bricks
2. Long and Short
3. A Trip to Bhopal
4. Tick-Tick-Tick
5. The Way The World Looks
6. The Junk Seller
7. Jugs and Mugs
8. Carts and Wheels
9. Halves and Quarters
10. Play with Patterns
11. Tables and Shares
12. How Heavy? How Light?
13. Fields and Fences
14. Smart Charts
```

**Mapping Required:**
| Current Content | Can Map To NCERT Chapter |
|-----------------|-------------------------|
| Large Numbers (place value) | Ch 10: Play with Patterns (partial) |
| Addition/Subtraction | Ch 6: The Junk Seller (partial) |
| Multiplication/Division | Ch 11: Tables and Shares (partial) |
| Fractions | Ch 9: Halves and Quarters |
| Geometry | Ch 8, 13: Carts/Wheels, Fields/Fences |

**Action Items:**
1. Create new JSON: `mathematics_gr4_ncert.json`
2. Keep existing for backward compatibility
3. Create migration script if needed
4. Update all related video files

---

### Task 2: Add Missing Math Chapters

**Chapters to Create:**

| Chapter | Topics | Videos Est. |
|---------|--------|-------------|
| Building with Bricks | 3D shapes, patterns, estimation | 11 |
| Long and Short | Length, units, comparison | 13 |
| A Trip to Bhopal | Distance, maps, kilometers | 12 |
| Tick-Tick-Tick | Time, clocks, calendar | 17 |
| The Way The World Looks | Maps, directions, perspective | 9 |
| Jugs and Mugs | Capacity, liters, milliliters | 13 |
| Carts and Wheels | Circles, curves | 11 |
| How Heavy? How Light? | Weight, grams, kilograms | 16 |
| Smart Charts | Data, pictographs, bar graphs | 17 |

---

### Task 5: Priority EVS Chapters

**Phase 1 Chapters:**

| Ch # | Name | Why Priority | Topics |
|------|------|--------------|--------|
| 1 | Going to School | Introduction chapter | Transport, school types |
| 3 | A Day with Nandu | Animals - key topic | Elephants, wildlife |
| 4 | Story of Amrita | Environment - key topic | Trees, conservation |
| 13 | A River's Tale | Water - key topic | Rivers, pollution |
| 14 | Basva's Farm | Agriculture - key topic | Farming, crops |
| 18 | Too Much/Little Water | Water management | Floods, droughts |
| 21 | Food and Fun | Nutrition - key topic | Healthy eating |

---

## Content Creation Templates

### Subject JSON Template

```json
{
  "id": "mathematics_gr4_ncert",
  "name": "Mathematics",
  "icon": "calculate",
  "color": "#4ECDC4",
  "boardId": "cbse_elementary",
  "classId": "class_4",
  "streamId": "general",
  "textbook": "Math-Magic (NCERT)",
  "totalChapters": 14,
  "keywords": ["mathematics", "grade 4", "ncert", "cbse", "class 4 maths"],
  "chapters": [
    {
      "id": "gr4_math_ncert_ch1",
      "number": 1,
      "name": "Building with Bricks",
      "ncertName": "Building with Bricks",
      "description": "Learn about 3D shapes and patterns using bricks",
      "keywords": ["3D shapes", "bricks", "patterns", "estimation"],
      "pageRange": "1-12",
      "topics": [
        {
          "id": "gr4_m_n1_1",
          "name": "Introduction to 3D Shapes",
          "difficulty": "basic",
          "videoCount": 3,
          "keywords": ["3D shapes", "cube", "cuboid"]
        }
      ]
    }
  ]
}
```

### Video JSON Template

```json
{
  "chapterId": "gr4_math_ncert_ch1",
  "chapterName": "Building with Bricks",
  "subjectId": "mathematics_gr4_ncert",
  "ncertChapter": 1,
  "videos": [
    {
      "id": "gr4_mn1_v1",
      "title": "Building with Bricks - NCERT Class 4 Maths Chapter 1",
      "description": "Learn about 3D shapes and patterns using bricks. This video covers the complete NCERT chapter.",
      "youtubeId": "YOUTUBE_ID_HERE",
      "youtubeUrl": "https://www.youtube.com/watch?v=YOUTUBE_ID_HERE",
      "thumbnailUrl": "https://img.youtube.com/vi/YOUTUBE_ID_HERE/hqdefault.jpg",
      "duration": 720,
      "durationDisplay": "12:00",
      "channelName": "Magnet Brains",
      "channelId": "UCUZqyH0R12c1oy5DgjTx-tw",
      "language": "Hindi",
      "topicId": "gr4_m_n1_1",
      "difficulty": "basic",
      "examRelevance": ["CBSE"],
      "rating": 4.7,
      "viewCount": 500000,
      "tags": ["ncert", "class 4", "maths", "building with bricks", "3D shapes"],
      "ncertPage": "1-12",
      "dateAdded": "2026-02-27T00:00:00.000Z",
      "lastUpdated": "2026-02-27T00:00:00.000Z"
    }
  ]
}
```

---

## YouTube Search Queries Reference

### Mathematics

```
Class 4 Maths NCERT Chapter 1 Building with Bricks
Class 4 Maths Chapter 2 Long and Short
Class 4 Maths Chapter 3 A Trip to Bhopal
Class 4 Maths Chapter 4 Tick Tick Tick Time
Class 4 Maths Chapter 5 The Way The World Looks
Class 4 Maths Chapter 6 The Junk Seller Multiplication
Class 4 Maths Chapter 7 Jugs and Mugs Capacity
Class 4 Maths Chapter 8 Carts and Wheels Circles
Class 4 Maths Chapter 9 Halves and Quarters Fractions
Class 4 Maths Chapter 10 Play with Patterns
Class 4 Maths Chapter 11 Tables and Shares Division
Class 4 Maths Chapter 12 How Heavy How Light Weight
Class 4 Maths Chapter 13 Fields and Fences Area Perimeter
Class 4 Maths Chapter 14 Smart Charts Data Handling
```

### EVS

```
Class 4 EVS Chapter 1 Going to School
Class 4 EVS Chapter 3 A Day with Nandu Elephants
Class 4 EVS Chapter 4 The Story of Amrita Trees
Class 4 EVS Chapter 13 A River's Tale
Class 4 EVS Chapter 14 Basva's Farm Agriculture
Class 4 EVS Chapter 18 Too Much Water Too Little Water
Class 4 EVS Chapter 21 Food and Fun Nutrition
Class 4 EVS Looking Around NCERT
```

### English

```
Class 4 English Marigold Unit 1 Wake Up Neha's Alarm Clock
Class 4 English Marigold Unit 2 Noses The Little Fir Tree
Class 4 English Marigold Unit 3 Run Nasruddin's Aim
Class 4 English Marigold Unit 4 Why Alice in Wonderland
Class 4 English Marigold Unit 5 Helen Keller
Class 4 English Marigold Unit 6 Hiawatha Scholar's Mother Tongue
Class 4 English Marigold Unit 7 Giving Tree
Class 4 English Marigold Unit 8 Books Going to Buy a Book
Class 4 English Marigold Unit 9 Naughty Boy Pinocchio
Class 4 English Grammar Nouns Pronouns Verbs
```

### Hindi

```
Class 4 Hindi Rimjhim Chapter 1 Man Ke Bhole Bhale Badal
Class 4 Hindi Rimjhim Chapter 2 Jaisa Sawal Vaisa Jawab
Class 4 Hindi Rimjhim Chapter 3 Kirmich Ki Gend
Class 4 Hindi Rimjhim Chapter 4 Papa Jab Bachche The
Class 4 Hindi Rimjhim Chapter 5 Dost Ki Poshak
Class 4 Hindi Rimjhim Chapter 6 Nav Banao
Class 4 Hindi Rimjhim Chapter 7 Dan Ka Hisab
Class 4 Hindi Grammar Sangya Sarvanam Kriya
```

---

## Recommended YouTube Channels by Subject

### Mathematics
| Channel | Language | Quality | Subscribe Link |
|---------|----------|---------|----------------|
| Magnet Brains | Hindi | Excellent | youtube.com/@MagnetBrains |
| Khan Academy India | Hindi | Excellent | youtube.com/@KhanAcademyIndia |
| Math with Mr. J | English | Good | youtube.com/@MathwithMrJ |
| Scratch Garden | English | Good | youtube.com/@ScratchGarden |

### EVS
| Channel | Language | Quality | Subscribe Link |
|---------|----------|---------|----------------|
| Magnet Brains | Hindi | Excellent | youtube.com/@MagnetBrains |
| Pebbles Live | English | Good | youtube.com/@PebblesLive |
| Simsum Smart | Hindi | Good | youtube.com/@SimsumSmart |

### English
| Channel | Language | Quality | Subscribe Link |
|---------|----------|---------|----------------|
| Magnet Brains | English | Excellent | youtube.com/@MagnetBrains |
| English Bites | English | Good | youtube.com/@EnglishBites |
| Kids Academy | English | Good | youtube.com/@KidsAcademy |

### Hindi
| Channel | Language | Quality | Subscribe Link |
|---------|----------|---------|----------------|
| Magnet Brains | Hindi | Excellent | youtube.com/@MagnetBrains |
| Bodhaguru | Hindi | Good | youtube.com/@Bodhaguru |
| SuccessCDs Education | Hindi | Good | youtube.com/@SuccessCDs |

---

## Milestone Tracking

### Week 1-2: Mathematics Foundation
- [ ] Create new NCERT-aligned math subject JSON
- [ ] Create chapter structures for all 14 chapters
- [ ] Source videos for chapters 1-7
- [ ] Create topic breakdown for each chapter

### Week 3-4: Mathematics Completion
- [ ] Source videos for chapters 8-14
- [ ] Create study tools for all chapters
- [ ] Create assessments for all chapters
- [ ] Test content in app

### Week 5-6: EVS Foundation
- [ ] Create EVS subject JSON with 27 chapters
- [ ] Create topic breakdown for priority chapters
- [ ] Source videos for 7 priority chapters
- [ ] Create study tools for priority chapters

### Week 7-8: EVS Completion & English Start
- [ ] Source videos for remaining 20 EVS chapters
- [ ] Create English subject JSON with 9 units
- [ ] Add poems as additional content
- [ ] Source English story videos

### Week 9-10: English & Hindi
- [ ] Complete English grammar content
- [ ] Create Hindi subject JSON with 14 chapters
- [ ] Source Hindi story/poem videos
- [ ] Source Hindi grammar videos

### Week 11-12: Polish & Review
- [ ] Complete all study tools
- [ ] Create comprehensive assessments
- [ ] Quality review all content
- [ ] Test complete curriculum in app

---

## Success Metrics

| Metric | Target | Current |
|--------|--------|---------|
| Total Chapters | 74 | 16 |
| Total Videos | 650+ | ~50 |
| Study Tools Complete | 74 chapters | 1 chapter |
| Assessments | 74 chapters | 3 chapters |
| NCERT Alignment | 100% | ~20% |

---

*Document Created: February 2026*
*StreamShaala Educational Content Team*
