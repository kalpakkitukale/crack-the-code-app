"""
Generate all audio files for Crack the Code app.
Uses edge-tts (Microsoft Neural TTS) for high-quality pronunciation.
Converts to OGG Vorbis for smallest file size.
"""
import asyncio
import json
import os
import subprocess
import edge_tts

# Voices
EN_VOICE = "en-IN-NeerjaExpressiveNeural"  # Indian English, expressive, great for kids
HI_VOICE = "hi-IN-SwaraNeural"             # Hindi female
MR_VOICE = "mr-IN-AarohiNeural"            # Marathi female

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AUDIO_DIR = os.path.join(BASE_DIR, "assets", "audio")
DATA_DIR = os.path.join(BASE_DIR, "assets", "data")

async def generate_audio(text, output_path, voice=EN_VOICE, rate="-10%"):
    """Generate audio file using edge-tts, convert to OGG."""
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    mp3_path = output_path.replace('.ogg', '.mp3')

    communicate = edge_tts.Communicate(text, voice, rate=rate)
    await communicate.save(mp3_path)

    # Convert MP3 to OGG Vorbis
    subprocess.run([
        'ffmpeg', '-y', '-i', mp3_path,
        '-c:a', 'libvorbis', '-q:a', '3',
        output_path
    ], capture_output=True)

    # Remove MP3
    if os.path.exists(output_path):
        os.remove(mp3_path)
    else:
        # If OGG conversion failed, keep MP3
        os.rename(mp3_path, output_path.replace('.ogg', '.mp3'))
        print(f"  Warning: kept as MP3: {output_path}")

async def generate_phonogram_audio():
    """Generate audio for all 112 phonogram sounds."""
    print("=== Generating Phonogram Audio ===")

    with open(os.path.join(DATA_DIR, "phonograms.json"), 'r') as f:
        phonograms = json.load(f)

    count = 0
    for phonogram in phonograms:
        for sound in phonogram.get('sounds', []):
            sound_id = sound['soundId']
            notation = sound['notation'].replace('/', '')
            example_words = sound.get('exampleWords', [])

            # Build pronunciation text
            if example_words:
                first_word = example_words[0]['word'] if isinstance(example_words[0], dict) else example_words[0]
                text = f"{notation}. As in {first_word}."
            else:
                text = f"{notation}."

            output_path = os.path.join(AUDIO_DIR, "phonograms", f"{sound_id}.ogg")

            if not os.path.exists(output_path):
                print(f"  Generating: {sound_id} ({phonogram['text']} = {notation})")
                await generate_audio(text, output_path, rate="-20%")
                count += 1
            else:
                print(f"  Exists: {sound_id}")

    print(f"Generated {count} phonogram audio files")

async def generate_word_audio():
    """Generate audio for words."""
    print("\n=== Generating Word Audio ===")

    with open(os.path.join(DATA_DIR, "words.json"), 'r') as f:
        words = json.load(f)

    # Also collect words from phonogram example words
    with open(os.path.join(DATA_DIR, "phonograms.json"), 'r') as f:
        phonograms = json.load(f)

    all_words = set()

    # From words.json
    for w in words:
        all_words.add(w['word'].upper())

    # From phonogram example words
    for p in phonograms:
        for s in p.get('sounds', []):
            for ew in s.get('exampleWords', []):
                if isinstance(ew, dict):
                    all_words.add(ew['word'].upper())
                else:
                    all_words.add(str(ew).upper())
        for dw in p.get('detailWords', []):
            if isinstance(dw, dict):
                all_words.add(dw.get('word', '').upper())
            else:
                all_words.add(str(dw).upper())

    count = 0
    for word in sorted(all_words):
        if not word:
            continue
        output_path = os.path.join(AUDIO_DIR, "words", f"{word.lower()}.ogg")

        if not os.path.exists(output_path):
            print(f"  Generating: {word}")
            await generate_audio(word, output_path, rate="-15%")
            count += 1

    print(f"Generated {count} word audio files")

async def generate_hindi_audio():
    """Generate Hindi pronunciation audio."""
    print("\n=== Generating Hindi Audio ===")

    with open(os.path.join(DATA_DIR, "phonograms.json"), 'r') as f:
        phonograms = json.load(f)

    count = 0
    for phonogram in phonograms:
        for sound in phonogram.get('sounds', []):
            sound_id = sound['soundId']
            hindi_text = sound.get('hindiText', '')

            if not hindi_text:
                continue

            output_path = os.path.join(AUDIO_DIR, "hindi", f"{sound_id}.ogg")

            if not os.path.exists(output_path):
                print(f"  Generating Hindi: {sound_id} ({hindi_text})")
                await generate_audio(hindi_text, output_path, voice=HI_VOICE, rate="-15%")
                count += 1

    print(f"Generated {count} Hindi audio files")

async def generate_marathi_audio():
    """Generate Marathi pronunciation audio."""
    print("\n=== Generating Marathi Audio ===")

    with open(os.path.join(DATA_DIR, "phonograms.json"), 'r') as f:
        phonograms = json.load(f)

    count = 0
    for phonogram in phonograms:
        for sound in phonogram.get('sounds', []):
            sound_id = sound['soundId']
            marathi_text = sound.get('marathiText', '')

            if not marathi_text:
                continue

            output_path = os.path.join(AUDIO_DIR, "marathi", f"{sound_id}.ogg")

            if not os.path.exists(output_path):
                print(f"  Generating Marathi: {sound_id} ({marathi_text})")
                await generate_audio(marathi_text, output_path, voice=MR_VOICE, rate="-15%")
                count += 1

    print(f"Generated {count} Marathi audio files")

async def generate_ui_sounds():
    """Generate UI sound effects using simple tones."""
    print("\n=== Generating UI Sounds ===")

    ui_sounds = {
        'tap': 'tap',
        'correct': 'correct! well done!',
        'wrong': 'try again',
        'celebration': 'amazing! great job!',
        'discovery': 'new sound discovered!',
    }

    count = 0
    for name, text in ui_sounds.items():
        output_path = os.path.join(AUDIO_DIR, "ui", f"{name}.ogg")

        if not os.path.exists(output_path):
            print(f"  Generating UI: {name}")
            await generate_audio(text, output_path, rate="-5%")
            count += 1

    print(f"Generated {count} UI audio files")

async def main():
    print("Crack the Code — Audio Generator")
    print(f"Output: {AUDIO_DIR}")
    print(f"English voice: {EN_VOICE}")
    print(f"Hindi voice: {HI_VOICE}")
    print(f"Marathi voice: {MR_VOICE}")
    print()

    await generate_phonogram_audio()
    await generate_word_audio()
    await generate_hindi_audio()
    await generate_marathi_audio()
    await generate_ui_sounds()

    # Count total files
    total = 0
    total_size = 0
    for root, dirs, files in os.walk(AUDIO_DIR):
        for f in files:
            if f.endswith('.ogg') or f.endswith('.mp3'):
                total += 1
                total_size += os.path.getsize(os.path.join(root, f))

    print(f"\n=== DONE ===")
    print(f"Total audio files: {total}")
    print(f"Total size: {total_size / 1024 / 1024:.1f} MB")

if __name__ == "__main__":
    asyncio.run(main())
