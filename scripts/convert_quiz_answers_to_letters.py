#!/usr/bin/env python3
"""
Script to convert all quiz JSON files to use letter format (A, B, C, D) for correctAnswer.

Handles two formats:
1. Numeric index: "correctAnswer": 1 → "correctAnswer": "B"
2. Text string: "correctAnswer": "Acceleration" → "correctAnswer": "B"

Usage:
    python3 scripts/convert_quiz_answers_to_letters.py
"""

import json
import os
from pathlib import Path
import sys

def convert_correct_answer_to_letter(question):
    """Convert correctAnswer to letter format (A, B, C, D)."""
    correct_answer = question.get('correctAnswer')
    options = question.get('options', [])

    if not options:
        print(f"  ⚠️  Warning: Question '{question.get('id', 'unknown')}' has no options")
        return question

    # Case 1: Already a single letter (A-Z)
    if isinstance(correct_answer, str) and len(correct_answer) == 1 and correct_answer.upper().isalpha():
        question['correctAnswer'] = correct_answer.upper()
        return question

    # Case 2: Numeric index
    if isinstance(correct_answer, int):
        if 0 <= correct_answer < len(options):
            question['correctAnswer'] = chr(65 + correct_answer)  # 0->A, 1->B, etc.
            print(f"    Converted: index {correct_answer} → {question['correctAnswer']}")
            return question
        else:
            print(f"  ⚠️  Warning: Index {correct_answer} out of bounds for {len(options)} options")
            return question

    # Case 3: Text string - find matching option
    if isinstance(correct_answer, str):
        answer_text = correct_answer.strip().lower()

        for i, option in enumerate(options):
            option_text = str(option).strip().lower()
            if option_text == answer_text:
                old_answer = correct_answer
                question['correctAnswer'] = chr(65 + i)  # Convert to letter
                print(f"    Converted: '{old_answer}' → {question['correctAnswer']}")
                return question

        # No match found - might already be a letter or invalid
        if len(correct_answer) == 1 and correct_answer.upper().isalpha():
            question['correctAnswer'] = correct_answer.upper()
        else:
            print(f"  ⚠️  Warning: Could not match '{correct_answer}' to any option")

    return question

def convert_quiz_file(file_path):
    """Convert a single quiz JSON file to letter format."""
    print(f"\n📄 Processing: {file_path}")

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # Handle both single quiz and quiz with questions array
        if 'questions' in data:
            questions = data['questions']
        elif isinstance(data, list):
            questions = data
        else:
            print(f"  ⚠️  Warning: Unexpected JSON structure")
            return False

        converted_count = 0
        for question in questions:
            old_answer = question.get('correctAnswer')
            convert_correct_answer_to_letter(question)
            new_answer = question.get('correctAnswer')

            if old_answer != new_answer:
                converted_count += 1

        # Write back to file with proper formatting
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        if converted_count > 0:
            print(f"  ✅ Converted {converted_count} questions")
        else:
            print(f"  ℹ️  No conversions needed")

        return True

    except Exception as e:
        print(f"  ❌ Error: {e}")
        return False

def find_quiz_files(base_dir):
    """Find all quiz JSON files in the assets/data/quizzes directory."""
    quiz_dir = Path(base_dir) / 'assets' / 'data' / 'quizzes'

    if not quiz_dir.exists():
        print(f"❌ Quiz directory not found: {quiz_dir}")
        return []

    # Find all JSON files recursively
    json_files = list(quiz_dir.rglob('*.json'))
    print(f"\n🔍 Found {len(json_files)} JSON files in {quiz_dir}")

    return json_files

def main():
    """Main function to convert all quiz files."""
    print("=" * 60)
    print("Quiz Answer Format Converter")
    print("Converting all answers to letter format (A, B, C, D)")
    print("=" * 60)

    # Get project root (assuming script is in scripts/ directory)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent

    print(f"\n📁 Project root: {project_root}")

    # Find all quiz files
    quiz_files = find_quiz_files(project_root)

    if not quiz_files:
        print("\n❌ No quiz files found!")
        sys.exit(1)

    # Convert each file
    success_count = 0
    failure_count = 0

    for quiz_file in quiz_files:
        if convert_quiz_file(quiz_file):
            success_count += 1
        else:
            failure_count += 1

    # Summary
    print("\n" + "=" * 60)
    print("Conversion Summary")
    print("=" * 60)
    print(f"✅ Successfully converted: {success_count} files")
    print(f"❌ Failed: {failure_count} files")
    print(f"📊 Total processed: {len(quiz_files)} files")
    print("=" * 60)

    if failure_count > 0:
        print("\n⚠️  Some files failed to convert. Please review the errors above.")
        sys.exit(1)
    else:
        print("\n🎉 All files converted successfully!")
        print("\nNext steps:")
        print("1. Review the changes: git diff assets/data/quizzes/")
        print("2. Test the quiz functionality")
        print("3. Simplify QuestionModel.fromJson() code")

if __name__ == '__main__':
    main()
