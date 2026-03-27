"""
Populate ALL 168 characters with easyWords and mediumWords.
Uses phonogram data from phonograms.json to find example words.
"""
import json
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(BASE, 'assets', 'data')

# Load existing data
with open(os.path.join(DATA, 'phonograms.json'), 'r') as f:
    phonograms = json.load(f)

with open(os.path.join(DATA, 'characters.json'), 'r') as f:
    characters = json.load(f)

# Build phonogram → words lookup
phon_words = {}  # phonogram text → list of words
for p in phonograms:
    text = p['text'].lower()
    words = set()
    for s in p.get('sounds', []):
        for ew in s.get('exampleWords', []):
            if isinstance(ew, dict):
                words.add(ew['word'])
            else:
                words.add(str(ew))
    for dw in p.get('detailWords', []):
        if isinstance(dw, dict):
            words.add(dw.get('word', ''))
        else:
            words.add(str(dw))
    phon_words[text] = sorted([w for w in words if w])

# Common words by sound for characters without phonogram matches
SOUND_WORDS = {
    "/b/": {"easy": ["BAT", "BIG", "BUS", "BED", "BOX", "BALL", "BIRD", "BOOK"], "medium": ["BASKET", "BRIDGE", "BROTHER", "BIRTHDAY", "BEAUTIFUL"]},
    "/d/": {"easy": ["DOG", "DIG", "DAD", "DID", "DAY", "DEN", "DIP", "DIM"], "medium": ["DEEP", "DREAM", "DRAGON", "DINNER", "DOCTOR"]},
    "/f/": {"easy": ["FISH", "FUN", "FAN", "FOX", "FIG", "FIT", "FAT", "FLY"], "medium": ["FAST", "LEAF", "LIFE", "GIFT", "FAMILY"]},
    "/g/": {"easy": ["GO", "GAME", "GIFT", "GOT", "GUM", "GAP", "GET", "GAS"], "medium": ["GRASS", "DRAGON", "GARDEN", "GOLDEN", "GRAPE"]},
    "/h/": {"easy": ["HAT", "HOP", "HEN", "HIT", "HOT", "HIM", "HUG", "HUT"], "medium": ["HOUSE", "HAPPY", "HEART", "HUNGRY", "HELLO"]},
    "/j/": {"easy": ["JAM", "JET", "JOB", "JUG", "JOY", "JAR", "JAW", "JOG"], "medium": ["JUICE", "JACKET", "JUNGLE", "JOURNEY", "GENTLE"]},
    "/k/": {"easy": ["CAT", "CUP", "KIT", "KEY", "COW", "CUT", "CAN", "CAR"], "medium": ["KITCHEN", "CAPTAIN", "CRYSTAL", "COUNTRY", "CASTLE"]},
    "/l/": {"easy": ["LET", "LIP", "LOG", "LOT", "LAP", "LEG", "LID", "LAY"], "medium": ["LIGHT", "LEARN", "LETTER", "LITTLE", "LISTEN"]},
    "/m/": {"easy": ["MOM", "MAN", "MAP", "MIX", "MUD", "MAT", "MET", "MOB"], "medium": ["MONEY", "MONKEY", "MORNING", "MOUNTAIN", "MAGIC"]},
    "/n/": {"easy": ["NUT", "NET", "NAP", "NIT", "NOD", "NEW", "NOR", "NIL"], "medium": ["NEVER", "NUMBER", "NATURE", "NEEDLE", "NIGHT"]},
    "/p/": {"easy": ["PIG", "PEN", "POT", "PIT", "PAT", "PET", "PIN", "PAN"], "medium": ["PLANT", "PLANET", "PEOPLE", "PURPLE", "PARENT"]},
    "/r/": {"easy": ["RUN", "RED", "RAT", "RUG", "RIM", "RAP", "ROD", "ROW"], "medium": ["RIVER", "RABBIT", "ROCKET", "RESCUE", "RAINBOW"]},
    "/s/": {"easy": ["SUN", "SIT", "SET", "SAT", "SIX", "SIP", "SOB", "SAD"], "medium": ["SMILE", "SILVER", "SUMMER", "SECOND", "SIMPLE"]},
    "/t/": {"easy": ["TOP", "TEN", "TIN", "TAP", "TUG", "TIP", "TON", "TAB"], "medium": ["TIGER", "TRAVEL", "TUNNEL", "TICKET", "TEACHER"]},
    "/v/": {"easy": ["VAN", "VET", "VIM", "VOW", "VIA", "VIE", "VAT", "VEX"], "medium": ["VILLAGE", "VIOLIN", "VALLEY", "VOLCANO", "VICTORY"]},
    "/w/": {"easy": ["WIN", "WET", "WAX", "WIG", "WAR", "WEB", "WON", "WAD"], "medium": ["WATER", "WINTER", "WINDOW", "WONDER", "WEATHER"]},
    "/ks/": {"easy": ["FOX", "BOX", "SIX", "MIX", "WAX", "TAX", "FIX", "HEX"], "medium": ["EXTRA", "EXPAND", "EXAMINE", "EXAMPLE", "EXPLORE"]},
    "/kw/": {"easy": ["QUEEN", "QUIZ", "QUIT", "QUIP", "QUAD"], "medium": ["QUICK", "QUIET", "QUITE", "QUOTE", "QUEST"]},
    "/y/": {"easy": ["YES", "YAM", "YAK", "YAP", "YEW", "YEN"], "medium": ["YELL", "YELLOW", "YOGURT", "YOUNG", "YESTERDAY"]},
    "/z/": {"easy": ["ZOO", "ZIP", "ZAP", "ZEN", "ZIG", "ZAG"], "medium": ["ZEBRA", "ZIGZAG", "ZIPPER", "ZOMBIE", "ZENITH"]},
    "/sh/": {"easy": ["SHIP", "FISH", "SHOP", "SHED", "SHIN", "SHE", "SHOW", "SHUT"], "medium": ["SHADOW", "SHELTER", "SHOULDER", "NATION", "MISSION"]},
    "/ch/": {"easy": ["CHAT", "CHIP", "CHOP", "CHIN", "CHEST", "CHEEK", "CHECK"], "medium": ["CHEESE", "CHICKEN", "CHAPTER", "CHERRY", "MATCH"]},
    "/th/": {"easy": ["THIN", "THICK", "THINK", "THREE", "THANK", "THUD"], "medium": ["THROAT", "THUNDER", "THERAPY", "THOUSAND", "THOUGHT"]},
    "/TH/": {"easy": ["THIS", "THAT", "THEM", "THEN", "THEY", "THAN"], "medium": ["THESE", "THOSE", "THERE", "THOUGH", "BROTHER"]},
    "/ng/": {"easy": ["SING", "RING", "KING", "LONG", "SONG", "HANG", "BANG"], "medium": ["THING", "YOUNG", "SPRING", "STRING", "STRONG"]},
    "/ă/": {"easy": ["CAT", "BAT", "HAT", "MAP", "BAG", "FAN", "DAD", "SAT"], "medium": ["APPLE", "BASKET", "MATCH", "RABBIT", "FAMILY"]},
    "/ĕ/": {"easy": ["BED", "PEN", "HEN", "RED", "TEN", "SET", "WET", "NET"], "medium": ["BEST", "NEST", "LEMON", "ENTER", "SEVEN"]},
    "/ĭ/": {"easy": ["SIT", "PIG", "FISH", "HIT", "BIT", "DIG", "FIG", "KIT"], "medium": ["GIFT", "BRIDGE", "KITTEN", "SISTER", "FINISH"]},
    "/ŏ/": {"easy": ["DOG", "HOT", "POT", "TOP", "BOX", "FOX", "LOG", "MOP"], "medium": ["CLOCK", "DOCTOR", "ROCKET", "OCTOPUS", "MONSTER"]},
    "/ŭ/": {"easy": ["CUP", "BUS", "SUN", "RUN", "FUN", "GUM", "MUD", "BUG"], "medium": ["UNDER", "BUTTER", "UMBRELLA", "JUNGLE", "PUZZLE"]},
    "/ŏŏ/": {"easy": ["BOOK", "COOK", "FOOT", "GOOD", "HOOK", "LOOK", "TOOK"], "medium": ["COOKIE", "PUDDING", "WOODEN", "BUSHEL"]},
    "/ə/": {"easy": ["THE", "ABOUT", "AGAIN"], "medium": ["PENCIL", "LEMON", "CIRCUS", "BANANA", "CAMERA"]},
    "/ā/": {"easy": ["CAKE", "LAKE", "GAME", "MAKE", "RAIN", "PLAY", "DAY", "SAY"], "medium": ["TABLE", "PAPER", "FAMOUS", "NATURE", "AFRAID"]},
    "/ē/": {"easy": ["TREE", "BEE", "SEE", "SHE", "KEY", "BE", "ME", "WE"], "medium": ["BEACH", "FIELD", "BELIEVE", "EVENING", "BETWEEN"]},
    "/ī/": {"easy": ["KITE", "BIKE", "RICE", "FIVE", "NINE", "LIKE", "TIME", "MINE"], "medium": ["NIGHT", "LIGHT", "TIGER", "ISLAND", "SILENT"]},
    "/ō/": {"easy": ["HOME", "BONE", "NOSE", "BOAT", "ROAD", "COAT", "GOAL", "GOAT"], "medium": ["SNOW", "STONE", "BROKEN", "FROZEN", "OCEAN"]},
    "/oo/": {"easy": ["MOON", "FOOD", "ROOM", "COOL", "POOL", "TOOL", "SOON", "ROOF"], "medium": ["SCHOOL", "BALLOON", "CARTOON", "NOODLE"]},
    "/ū/": {"easy": ["CUTE", "MULE", "HUGE", "USE", "FEW", "NEW", "DEW"], "medium": ["MUSIC", "HUMAN", "FUTURE", "UNICORN", "BEAUTY"]},
    "/ow/": {"easy": ["COW", "OWL", "HOW", "NOW", "BOW", "WOW", "POW"], "medium": ["HOUSE", "MOUSE", "CLOUD", "FLOWER", "POWER"]},
    "/oy/": {"easy": ["BOY", "TOY", "JOY", "SOY", "COY", "OIL", "BOIL", "COIN"], "medium": ["ENJOY", "DESTROY", "EMPLOY", "OYSTER"]},
    "/ah/": {"easy": ["FATHER", "CAR", "STAR", "BAR", "JAR", "FAR"], "medium": ["CALM", "PALM", "DRAMA", "BANANA", "LLAMA"]},
    "/ar/": {"easy": ["CAR", "STAR", "BAR", "JAR", "FAR", "ARM", "ART", "DARK"], "medium": ["FARM", "GARDEN", "MARKET", "CARPET", "HARVEST"]},
    "/or/": {"easy": ["FORK", "CORN", "DOOR", "FOUR", "POUR", "MORE", "SORE"], "medium": ["HORSE", "FOREST", "MORNING", "CORNER", "STORY"]},
    "/er/": {"easy": ["HER", "BIRD", "FERN", "TURN", "BURN", "FUR", "HURT"], "medium": ["SISTER", "WINTER", "MIRROR", "DOCTOR", "ANSWER"]},
    "/air/": {"easy": ["FAIR", "BEAR", "CARE", "HAIR", "PAIR", "STAIR", "CHAIR"], "medium": ["SQUARE", "PARENT", "PREPARE", "REPAIR"]},
}

