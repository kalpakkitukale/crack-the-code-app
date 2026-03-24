#!/usr/bin/env python3
"""
Generate professional, modern app icons following best design principles.

Design Philosophy:
- Minimalist and clean
- Modern gradients
- Scalable to any size
- Instantly recognizable
- Professional polish
- Brand consistency across flavors
"""

from PIL import Image, ImageDraw, ImageFont
import math
import os

OUTPUT_DIR = "assets/icons/options_v2"
SIZE = 1024

def create_output_dir():
    """Create output directory for icon options."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for flavor in ['junior', 'middle', 'preboard', 'senior']:
        os.makedirs(f"{OUTPUT_DIR}/{flavor}", exist_ok=True)

def create_gradient_background(size, color1, color2, direction='vertical'):
    """Create a smooth gradient background."""
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img)

    if direction == 'vertical':
        for y in range(size):
            ratio = y / size
            r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
            g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
            b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
            draw.line([(0, y), (size, y)], fill=(r, g, b))
    elif direction == 'diagonal':
        for y in range(size):
            for x in range(size):
                ratio = (x + y) / (2 * size)
                r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
                g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
                b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
                draw.point((x, y), fill=(r, g, b))
    elif direction == 'radial':
        center = size // 2
        max_distance = math.sqrt(2 * (center ** 2))
        for y in range(size):
            for x in range(size):
                distance = math.sqrt((x - center) ** 2 + (y - center) ** 2)
                ratio = min(distance / max_distance, 1.0)
                r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
                g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
                b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
                draw.point((x, y), fill=(r, g, b))

    return img

def draw_play_button(draw, cx, cy, size, color=(255, 255, 255), style='solid'):
    """Draw a modern play button."""
    if style == 'solid':
        # Solid triangle
        points = [
            (cx - size * 0.4, cy - size * 0.5),
            (cx - size * 0.4, cy + size * 0.5),
            (cx + size * 0.6, cy)
        ]
        draw.polygon(points, fill=color)
    elif style == 'circle':
        # Circle with triangle
        draw.ellipse([cx - size, cy - size, cx + size, cy + size],
                    fill=color, outline=None)
        triangle_size = size * 0.5
        points = [
            (cx - triangle_size * 0.3, cy - triangle_size * 0.6),
            (cx - triangle_size * 0.3, cy + triangle_size * 0.6),
            (cx + triangle_size * 0.7, cy)
        ]
        # Darker triangle
        tri_color = tuple(int(c * 0.3) for c in color)
        draw.polygon(points, fill=tri_color)
    elif style == 'rounded':
        # Rounded triangle (approximation with polygon)
        points = [
            (cx - size * 0.4, cy - size * 0.5),
            (cx - size * 0.4, cy + size * 0.5),
            (cx + size * 0.6, cy)
        ]
        # Draw with thicker outline for rounded effect
        for offset in range(15):
            alpha = int(255 * (1 - offset / 15))
            draw.polygon(points, outline=color + (alpha,) if len(color) == 3 else color)

def add_corner_radius(img, radius):
    """Add rounded corners to an image."""
    # Create a mask for rounded corners
    mask = Image.new('L', (img.width, img.height), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([0, 0, img.width, img.height], radius=radius, fill=255)

    # Apply the mask
    img.putalpha(mask)
    return img

# ==================== JUNIOR FLAVOR ICONS ====================

def junior_modern_1():
    """Vibrant gradient with centered play - Modern & Fun."""
    # Bright blue to cyan gradient
    img = create_gradient_background(SIZE, (33, 150, 243), (0, 188, 212), 'vertical')
    draw = ImageDraw.Draw(img)

    # Large white circle background
    center = SIZE // 2
    circle_r = 320
    draw.ellipse([center - circle_r, center - circle_r,
                 center + circle_r, center + circle_r],
                fill=(255, 255, 255))

    # Orange play button
    draw_play_button(draw, center, center, 220, (255, 152, 0), 'solid')

    # Small accent circles in corners
    accent_r = 40
    positions = [(150, 150), (SIZE-150, 150), (150, SIZE-150), (SIZE-150, SIZE-150)]
    colors = [(255, 193, 7), (76, 175, 80), (244, 67, 54), (156, 39, 176)]

    for pos, color in zip(positions, colors):
        draw.ellipse([pos[0] - accent_r, pos[1] - accent_r,
                     pos[0] + accent_r, pos[1] + accent_r], fill=color)

    return img

def junior_modern_2():
    """Playful geometric - Colorful layers."""
    # Yellow to orange gradient
    img = create_gradient_background(SIZE, (255, 235, 59), (255, 152, 0), 'diagonal')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Layered circles
    colors = [(244, 67, 54, 180), (156, 39, 176, 180), (33, 150, 243, 200)]
    radii = [380, 280, 180]

    for color, radius in zip(colors, radii):
        # Create a temporary image for transparency
        temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
        temp_draw = ImageDraw.Draw(temp)
        temp_draw.ellipse([center - radius, center - radius,
                          center + radius, center + radius], fill=color)
        img.paste(temp, (0, 0), temp)

    # White play button
    draw = ImageDraw.Draw(img)
    draw_play_button(draw, center, center, 150, (255, 255, 255), 'solid')

    return img

def junior_modern_3():
    """Minimal badge style - Clean and simple."""
    # Green gradient
    img = create_gradient_background(SIZE, (76, 175, 80), (139, 195, 74), 'radial')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # White rounded square badge
    badge_size = 500
    badge_x = center - badge_size // 2
    badge_y = center - badge_size // 2

    draw.rounded_rectangle([badge_x, badge_y,
                           badge_x + badge_size, badge_y + badge_size],
                          radius=100, fill=(255, 255, 255))

    # Blue play button
    draw_play_button(draw, center, center, 180, (33, 150, 243), 'solid')

    # Small stars around badge
    star_color = (255, 193, 7)
    star_positions = [
        (center, badge_y - 100),
        (center, badge_y + badge_size + 100),
        (badge_x - 100, center),
        (badge_x + badge_size + 100, center)
    ]

    for sx, sy in star_positions:
        # Simple star (diamond shape)
        star_size = 50
        draw.polygon([
            (sx, sy - star_size),
            (sx + star_size * 0.3, sy),
            (sx, sy + star_size),
            (sx - star_size * 0.3, sy)
        ], fill=star_color)

    return img

def junior_modern_4():
    """Bold split design - Dynamic energy."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Split diagonal design
    # Top-left: Blue
    for y in range(SIZE):
        for x in range(SIZE):
            if x + y < SIZE:
                draw.point((x, y), fill=(63, 81, 181))
            else:
                draw.point((x, y), fill=(255, 152, 0))

    center = SIZE // 2

    # Large white circle
    circle_r = 300
    draw.ellipse([center - circle_r, center - circle_r,
                 center + circle_r, center + circle_r],
                fill=(255, 255, 255))

    # Teal play button
    draw_play_button(draw, center, center, 200, (0, 150, 136), 'solid')

    return img

