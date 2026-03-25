/// Sample phonogram data for development, testing, and previewing.
///
/// Provides a fully populated SH phonogram with all difficulty levels,
/// age-adaptive explanations, breakdowns, and spelling notes.
///
/// Usage:
///   final sh = PhonogramSampleData.sh;
///   PhonogramDetailCard(phonogram: sh)
library;

import 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';

class PhonogramSampleData {
  PhonogramSampleData._();

  /// Fully populated SH phonogram — a letter team with one sound
  static const sh = Phonogram(
    id: 'sh',
    letters: 'SH',
    category: PhonogramCategory.team,
    sequenceNumber: 27,
    mastery: 0.65,
    sounds: [
      PhonogramSound(
        id: 'sh_1',
        notation: '/sh/',
        frequency: 'only sound',
        explanations: {
          AgeLevel.tiny: 'Say "shhh" like you are telling a secret!',
          AgeLevel.starter: 'S and H work together to make the "shh" sound.',
          AgeLevel.explorer:
              'SH is a letter team. When S and H appear together, they make the /sh/ sound instead of their individual sounds.',
          AgeLevel.master:
              'SH is a consonant digraph producing the voiceless postalveolar fricative /sh/. It appears in initial, medial, and final positions.',
        },
        easyWords: [
          PhonogramWord(
            word: 'SHIP',
            emoji: '\u{1F6A2}',
            phonogramLetters: 'SH',
            highlightStart: 0,
            highlightLength: 2,
            breakdown: ['SH', 'I', 'P'],
            meanings: {
              AgeLevel.tiny: 'A big boat!',
              AgeLevel.starter: 'A large boat that sails on the sea.',
              AgeLevel.explorer: 'A large vessel for traveling on water.',
              AgeLevel.master: 'A large seagoing vessel; also used as a verb meaning to transport.',
            },
            sentence: 'The ship sailed across the ocean.',
            spellingNote: 'SH at the start makes the word begin with the /sh/ sound.',
          ),
          PhonogramWord(
            word: 'SHOP',
            emoji: '\u{1F6CD}',
            phonogramLetters: 'SH',
            highlightStart: 0,
            highlightLength: 2,
            breakdown: ['SH', 'O', 'P'],
            meanings: {
              AgeLevel.tiny: 'Where you buy things!',
              AgeLevel.starter: 'A place where you buy things.',
              AgeLevel.explorer: 'A store or the act of buying goods.',
              AgeLevel.master: 'A retail establishment; also a verb meaning to browse for purchases.',
            },
            sentence: 'We went to the shop to buy fruit.',
            spellingNote: 'Just like SHIP, the SH team starts the word.',
          ),
          PhonogramWord(
            word: 'SHUT',
            emoji: '\u{1F6AA}',
            phonogramLetters: 'SH',
            highlightStart: 0,
            highlightLength: 2,
            breakdown: ['SH', 'U', 'T'],
            meanings: {
              AgeLevel.tiny: 'Close it!',
              AgeLevel.starter: 'To close something, like a door.',
              AgeLevel.explorer: 'To close; to move a door or lid into a closed position.',
              AgeLevel.master: 'To move into a closed position; to block off.',
            },
            sentence: 'Please shut the door quietly.',
          ),
          PhonogramWord(
            word: 'FISH',
            emoji: '\u{1F41F}',
            phonogramLetters: 'SH',
            highlightStart: 2,
            highlightLength: 2,
            breakdown: ['F', 'I', 'SH'],
            meanings: {
              AgeLevel.tiny: 'Swims in water!',
              AgeLevel.starter: 'An animal that lives in water.',
              AgeLevel.explorer: 'A cold-blooded aquatic vertebrate with fins and gills.',
              AgeLevel.master: 'Any of various aquatic vertebrates; also a verb meaning to catch fish.',
            },
            sentence: 'The fish swam in the pond.',
            spellingNote: 'SH at the END of a word. English words do not end in just S-H separately when making this sound.',
          ),
          PhonogramWord(
            word: 'WISH',
            emoji: '\u{2B50}',
            phonogramLetters: 'SH',
            highlightStart: 2,
            highlightLength: 2,
            breakdown: ['W', 'I', 'SH'],
            meanings: {
              AgeLevel.tiny: 'Make a wish!',
              AgeLevel.starter: 'Something you hope for.',
              AgeLevel.explorer: 'A desire or hope for something to happen.',
              AgeLevel.master: 'A desire for something; to feel or express a strong hope.',
            },
            sentence: 'I wish upon a star every night.',
          ),
          PhonogramWord(
            word: 'SHELL',
            emoji: '\u{1F41A}',
            phonogramLetters: 'SH',
            highlightStart: 0,
            highlightLength: 2,
            breakdown: ['SH', 'E', 'LL'],
            meanings: {
              AgeLevel.tiny: 'From the beach!',
              AgeLevel.starter: 'The hard cover on a snail or on the beach.',
              AgeLevel.explorer: 'A hard outer covering of an animal or egg.',
              AgeLevel.master: 'A rigid outer covering; the exoskeleton of a mollusk.',
            },
            sentence: 'She found a beautiful shell on the beach.',
            spellingNote: 'Notice the double L at the end. English words use LL after a single short vowel.',
          ),
        ],
        moreWords: [
          PhonogramWord(
            word: 'SHOUT',
            emoji: '\u{1F4E2}',
            phonogramLetters: 'SH',
            highlightStart: 0,
            highlightLength: 2,
            breakdown: ['SH', 'OU', 'T'],
            meanings: {
              AgeLevel.starter: 'To say something very loudly.',
              AgeLevel.explorer: 'To speak or cry out loudly.',
              AgeLevel.master: 'To utter a sudden, loud cry; to exclaim vehemently.',
            },
            sentence: 'Do not shout in the library.',
            spellingNote: 'OU is another letter team inside this word! Two teams in one word.',
          ),
          PhonogramWord(
            word: 'SHAKE',
            emoji: '\u{1F91D}',
            phonogramLetters: 'SH',
            highlightStart: 0,
            highlightLength: 2,
            breakdown: ['SH', 'A', 'K', 'E'],
            meanings: {
              AgeLevel.starter: 'To move quickly back and forth.',
              AgeLevel.explorer: 'To tremble or vibrate; to move something back and forth.',
              AgeLevel.master: 'To move with quick, short movements; the silent E makes the A say its name.',
            },
            sentence: 'Shake the bottle before you pour.',
            spellingNote: 'The silent E at the end makes the A say its name (/ay/).',
          ),
          PhonogramWord(
            word: 'FISHER',
            emoji: '\u{1F3A3}',
            phonogramLetters: 'SH',
            highlightStart: 2,
            highlightLength: 2,
            breakdown: ['F', 'I', 'SH', 'ER'],
            meanings: {
              AgeLevel.starter: 'Someone who catches fish.',
              AgeLevel.explorer: 'A person who fishes; also a type of animal.',
              AgeLevel.master: 'One who fishes; also refers to the fisher cat, a North American mammal.',
            },
            sentence: 'The fisher waited patiently by the river.',
            spellingNote: 'SH appears in the MIDDLE of this word. ER is a suffix meaning "one who does."',
          ),
          PhonogramWord(
            word: 'SPLASH',
            emoji: '\u{1F4A6}',
            phonogramLetters: 'SH',
            highlightStart: 5,
            highlightLength: 2,
            breakdown: ['S', 'P', 'L', 'A', 'SH'],
            meanings: {
              AgeLevel.starter: 'Water flying everywhere!',
              AgeLevel.explorer: 'To scatter liquid; the sound water makes when disturbed.',
              AgeLevel.master: 'To dash a liquid about; an initial consonant cluster SPL- with the SH team at the end.',
            },
            sentence: 'The kids love to splash in the puddles.',
            spellingNote: 'SPL is a three-letter blend at the start. SH team finishes the word.',
          ),
        ],
        challengeWords: [
          PhonogramWord(
            word: 'ESTABLISH',
            emoji: '\u{1F3D7}',
            phonogramLetters: 'SH',
            highlightStart: 8,
            highlightLength: 2,
            breakdown: ['E', 'S', 'T', 'A', 'B', 'L', 'I', 'SH'],
            meanings: {
              AgeLevel.explorer: 'To set up or create something permanent.',
              AgeLevel.master: 'To found, institute, or bring into being on a firm basis.',
            },
            sentence: 'They worked hard to establish the new school.',
            spellingNote: 'A four-syllable word. The SH team is at the very end.',
          ),
          PhonogramWord(
            word: 'SHEPHERD',
            emoji: '\u{1F411}',
            phonogramLetters: 'SH',
            highlightStart: 0,
            highlightLength: 2,
            breakdown: ['SH', 'E', 'P', 'H', 'ER', 'D'],
            meanings: {
              AgeLevel.explorer: 'A person who takes care of sheep.',
              AgeLevel.master: 'One who tends sheep; from Old English "sceaphierde" (sheep herder).',
            },
            sentence: 'The shepherd guided the flock over the hill.',
            spellingNote: 'The PH in the middle is NOT the PH team here. The word comes from "sheep" + "herd."',
          ),
          PhonogramWord(
            word: 'DISHONEST',
            emoji: '\u{1F925}',
            phonogramLetters: 'SH',
            highlightStart: 2,
            highlightLength: 2,
            breakdown: ['D', 'I', 'SH', 'O', 'N', 'E', 'S', 'T'],
            meanings: {
              AgeLevel.explorer: 'Not honest; not telling the truth.',
              AgeLevel.master: 'Behaving or prone to behave in an untrustworthy way. Prefix DIS- + HONEST.',
            },
            sentence: 'It is wrong to be dishonest with your friends.',
            spellingNote: 'DIS- is a prefix meaning "not." The SH sits right where the prefix meets the root word.',
          ),
        ],
      ),
    ],
  );

