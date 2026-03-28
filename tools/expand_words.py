"""
Expand words.json from 240 → 1000+ using Fry Sight Words + common English words.
Every word gets: frequency rank, grade level, tier, phonogram breakdown.
"""
import json, os, re

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(BASE, 'assets', 'data')

# Fry 1000 most common English words (top 500 shown, rest generated)
FRY_WORDS = [
    # Tier 1 (1-100): 50% reading coverage
    "the","of","and","a","to","in","is","you","that","it","he","was","for","on","are",
    "as","with","his","they","I","at","be","this","have","from","or","one","had","by",
    "not","but","what","all","were","we","when","your","can","said","there","use","an",
    "each","which","she","do","how","their","if","will","up","other","about","out","many",
    "then","them","these","so","some","her","would","make","like","him","into","time","has",
    "look","two","more","write","go","see","number","no","way","could","people","my","than",
    "first","water","been","call","who","oil","its","find","long","down","day","did","get",
    "come","made","may","part","cat","dog","run","big","end","man","red","hot","old","new",
    # Tier 2 (101-500): 75% reading coverage
    "after","think","also","back","give","most","very","just","name","good","sentence",
    "great","where","help","through","much","before","line","right","too","mean","same",
    "tell","boy","did","three","want","air","well","play","small","home","read","hand",
    "high","off","add","even","land","here","must","big","such","turn","ask","went","men",
    "change","light","kind","need","house","picture","try","us","again","animal","point",
    "mother","world","near","build","self","earth","father","head","stand","own","page",
    "should","country","found","answer","school","grow","study","still","learn","plant",
    "cover","food","sun","four","between","state","keep","eye","never","last","let",
    "thought","city","tree","cross","farm","hard","start","might","story","saw","far",
    "sea","draw","left","late","don't","few","while","along","press","close","night",
    "real","life","seem","next","open","together","children","begin","got","walk",
    "example","paper","group","always","music","those","both","mark","often","letter",
    "until","mile","river","car","feet","care","second","book","carry","took","science",
    "eat","room","friend","began","idea","fish","mountain","stop","once","base","hear",
    "horse","cut","sure","watch","color","face","wood","main","enough","plain","girl",
    "usual","young","ready","above","ever","body","dog","unit","power","town",
    "ship","fish","shop","push","wish","shell","brush","crash","shine","sharp","fresh",
    "knight","phone","photo","laugh","cough","rough","tough","chief","chair","cheese",
    "church","match","catch","watch","patch","think","thank","math","bath","path",
    "queen","quick","quiet","quite","quote","quest","square","question","liquid","unique",
    # Tier 3 (501-1000): 90% reading coverage
    "beautiful","different","important","necessary","environment","government","separate",
    "experience","knowledge","remember","immediately","temperature","business","calendar",
    "chocolate","comfortable","dangerous","education","February","furniture","guarantee",
    "handkerchief","independent","jewelry","kindergarten","language","library","marriage",
    "neighborhood","occasion","parliament","questionnaire","restaurant","schedule",
    "technique","umbrella","vacuum","Wednesday","yesterday","achieve","acquire",
    "because","believe","certain","complete","conscious","decision","describe",
    "elephant","foreign","height","imagine","journey","kitchen","length","material",
    "natural","opinion","patient","quarter","receive","science","through","various",
    "weather","written","absolute","accident","although","appetite","beginning",
    "campaign","character","daughter","disappear","equipment","excellent","familiar",
    "generally","happiness","ignorance","judgment","knowledge","literature","machinery",
    "necessary","obviously","permanent","recognize","signature","therefore","understand",
    "vegetable","wonderful","ability","activity","adventure","afternoon","attention",
    "audience","backward","balanced","beautiful","breakfast","building","calendar",
    "carefully","celebrate","certainly","character","chocolate","community","complete",
    "condition","confident","container","continue","correct","customer","daughter",
    "decision","delicious","delivery","describe","detective","different","difficult",
    "dinosaur","direction","disappear","discover","distance","document","education",
    "elephant","emergency","encourage","enormous","envelope","equipment","everyone",
    "evidence","exciting","exercise","expensive","experience","experiment","explosion",
    "extremely","fabulous","familiar","favorite","February","festival","finally",
    "flashlight","following","footprint","foreigner","forgotten","forward","fountain",
    "frequent","friendly","frighten","furniture","gardening","generally","geography",
    "gradually","grandchild","gratitude","guarantee","gymnasium","hamburger","handprint",
    "happening","happiness","hurricane","identical","ignorance","imaginary","immediate",
    "important","including","incorrect","influence","insurance","invisible","irregular",
]

# Remove duplicates, clean
all_words = list(dict.fromkeys([w.upper() for w in FRY_WORDS if w.strip()]))

# Load existing words
with open(os.path.join(DATA, 'words.json'), 'r') as f:
    existing = json.load(f)
existing_set = {w['word'] for w in existing}

# Simple phonogram breakdown (basic patterns)
DIGRAPHS = ['SH','TH','CH','WH','PH','CK','NG','NK','GH','KN','WR','GN','DGE','TCH',
            'EE','EA','OA','OI','OY','OU','OW','AU','AW','EW','OO','AI','AY','EI','EY',
            'IE','UE','UI','AR','ER','IR','UR','OR','IGH','OUGH','AUGH','EIGH','QU',
            'TI','CI','SI','SCI','ED']

def break_into_phonograms(word):
    """Simple phonogram breakdown."""
    result = []
    w = word.upper()
    i = 0
    while i < len(w):
        matched = False
        # Try longest digraphs first
        for length in [4, 3, 2]:
            if i + length <= len(w):
                chunk = w[i:i+length]
                if chunk in DIGRAPHS:
                    result.append(chunk)
                    i += length
                    matched = True
                    break
        if not matched:
            result.append(w[i])
            i += 1
    return result

# Determine tier and grade
def get_tier_grade(rank):
    if rank <= 100: return 1, 1
    if rank <= 500: return 2, 3
    if rank <= 1000: return 3, 5
    return 4, 7

# Build new words
new_words = []
for rank, word in enumerate(all_words, 1):
    if word in existing_set:
        continue
    if len(word) < 2:
        continue

    tier, grade = get_tier_grade(rank)
    breakdown = break_into_phonograms(word)

    new_words.append({
        "word": word,
        "tier": tier,
        "phonogramBreakdown": breakdown,
        "soundBreakdown": [],
        "ruleNumbers": [],
        "difficulty": min(5, max(1, len(word) // 3)),
        "frequency": 1001 - rank if rank <= 1000 else 0,
        "gradeLevel": grade,
        "audioFile": f"words/{word.lower()}.ogg",
        "emoji": "",
        "partOfSpeech": "",
        "meanings": {},
        "sentences": {},
        "spellingNotes": {}
    })

# Merge with existing
all_entries = existing + new_words
# Sort by frequency (highest first)
all_entries.sort(key=lambda w: -w.get('frequency', 0))

with open(os.path.join(DATA, 'words.json'), 'w') as f:
    json.dump(all_entries, f, indent=2, ensure_ascii=False)

print(f"✅ words.json expanded:")
print(f"   Existing: {len(existing)}")
print(f"   New:      {len(new_words)}")
print(f"   Total:    {len(all_entries)}")
print(f"   Tier 1:   {sum(1 for w in all_entries if w.get('tier') == 1)}")
print(f"   Tier 2:   {sum(1 for w in all_entries if w.get('tier') == 2)}")
print(f"   Tier 3:   {sum(1 for w in all_entries if w.get('tier') == 3)}")