# Populate characters
updated = 0
for char in characters:
    if char.get('easyWords') and len(char['easyWords']) > 0:
        continue  # Already has words

    phon = char.get('phonogram', '').lower()
    sound = char.get('sound', '')

    # Try phonogram lookup first
    words = phon_words.get(phon, [])

    if words:
        char['easyWords'] = words[:8]
        char['mediumWords'] = words[8:13] if len(words) > 8 else []
    elif sound in SOUND_WORDS:
        char['easyWords'] = SOUND_WORDS[sound]['easy'][:8]
        char['mediumWords'] = SOUND_WORDS[sound]['medium'][:5]
    else:
        # Fallback
        char['easyWords'] = []
        char['mediumWords'] = []

    updated += 1

# Now add ALL missing characters for Levels 3-5
# Level 3 has no new characters (rules only)
# Level 4 has no new characters (rules only)
# Level 5 has 38 advanced phonogram characters

LEVEL5_CHARS = [
    ("CHAR-081","AERO","ae","/ā/","s33",5),("CHAR-082","ALGAE","ae","/ē/","s34",5),
    ("CHAR-083","AHAB","ah","/ah/","s41",5),("CHAR-084","STRAIGHT","aigh","/ī/","s35",5),
    ("CHAR-085","CHALK","al","/ah/","s41",5),("CHAR-086","DOUBT","bt","/t/","s14",5),
    ("CHAR-087","ACCENT","cc","/ks/","s17",5),("CHAR-088","FIASCO","co","/k/","s07",5),
    ("CHAR-089","BEAU","eau","/ō/","s36",5),("CHAR-090","BERET","et","/ā/","s33",5),
    ("CHAR-091","EULER","eu","/oo/","s37",5),("CHAR-092","EUROPE","eur","/er/","s44",5),
    ("CHAR-093","GHOST","gh","/g/","s04",5),("CHAR-094","LEGION","gi","/j/","s06",5),
    ("CHAR-095","GNOCCHI","gn","/ny/","s10",5),("CHAR-096","JALAPE","j","/h/","s05",5),
    ("CHAR-097","FJORD","j","/y/","s19",5),("CHAR-098","KHAKI","kh","/k/","s07",5),
    ("CHAR-099","CLIMB","mb","/m/","s09",5),("CHAR-100","HYMN","mn","/n/","s10",5),
    ("CHAR-101","AMOEBA","oe","/ē/","s34",5),("CHAR-102","DEPOT","ot","/ō/","s36",5),
    ("CHAR-103","FOUR","our","/or/","s43",5),("CHAR-104","JOURNAL","our","/er/","s44",5),
    ("CHAR-105","PNEUMA","pn","/n/","s10",5),("CHAR-106","PSALM","ps","/s/","s13",5),
    ("CHAR-107","PTERO","pt","/t/","s14",5),("CHAR-108","RHYME","rh","/r/","s12",5),
    ("CHAR-109","ERROR","rr","/r/","s12",5),("CHAR-110","ISLE","s","/silent/","s13",5),
    ("CHAR-111","SCENE","sc","/s/","s13",5),("CHAR-112","FASCIA","sc","/sh/","s21",5),
    ("CHAR-113","SCHMALTZ","sch","/sh/","s21",5),("CHAR-114","THYME","th","/t/","s14",5),
    ("CHAR-115","DEBUT","ut","/oo/","s37",5),("CHAR-116","FORFEIT","ei","/ĭ/","s28",5),
    ("CHAR-117","CAYENNE","ay","/ī/","s35",5),("CHAR-118","COIF","co","/oo/","s37",5),
]