def junior_modern_5():
    """Bubble theme - Fun and playful."""
    # Pink to purple gradient
    img = create_gradient_background(SIZE, (233, 30, 99), (156, 39, 176), 'vertical')
    draw = ImageDraw.Draw(img)

    # Multiple colorful bubbles
    bubbles = [
        (200, 200, 140, (255, 193, 7, 200)),
        (SIZE-200, 200, 120, (0, 188, 212, 200)),
        (200, SIZE-200, 160, (76, 175, 80, 200)),
        (SIZE-200, SIZE-200, 130, (255, 152, 0, 200))
    ]

    for bx, by, br, color in bubbles:
        temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
        temp_draw = ImageDraw.Draw(temp)
        temp_draw.ellipse([bx - br, by - br, bx + br, by + br], fill=color)
        img.paste(temp, (0, 0), temp)

    # Center white bubble with play
    center = SIZE // 2
    main_r = 250
    draw = ImageDraw.Draw(img)
    draw.ellipse([center - main_r, center - main_r,
                 center + main_r, center + main_r],
                fill=(255, 255, 255))

    draw_play_button(draw, center, center, 180, (156, 39, 176), 'solid')

    return img

# ==================== MIDDLE FLAVOR ICONS ====================

def middle_modern_1():
    """Sophisticated gradient - Professional growth."""
    # Teal to deep blue gradient
    img = create_gradient_background(SIZE, (0, 150, 136), (13, 71, 161), 'diagonal')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Glowing circle effect
    for i in range(5, 0, -1):
        alpha = int(255 * (i / 5) * 0.3)
        radius = 280 + i * 40
        temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
        temp_draw = ImageDraw.Draw(temp)
        temp_draw.ellipse([center - radius, center - radius,
                          center + radius, center + radius],
                         fill=(255, 255, 255, alpha))
        img.paste(temp, (0, 0), temp)

    # Solid white center
    draw = ImageDraw.Draw(img)
    draw.ellipse([center - 280, center - 280,
                 center + 280, center + 280],
                fill=(255, 255, 255))

    # Yellow play button
    draw_play_button(draw, center, center, 200, (255, 193, 7), 'solid')

    return img