  /// Phonogram A — a vowel with 3 sounds, for testing multi-sound selector
  static const a = Phonogram(
    id: 'a',
    letters: 'A',
    category: PhonogramCategory.vowel,
    sequenceNumber: 1,
    mastery: 0.42,
    sounds: [
      PhonogramSound(
        id: 'a_1',
        notation: '/a/ as in apple',
        frequency: 'most common',
        explanations: {
          AgeLevel.tiny: 'A says /a/ like in apple!',
          AgeLevel.starter: 'The short sound of A, like the start of "apple."',
          AgeLevel.explorer: 'The short vowel sound /a/ is the most common sound of the letter A.',
          AgeLevel.master: 'The short vowel /a/ (near-open front unrounded vowel) is A\'s primary sound in closed syllables.',
        },
        easyWords: [
          PhonogramWord(
            word: 'CAT',
            emoji: '\u{1F431}',
            phonogramLetters: 'A',
            highlightStart: 1,
            highlightLength: 1,
            breakdown: ['C', 'A', 'T'],
            meanings: {
              AgeLevel.tiny: 'Meow!',
              AgeLevel.starter: 'A furry pet that says meow.',
              AgeLevel.explorer: 'A small domesticated carnivorous mammal.',
              AgeLevel.master: 'A domesticated feline; one of the most popular pets worldwide.',
            },
            sentence: 'The cat sat on the mat.',
            spellingNote: 'A simple CVC (consonant-vowel-consonant) word. A says /a/ because it is in a closed syllable.',
          ),
          PhonogramWord(
            word: 'HAT',
            emoji: '\u{1F3A9}',
            phonogramLetters: 'A',
            highlightStart: 1,
            highlightLength: 1,
            breakdown: ['H', 'A', 'T'],
            meanings: {
              AgeLevel.tiny: 'Goes on your head!',
              AgeLevel.starter: 'Something you wear on your head.',
              AgeLevel.explorer: 'A covering for the head.',
              AgeLevel.master: 'A shaped covering for the head, worn for warmth, fashion, or ceremonial purposes.',
            },
            sentence: 'She wore a red hat to the party.',
          ),
          PhonogramWord(
            word: 'MAP',
            emoji: '\u{1F5FA}',
            phonogramLetters: 'A',
            highlightStart: 1,
            highlightLength: 1,
            breakdown: ['M', 'A', 'P'],
            meanings: {
              AgeLevel.tiny: 'Shows where to go!',
              AgeLevel.starter: 'A picture that shows places and roads.',
              AgeLevel.explorer: 'A representation of an area showing features and locations.',
              AgeLevel.master: 'A diagrammatic representation of an area of land or sea.',
            },
            sentence: 'We used a map to find the treasure.',
          ),
        ],
      ),
      PhonogramSound(
        id: 'a_2',
        notation: '/ay/ as in cake',
        frequency: 'common',
        explanations: {
          AgeLevel.tiny: 'A says its name! Like in "cake!"',
          AgeLevel.starter: 'Sometimes A says its own name, like in "cake" and "lake."',
          AgeLevel.explorer: 'The long sound of A (/ay/) occurs in open syllables and with silent E.',
          AgeLevel.master: 'The long vowel /ay/ (close-mid front unrounded vowel) appears in open syllables, VCE patterns, and certain vowel teams.',
        },
        easyWords: [
          PhonogramWord(
            word: 'CAKE',
            emoji: '\u{1F382}',
            phonogramLetters: 'A',
            highlightStart: 1,
            highlightLength: 1,
            breakdown: ['C', 'A', 'K', 'E'],
            meanings: {
              AgeLevel.tiny: 'Yummy birthday treat!',
              AgeLevel.starter: 'A sweet baked treat, often for birthdays.',
              AgeLevel.explorer: 'A sweet baked dessert made from flour, sugar, and eggs.',
              AgeLevel.master: 'A baked confection; the silent E makes A say its long sound.',
            },
            sentence: 'We baked a chocolate cake.',
            spellingNote: 'The silent E at the end makes A say its name (/ay/). This is the VCE pattern.',
          ),
          PhonogramWord(
            word: 'LAKE',
            emoji: '\u{1F30A}',
            phonogramLetters: 'A',
            highlightStart: 1,
            highlightLength: 1,
            breakdown: ['L', 'A', 'K', 'E'],
            meanings: {
              AgeLevel.tiny: 'Big water!',
              AgeLevel.starter: 'A big area of water with land all around it.',
              AgeLevel.explorer: 'A large body of water surrounded by land.',
              AgeLevel.master: 'An inland body of standing water; follows VCE pattern.',
            },
            sentence: 'We swam in the cool lake.',
          ),
        ],
      ),
      PhonogramSound(
        id: 'a_3',
        notation: '/ah/ as in father',
        frequency: 'less common',
        explanations: {
          AgeLevel.tiny: 'A says "ah" like when the doctor checks!',
          AgeLevel.starter: 'Sometimes A makes the "ah" sound, like in "father."',
          AgeLevel.explorer: 'The third sound of A (/ah/) appears in words like "father" and "calm."',
          AgeLevel.master: 'The open back unrounded vowel /ah/ is A\'s third sound, common in words of Latin, French, and Italian origin.',
        },
        easyWords: [
          PhonogramWord(
            word: 'CALM',
            emoji: '\u{1F60C}',
            phonogramLetters: 'A',
            highlightStart: 1,
            highlightLength: 1,
            breakdown: ['C', 'A', 'L', 'M'],
            meanings: {
              AgeLevel.tiny: 'Quiet and still.',
              AgeLevel.starter: 'Being quiet and peaceful.',
              AgeLevel.explorer: 'Not showing or feeling nervousness, anger, or other strong emotions.',
              AgeLevel.master: 'Tranquil; the L is silent in this word.',
            },
            sentence: 'The sea was calm in the morning.',
            spellingNote: 'The L is silent! We say "cahm" not "cal-m."',
          ),
        ],
      ),
    ],
  );

  /// All sample phonograms for collection/testing
  static const List<Phonogram> all = [a, sh];
}