for cid, name, phon, sound, sid, lev in LEVEL5_CHARS:
    # Check if already exists
    if any(c['id'] == cid for c in characters):
        continue

    easy = SOUND_WORDS.get(sound, {}).get('easy', [])[:6]
    medium = SOUND_WORDS.get(sound, {}).get('medium', [])[:4]

    characters.append({
        "id": cid, "name": name, "phonogram": phon, "sound": sound, "soundId": sid,
        "level": lev, "levelColor": "gold",
        "introduction": {
            "en": f"I'm {name}! I make the {sound} sound!",
            "hi": f"मैं {name} हूँ! मैं {sound} बोलता हूँ!",
            "mr": f"मी {name}! मी {sound} बोलतो!"
        },
        "easyWords": easy, "mediumWords": medium
    })

# Sort by ID
characters.sort(key=lambda c: c['id'])

# Save
with open(os.path.join(DATA, 'characters.json'), 'w') as f:
    json.dump(characters, f, indent=2, ensure_ascii=False)

# Stats
total = len(characters)
with_words = sum(1 for c in characters if c.get('easyWords') and len(c['easyWords']) > 0)
by_level = {}
for c in characters:
    l = c.get('level', 0)
    by_level[l] = by_level.get(l, 0) + 1

print(f"✅ characters.json updated:")
print(f"   Total characters: {total}")
print(f"   With easyWords:   {with_words}")
print(f"   By level: {json.dumps(by_level)}")