def middle_modern_2():
    """Abstract waves - Dynamic learning."""
    # Purple gradient
    img = create_gradient_background(SIZE, (103, 58, 183), (156, 39, 176), 'vertical')
    draw = ImageDraw.Draw(img)

    # Wave shapes (simplified arcs)
    center = SIZE // 2
    wave_colors = [(255, 255, 255, 100), (255, 255, 255, 150), (255, 255, 255, 200)]

    for i, color in enumerate(wave_colors):
        temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
        temp_draw = ImageDraw.Draw(temp)

        # Draw curved shape
        y_offset = -200 + i * 100
        for y in range(SIZE):
            wave_y = int(math.sin((y + y_offset) * 0.01) * 80) + center
            temp_draw.line([(0, wave_y), (SIZE, wave_y)], fill=color, width=60)

        img.paste(temp, (0, 0), temp)

    # Play button in badge
    draw = ImageDraw.Draw(img)
    badge_size = 400
    badge_x = center - badge_size // 2
    badge_y = center - badge_size // 2

    draw.ellipse([badge_x, badge_y,
                 badge_x + badge_size, badge_y + badge_size],
                fill=(255, 255, 255))

    draw_play_button(draw, center, center, 180, (0, 188, 212), 'solid')

    return img

def middle_modern_3():
    """Geometric precision - Modern design."""
    # Blue to cyan gradient
    img = create_gradient_background(SIZE, (33, 150, 243), (0, 188, 212), 'radial')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Hexagonal shape
    hex_radius = 350
    hex_points = []
    for i in range(6):
        angle = math.radians(60 * i - 30)
        x = center + hex_radius * math.cos(angle)
        y = center + hex_radius * math.sin(angle)
        hex_points.append((x, y))

    draw.polygon(hex_points, fill=(255, 255, 255))

    # Orange play button
    draw_play_button(draw, center, center, 200, (255, 152, 0), 'solid')

    # Small accent circles at hex corners
    for hx, hy in hex_points:
        draw.ellipse([hx - 35, hy - 35, hx + 35, hy + 35],
                    fill=(255, 193, 7))

    return img

def middle_modern_4():
    """Layered depth - 3D effect."""
    # Gradient background
    img = create_gradient_background(SIZE, (13, 71, 161), (63, 81, 181), 'vertical')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Layered rounded squares
    sizes = [500, 400, 300]
    colors = [(255, 255, 255, 100), (255, 255, 255, 150), (255, 255, 255, 255)]

    for size, color in zip(sizes, colors):
        half = size // 2
        temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
        temp_draw = ImageDraw.Draw(temp)
        temp_draw.rounded_rectangle([center - half, center - half,
                                     center + half, center + half],
                                   radius=60, fill=color)
        img.paste(temp, (0, 0), temp)

    # Play button
    draw = ImageDraw.Draw(img)
    draw_play_button(draw, center, center, 180, (0, 150, 136), 'solid')

    return img

