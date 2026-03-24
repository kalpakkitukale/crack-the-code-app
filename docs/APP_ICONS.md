# StreamShaala App Icons

This document describes the unique launcher icons for each StreamShaala segment and how to manage them.

## Icon Design Overview

Each segment of StreamShaala has been designed with a unique, professionally crafted launcher icon that reflects its target audience and educational level:

### 🎨 Junior Segment (Grades 4-7)
**Theme:** Playful Learning
**Colors:** Bright Blue (#2196F3) & Orange
**Icon Design:**
- Vibrant orange book representing foundational learning
- White play button symbolizing video-based education
- Playful sparkles around the icon for a fun, welcoming feel
- Sky blue gradient background

**Target Audience:** Younger students (ages 9-12) who need engaging, colorful visuals

### 💡 Middle Segment (Grades 7-9)
**Theme:** Growth & Exploration
**Colors:** Teal (#009688) & Green
**Icon Design:**
- Light bulb representing ideas and learning
- Light rays emanating outward symbolizing knowledge expansion
- Yellow bulb on teal/green gradient background
- Balanced design between playful and professional

**Target Audience:** Pre-teen to early teen students (ages 12-14) transitioning to more serious study

### 🏆 Preboard Segment (Grade 10)
**Theme:** Focus & Achievement
**Colors:** Orange (#FF5722) & Red
**Icon Design:**
- Trophy with star representing achievement and success
- Target circles in background symbolizing focus
- Gold trophy on orange/red gradient background
- Motivational design for board exam preparation

**Target Audience:** Students (ages 15-16) preparing for 10th board exams

### 🎓 Senior Segment (Grades 11-12)
**Theme:** Academic Excellence
**Colors:** Deep Purple (#3F51B5) & Indigo
**Icon Design:**
- Graduation cap (academic cap) representing higher education
- Modern book stack below the cap
- Teal accent colors for contemporary feel
- Professional, sophisticated design
- Subtle geometric patterns in background

**Target Audience:** Older students (ages 16-18) preparing for 12th boards and competitive exams

## Technical Implementation

### Icon Generation

Icons are generated using a Python script with PIL (Python Imaging Library):

```bash
# Generate base icon images
python3 scripts/generate_icons.py
```

This creates 1024x1024 PNG images in `assets/icons/`:
- `icon_junior.png`
- `icon_middle.png`
- `icon_preboard.png`
- `icon_senior.png`

### Applying Icons to Platforms

Icons are applied using the `flutter_launcher_icons` package with flavor-specific configurations:

```bash
# Apply icons for all segments
bash scripts/apply_icons.sh
```

Or apply individually:

```bash
# Apply for specific segment
dart run flutter_launcher_icons -f flutter_launcher_icons-junior.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-middle.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-preboard.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-senior.yaml
```

### Platform Support

Icons are automatically generated for:
- ✅ **Android** (adaptive icons with background colors)
- ✅ **iOS** (all required sizes)
- ✅ **Web** (favicon and PWA icons)
- ✅ **Windows** (48x48 icon)
- ✅ **macOS** (1024x1024 icon)

## Configuration Files

Each segment has its own configuration file:

- `flutter_launcher_icons-junior.yaml` - Junior segment config
- `flutter_launcher_icons-middle.yaml` - Middle segment config
- `flutter_launcher_icons-preboard.yaml` - Preboard segment config
- `flutter_launcher_icons-senior.yaml` - Senior segment config

## Icon Specifications

### Android
- **Adaptive Icon:** Yes
- **Foreground:** Full icon design
- **Background:** Solid color matching segment theme
- **Sizes Generated:** mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi

### iOS
- **Formats:** PNG
- **Sizes:** All required App Icon sizes from 20pt to 1024pt
- **Alpha Channel:** Removed (as per iOS requirements)

### Web
- **Favicon:** 16x16, 32x32, 48x48
- **PWA Icons:** 192x192, 512x512
- **Theme Colors:** Match segment background colors

### Windows
- **Format:** ICO
- **Size:** 48x48 (can be customized)

### macOS
- **Format:** ICNS
- **Base Size:** 1024x1024

## Modifying Icons

### Changing Design

To modify icon designs:

1. Edit `scripts/generate_icons.py`
2. Modify the respective `create_*_icon()` function
3. Regenerate icons:
   ```bash
   python3 scripts/generate_icons.py
   bash scripts/apply_icons.sh
   ```

### Changing Colors

To change segment colors:

1. Update background color in respective `flutter_launcher_icons-*.yaml` file
2. Update colors in `create_*_icon()` function in `generate_icons.py`
3. Regenerate:
   ```bash
   python3 scripts/generate_icons.py
   bash scripts/apply_icons.sh
   ```

## Testing Icons

### Android
Build and install the app:
```bash
# Junior
flutter build apk --flavor junior
flutter install --flavor junior

# Middle
flutter build apk --flavor middle
flutter install --flavor middle

# Senior
flutter build apk --flavor senior
flutter install --flavor senior

# Preboard
flutter build apk --flavor preboard
flutter install --flavor preboard
```

Check:
- App drawer icon
- Recent apps icon
- Adaptive icon animation (on supported devices)

### iOS
Build and install:
```bash
flutter build ios --flavor junior
# Open in Xcode and run
```

Check:
- Home screen icon
- Settings icon
- Spotlight search icon

### Web
Build and serve:
```bash
flutter build web --flavor middle
# Serve and check browser tab icon and PWA install icon
```

## File Structure

```
StreamShaala/
├── assets/
│   └── icons/
│       ├── icon_junior.png      (1024x1024 Junior icon)
│       ├── icon_middle.png      (1024x1024 Middle icon)
│       ├── icon_preboard.png    (1024x1024 Preboard icon)
│       └── icon_senior.png      (1024x1024 Senior icon)
├── scripts/
│   ├── generate_icons.py        (Python script to generate icons)
│   └── apply_icons.sh           (Bash script to apply icons)
├── flutter_launcher_icons-junior.yaml
├── flutter_launcher_icons-middle.yaml
├── flutter_launcher_icons-preboard.yaml
└── flutter_launcher_icons-senior.yaml
```

## Troubleshooting

### Icons not updating on device

1. **Clean build:**
   ```bash
   flutter clean
   flutter pub get
   bash scripts/apply_icons.sh
   flutter build apk --flavor <segment>
   ```

2. **Uninstall and reinstall:**
   - Completely uninstall the app from device
   - Rebuild and install fresh

3. **Clear cache (Android):**
   - Sometimes launcher cache needs clearing
   - Restart device or clear launcher data

### Icons look pixelated

- Ensure base icons are 1024x1024 PNG
- Check `generate_icons.py` is creating high-quality images
- Verify icon files in `assets/icons/` are correct size

### Wrong icon showing

- Verify you're building with correct flavor
- Check Android manifest has correct icon reference
- Ensure `apply_icons.sh` ran successfully

## Design Principles

All icons follow these principles:

1. **Clear at Small Sizes:** Readable at 48x48 pixels
2. **Distinctive:** Each segment instantly recognizable
3. **Professional:** Age-appropriate sophistication level
4. **Educational:** Incorporates learning/academic elements
5. **Consistent:** Follows similar compositional structure
6. **Platform-Adaptive:** Works well on all platforms

## Credits

Icons designed and implemented for StreamShaala educational platform.
- Design Tool: Python PIL (Pillow)
- Implementation: flutter_launcher_icons v0.14.4
- Created: January 2026

## License

These icons are proprietary to StreamShaala and should not be used outside this project.