def middle_modern_5():
    """Minimalist badge - Clean focus."""
    # Gradient
    img = create_gradient_background(SIZE, (0, 150, 136), (0, 188, 212), 'diagonal')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Single large circle
    circle_r = 340
    draw.ellipse([center - circle_r, center - circle_r,
                 center + circle_r, center + circle_r],
                fill=(255, 255, 255))

    # Inner colored circle
    inner_r = 240
    draw.ellipse([center - inner_r, center - inner_r,
                 center + inner_r, center + inner_r],
                fill=(255, 193, 7))

    # White play button
    draw_play_button(draw, center, center, 170, (255, 255, 255), 'solid')

    return img

# ==================== PREBOARD FLAVOR ICONS ====================

def preboard_modern_1():
    """Bold achievement - Victory focus."""
    # Red to orange gradient
    img = create_gradient_background(SIZE, (244, 67, 54), (255, 152, 0), 'diagonal')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Gold trophy shape (simplified)
    # Base
    base_width = 200
    base_height = 80
    draw.rectangle([center - base_width, center + 200,
                   center + base_width, center + 200 + base_height],
                  fill=(255, 215, 0))

    # Cup
    cup_points = [
        (center - 180, center + 200),
        (center - 220, center - 100),
        (center + 220, center - 100),
        (center + 180, center + 200)
    ]
    draw.polygon(cup_points, fill=(255, 215, 0))

    # White star on trophy
    star_size = 100
    star_points = []
    for i in range(5):
        angle = math.radians(i * 144 - 90)
        x = center + star_size * math.cos(angle)
        y = center + star_size * math.sin(angle)
        star_points.append((x, y))
    draw.polygon(star_points, fill=(255, 255, 255))

    # Play button in star
    draw_play_button(draw, center, center, 60, (255, 215, 0), 'solid')

    return img

def preboard_modern_2():
    """Target precision - Goal oriented."""
    # Deep red gradient
    img = create_gradient_background(SIZE, (183, 28, 28), (211, 47, 47), 'radial')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Concentric circles (target)
    colors = [(255, 255, 255), (255, 193, 7), (255, 255, 255), (255, 152, 0)]
    radii = [350, 280, 210, 140]

    for color, radius in zip(colors, radii):
        draw.ellipse([center - radius, center - radius,
                     center + radius, center + radius],
                    fill=color)

    # Red play button in center
    draw_play_button(draw, center, center, 100, (244, 67, 54), 'solid')

    return img

def preboard_modern_3():
    """Diamond brilliance - Excellence."""
    # Gold gradient
    img = create_gradient_background(SIZE, (255, 193, 7), (255, 215, 0), 'vertical')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Diamond shape (rhombus)
    diamond_size = 400
    diamond_points = [
        (center, center - diamond_size),
        (center + diamond_size * 0.7, center),
        (center, center + diamond_size),
        (center - diamond_size * 0.7, center)
    ]

    draw.polygon(diamond_points, fill=(255, 255, 255))

    # Inner diamond
    inner_size = 280
    inner_points = [
        (center, center - inner_size),
        (center + inner_size * 0.7, center),
        (center, center + inner_size),
        (center - inner_size * 0.7, center)
    ]

    draw.polygon(inner_points, fill=(244, 67, 54))

    # White play button
    draw_play_button(draw, center, center, 160, (255, 255, 255), 'solid')

    return img

def preboard_modern_4():
    """Success badge - Achievement seal."""
    # Orange to red gradient
    img = create_gradient_background(SIZE, (255, 152, 0), (244, 67, 54), 'radial')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Star badge background
    star_points = []
    num_points = 8
    outer_r = 380
    inner_r = 280

    for i in range(num_points * 2):
        angle = math.radians(i * 360 / (num_points * 2) - 90)
        if i % 2 == 0:
            r = outer_r
        else:
            r = inner_r
        x = center + r * math.cos(angle)
        y = center + r * math.sin(angle)
        star_points.append((x, y))

    draw.polygon(star_points, fill=(255, 255, 255))

    # Gold center circle
    circle_r = 220
    draw.ellipse([center - circle_r, center - circle_r,
                 center + circle_r, center + circle_r],
                fill=(255, 215, 0))

    # White play button
    draw_play_button(draw, center, center, 160, (255, 255, 255), 'solid')

    return img

def preboard_modern_5():
    """Crown of success - Royalty theme."""
    # Deep purple gradient
    img = create_gradient_background(SIZE, (74, 20, 140), (156, 39, 176), 'vertical')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Crown points (simplified)
    crown_base_y = center + 150
    crown_top_y = center - 200

    # Base rectangle
    draw.rectangle([center - 280, crown_base_y,
                   center + 280, crown_base_y + 100],
                  fill=(255, 215, 0))

    # Crown points (triangular peaks)
    peaks = [
        (center - 200, crown_base_y, center - 200, crown_top_y),
        (center, crown_base_y, center, crown_top_y - 100),
        (center + 200, crown_base_y, center + 200, crown_top_y)
    ]

    for px, py1, px2, py2 in peaks:
        draw.polygon([
            (px - 80, py1),
            (px, py2),
            (px + 80, py1)
        ], fill=(255, 215, 0))

    # White circle in center
    circle_r = 140
    draw.ellipse([center - circle_r, center - circle_r,
                 center + circle_r, center + circle_r],
                fill=(255, 255, 255))

    # Purple play button
    draw_play_button(draw, center, center, 100, (156, 39, 176), 'solid')

    return img

# ==================== SENIOR FLAVOR ICONS ====================

def senior_modern_1():
    """Professional gradient - University ready."""
    # Deep blue to purple gradient
    img = create_gradient_background(SIZE, (13, 71, 161), (94, 53, 177), 'diagonal')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Rounded square badge
    badge_size = 600
    half = badge_size // 2
    draw.rounded_rectangle([center - half, center - half,
                           center + half, center + half],
                          radius=120, fill=(255, 255, 255))

    # Gold inner square
    inner_size = 450
    inner_half = inner_size // 2
    draw.rounded_rectangle([center - inner_half, center - inner_half,
                           center + inner_half, center + inner_half],
                          radius=90, fill=(255, 215, 0))

    # White play button
    draw_play_button(draw, center, center, 180, (255, 255, 255), 'solid')

    return img

def senior_modern_2():
    """Minimalist excellence - Clean sophistication."""
    # Navy blue gradient
    img = create_gradient_background(SIZE, (25, 42, 86), (13, 71, 161), 'vertical')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Large white circle
    circle_r = 360
    draw.ellipse([center - circle_r, center - circle_r,
                 center + circle_r, center + circle_r],
                fill=(255, 255, 255))

    # Teal ring
    ring_outer = 300
    ring_inner = 240
    temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    temp_draw = ImageDraw.Draw(temp)
    temp_draw.ellipse([center - ring_outer, center - ring_outer,
                      center + ring_outer, center + ring_outer],
                     fill=(0, 150, 136))
    temp_draw.ellipse([center - ring_inner, center - ring_inner,
                      center + ring_inner, center + ring_inner],
                     fill=(0, 0, 0, 0))
    img.paste(temp, (0, 0), temp)

    # White center
    draw = ImageDraw.Draw(img)
    draw.ellipse([center - ring_inner, center - ring_inner,
                 center + ring_inner, center + ring_inner],
                fill=(255, 255, 255))

    # Blue play button
    draw_play_button(draw, center, center, 170, (13, 71, 161), 'solid')

    return img

def senior_modern_3():
    """Abstract ribbons - Achievement flow."""
    # Purple gradient
    img = create_gradient_background(SIZE, (94, 53, 177), (103, 58, 183), 'radial')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Curved ribbon shapes
    # This creates an abstract flowing design
    ribbon_colors = [(255, 193, 7, 200), (255, 255, 255, 200)]

    for i, color in enumerate(ribbon_colors):
        temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
        temp_draw = ImageDraw.Draw(temp)

        # Draw curved band
        y_start = 200 + i * 150
        for y in range(200):
            curve = int(math.sin((y + i * 50) * 0.03) * 150)
            x_start = curve + 100
            temp_draw.line([(x_start, y_start + y), (SIZE - x_start, y_start + y)],
                          fill=color, width=100)

        img.paste(temp, (0, 0), temp)

    # Center play badge
    draw = ImageDraw.Draw(img)
    badge_r = 180
    draw.ellipse([center - badge_r, center - badge_r,
                 center + badge_r, center + badge_r],
                fill=(255, 255, 255))

    draw_play_button(draw, center, center, 130, (0, 188, 212), 'solid')

    return img

def senior_modern_4():
    """Sophisticated layers - Depth and maturity."""
    # Dark teal gradient
    img = create_gradient_background(SIZE, (0, 77, 64), (0, 150, 136), 'vertical')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Multiple layered circles
    circles = [
        (400, (255, 255, 255, 80)),
        (340, (255, 255, 255, 120)),
        (280, (255, 255, 255, 160)),
        (220, (255, 255, 255, 255))
    ]

    for radius, color in circles:
        temp = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
        temp_draw = ImageDraw.Draw(temp)
        temp_draw.ellipse([center - radius, center - radius,
                          center + radius, center + radius],
                         fill=color)
        img.paste(temp, (0, 0), temp)

    # Gold play button
    draw = ImageDraw.Draw(img)
    draw_play_button(draw, center, center, 160, (255, 193, 7), 'solid')

    return img

def senior_modern_5():
    """Elite hexagon - Premium quality."""
    # Deep blue gradient
    img = create_gradient_background(SIZE, (13, 71, 161), (25, 42, 86), 'diagonal')
    draw = ImageDraw.Draw(img)

    center = SIZE // 2

    # Large white hexagon
    hex_radius = 380
    hex_points = []
    for i in range(6):
        angle = math.radians(60 * i)
        x = center + hex_radius * math.cos(angle)
        y = center + hex_radius * math.sin(angle)
        hex_points.append((x, y))

    draw.polygon(hex_points, fill=(255, 255, 255))

    # Inner gold hexagon
    inner_radius = 300
    inner_points = []
    for i in range(6):
        angle = math.radians(60 * i)
        x = center + inner_radius * math.cos(angle)
        y = center + inner_radius * math.sin(angle)
        inner_points.append((x, y))

    draw.polygon(inner_points, fill=(255, 215, 0))

    # White play button
    draw_play_button(draw, center, center, 180, (255, 255, 255), 'solid')

    return img

# ==================== MAIN GENERATION ====================

def main():
    """Generate professional modern icons."""
    create_output_dir()

    print("="*70)
    print("GENERATING PROFESSIONAL, MODERN APP ICONS")
    print("Following industry-standard design principles")
    print("="*70)
    print()

    flavors = {
        'junior': [
            junior_modern_1, junior_modern_2, junior_modern_3,
            junior_modern_4, junior_modern_5
        ],
        'middle': [
            middle_modern_1, middle_modern_2, middle_modern_3,
            middle_modern_4, middle_modern_5
        ],
        'preboard': [
            preboard_modern_1, preboard_modern_2, preboard_modern_3,
            preboard_modern_4, preboard_modern_5
        ],
        'senior': [
            senior_modern_1, senior_modern_2, senior_modern_3,
            senior_modern_4, senior_modern_5
        ]
    }

    flavor_names = {
        'junior': 'JUNIOR (Grades 4-7)',
        'middle': 'MIDDLE (Grades 7-9)',
        'preboard': 'PREBOARD (Grade 10)',
        'senior': 'SENIOR (Grades 11-12)'
    }

    for flavor, functions in flavors.items():
        print(f"📱 {flavor_names[flavor]}")
        print("-" * 70)

        for i, func in enumerate(functions, 1):
            img = func()
            filename = f"{OUTPUT_DIR}/{flavor}/option_{i}.png"
            img.save(filename)

            # Get function docstring for description
            desc = func.__doc__.strip() if func.__doc__ else "Modern design"
            print(f"   ✓ Option {i}: {desc}")

        print()

    print("="*70)
    print(f"✅ SUCCESS! Generated 20 professional icons")
    print(f"📂 Location: {OUTPUT_DIR}/")
    print("="*70)
    print()
    print("Each flavor has 5 carefully designed options:")
    print("  • Modern gradients and clean layouts")
    print("  • Professional quality")
    print("  • Scalable to any size")
    print("  • Distinct visual identity")
    print()
    print("Review and select your favorites!")

if __name__ == '__main__':
    main()
