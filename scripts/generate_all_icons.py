#!/usr/bin/env python3
"""
Generate all 4 distinctive app icons for Crack the Code segments
"""

from PIL import Image, ImageDraw
import os
import math

def create_junior_icon(size=1024):
    """Junior (grades 4-7): Bright, playful with clear visual elements"""
    img = Image.new('RGB', (size, size), (33, 150, 243))
    draw = ImageDraw.Draw(img)
    center = size // 2

    # Radial gradient background
    for r in range(size//2, 0, -10):
        color = (
            33 + int((100 - 33) * (1 - r/(size//2))),
            150 + int((181 - 150) * (1 - r/(size//2))),
            243 + int((246 - 243) * (1 - r/(size//2)))
        )
        draw.ellipse([center-r, center-r, center+r, center+r], fill=color)

    # Large orange book
    book_size = int(size * 0.5)
    book_x = center - book_size//2
    book_y = int(size * 0.25)

    # Shadow
    draw.rounded_rectangle(
        [book_x+15, book_y+15, book_x+book_size+15, book_y+book_size+15],
        radius=40, fill=(200, 100, 0)
    )
    # Book body
    draw.rounded_rectangle(
        [book_x, book_y, book_x+book_size, book_y+book_size],
        radius=40, fill=(255, 152, 0)
    )
    # Spine
    draw.rectangle(
        [book_x+20, book_y+20, book_x+60, book_y+book_size-20],
        fill=(255, 193, 7)
    )
    # Pages
    for i in range(3):
        y = book_y + 80 + i*40
        draw.rectangle([book_x+80, y, book_x+book_size-30, y+20], fill=(255, 255, 255))

    # White play button
    play_size = int(size * 0.25)
    play_y = center + int(size * 0.1)
    draw.ellipse(
        [center-play_size-5, play_y-play_size-5, center+play_size+5, play_y+play_size+5],
        fill=(0, 0, 0, 80)
    )
    draw.ellipse(
        [center-play_size, play_y-play_size, center+play_size, play_y+play_size],
        fill=(255, 255, 255)
    )

    # Green play triangle
    tri_size = int(play_size * 0.7)
    offset_x = int(tri_size * 0.15)
    points = [
        (center - tri_size//2 + offset_x, play_y - tri_size),
        (center - tri_size//2 + offset_x, play_y + tri_size),
        (center + tri_size + offset_x, play_y)
    ]
    draw.polygon(points, fill=(76, 175, 80))

    # Decorative stars
    star_positions = [
        (int(size*0.15), int(size*0.15)),
        (int(size*0.85), int(size*0.20)),
        (int(size*0.15), int(size*0.80)),
        (int(size*0.85), int(size*0.75))
    ]

    for sx, sy in star_positions:
        star_size = 25
        star_points = []
        for i in range(10):
            angle = math.radians(i * 36 - 90)
            radius = star_size if i % 2 == 0 else star_size // 2.5
            x = sx + int(radius * math.cos(angle))
            y = sy + int(radius * math.sin(angle))
            star_points.append((x, y))
        draw.polygon(star_points, fill=(255, 255, 255))

    return img

def create_middle_icon(size=1024):
    """Middle (grades 7-9): Balanced, exploration theme with lightbulb"""
    img = Image.new('RGB', (size, size), (0, 150, 136))
    draw = ImageDraw.Draw(img)
    center = size // 2

    # Teal to green gradient
    for r in range(size//2, 0, -10):
        color = (
            int(0 + (76 - 0) * (1 - r/(size//2))),
            int(150 + (175 - 150) * (1 - r/(size//2))),
            int(136 + (80 - 136) * (1 - r/(size//2)))
        )
        draw.ellipse([center-r, center-r, center+r, center+r], fill=color)

    # Lightbulb
    bulb_radius = int(size * 0.25)
    bulb_y = int(size * 0.35)

    # Bulb shadow
    draw.ellipse(
        [center-bulb_radius+5, bulb_y-bulb_radius+5,
         center+bulb_radius+5, bulb_y+bulb_radius+5],
        fill=(0, 0, 0, 60)
    )

    # Bulb top - bright yellow
    draw.ellipse(
        [center-bulb_radius, bulb_y-bulb_radius,
         center+bulb_radius, bulb_y+bulb_radius],
        fill=(255, 235, 59)
    )

    # Bulb base - gray
    base_width = int(size * 0.16)
    base_height = int(size * 0.10)
    base_y = bulb_y + bulb_radius - 20

    draw.rounded_rectangle(
        [center-base_width, base_y, center+base_width, base_y+base_height],
        radius=10, fill=(158, 158, 158)
    )

    # Base detail lines
    for i in range(3):
        line_y = base_y + (i + 1) * (base_height // 4)
        draw.line([(center-base_width, line_y), (center+base_width, line_y)],
                  fill=(117, 117, 117), width=2)

    # Light rays
    ray_length = int(size * 0.15)
    ray_angles = [0, 45, 90, 135, 180, 225, 270, 315]

    for angle in ray_angles:
        rad = math.radians(angle)
        start_x = center + int((bulb_radius + 15) * math.cos(rad))
        start_y = bulb_y + int((bulb_radius + 15) * math.sin(rad))
        end_x = center + int((bulb_radius + 15 + ray_length) * math.cos(rad))
        end_y = bulb_y + int((bulb_radius + 15 + ray_length) * math.sin(rad))
        draw.line([(start_x, start_y), (end_x, end_y)], fill=(255, 255, 255), width=8)

    # Play button - white with teal triangle
    play_size = int(size * 0.13)
    play_y = int(size * 0.72)

    draw.ellipse(
        [center-play_size-3, play_y-play_size-3,
         center+play_size+3, play_y+play_size+3],
        fill=(0, 0, 0, 80)
    )
    draw.ellipse(
        [center-play_size, play_y-play_size, center+play_size, play_y+play_size],
        fill=(255, 255, 255)
    )

    tri_size = int(play_size * 0.6)
    tri_offset = int(tri_size * 0.2)
    tri_points = [
        (center - tri_size//2 + tri_offset, play_y - tri_size),
        (center - tri_size//2 + tri_offset, play_y + tri_size),
        (center + tri_size + tri_offset, play_y)
    ]
    draw.polygon(tri_points, fill=(0, 150, 136))

    return img

def create_preboard_icon(size=1024):
    """Preboard (grade 10): Achievement focus with trophy"""
    img = Image.new('RGB', (size, size), (255, 87, 34))
    draw = ImageDraw.Draw(img)
    center = size // 2

    # Orange to red gradient
    for r in range(size//2, 0, -10):
        color = (
            int(255 - (255 - 244) * (1 - r/(size//2))),
            int(87 - (87 - 67) * (1 - r/(size//2))),
            int(34 + (54 - 34) * (1 - r/(size//2)))
        )
        draw.ellipse([center-r, center-r, center+r, center+r], fill=color)

    # Target circles
    target_radii = [int(size*0.45), int(size*0.35), int(size*0.25)]
    for radius in target_radii:
        draw.ellipse(
            [center-radius, center-radius, center+radius, center+radius],
            outline=(255, 255, 255, 150), width=8
        )

    # Trophy
    trophy_width = int(size * 0.35)
    trophy_height = int(size * 0.40)

    cup_top_y = int(size * 0.30)
    cup_bottom_y = cup_top_y + int(trophy_height * 0.6)
    cup_top_width = int(trophy_width * 0.9)
    cup_bottom_width = int(trophy_width * 0.6)

    # Trophy shadow
    shadow_points = [
        (center - cup_top_width//2 + 5, cup_top_y + 5),
        (center + cup_top_width//2 + 5, cup_top_y + 5),
        (center + cup_bottom_width//2 + 5, cup_bottom_y + 5),
        (center - cup_bottom_width//2 + 5, cup_bottom_y + 5)
    ]
    draw.polygon(shadow_points, fill=(0, 0, 0, 100))

    # Trophy cup - gold
    cup_points = [
        (center - cup_top_width//2, cup_top_y),
        (center + cup_top_width//2, cup_top_y),
        (center + cup_bottom_width//2, cup_bottom_y),
        (center - cup_bottom_width//2, cup_bottom_y)
    ]
    draw.polygon(cup_points, fill=(255, 193, 7))

    # Trophy handles
    handle_width = 20
    handle_height = int(trophy_height * 0.35)
    left_handle_x = center - cup_top_width//2 - 25
    right_handle_x = center + cup_top_width//2 + 5
    handle_y = cup_top_y + 20

    draw.ellipse(
        [left_handle_x, handle_y, left_handle_x+handle_width, handle_y+handle_height],
        outline=(255, 193, 7), width=8
    )
    draw.ellipse(
        [right_handle_x, handle_y, right_handle_x+handle_width, handle_y+handle_height],
        outline=(255, 193, 7), width=8
    )

    # Trophy base
    base_width = int(trophy_width * 0.7)
    base_height = 25
    base_y = cup_bottom_y + 5

    draw.rounded_rectangle(
        [center-base_width//2, base_y, center+base_width//2, base_y+base_height],
        radius=8, fill=(255, 193, 7)
    )

    # Star on trophy
    star_y = cup_top_y + int(trophy_height * 0.2)
    star_size = 30
    star_points = []
    for i in range(10):
        angle = math.radians(i * 36 - 90)
        radius = star_size if i % 2 == 0 else star_size // 2
        x = center + int(radius * math.cos(angle))
        y = star_y + int(radius * math.sin(angle))
        star_points.append((x, y))
    draw.polygon(star_points, fill=(255, 255, 255))

    # Play button - white with orange triangle
    play_size = int(size * 0.12)
    play_y = int(size * 0.75)

    draw.ellipse(
        [center-play_size, play_y-play_size, center+play_size, play_y+play_size],
        fill=(255, 255, 255)
    )

    tri_size = int(play_size * 0.6)
    tri_offset = int(tri_size * 0.2)
    tri_points = [
        (center - tri_size//2 + tri_offset, play_y - tri_size),
        (center - tri_size//2 + tri_offset, play_y + tri_size),
        (center + tri_size + tri_offset, play_y)
    ]
    draw.polygon(tri_points, fill=(255, 87, 34))

    return img

def create_senior_icon(size=1024):
    """Senior (grades 11-12): Professional graduation theme"""
    img = Image.new('RGB', (size, size), (63, 81, 181))
    draw = ImageDraw.Draw(img)
    center = size // 2

    # Deep purple gradient
    for r in range(size//2, 0, -10):
        color = (
            63 + int((48 - 63) * (1 - r/(size//2))),
            81 + int((63 - 81) * (1 - r/(size//2))),
            181 + int((159 - 181) * (1 - r/(size//2)))
        )
        draw.ellipse([center-r, center-r, center+r, center+r], fill=color)

    # Graduation cap
    cap_size = int(size * 0.55)
    cap_y = int(size * 0.25)

    # Cap board (top part)
    points = [
        (center - cap_size//2 - 40, cap_y + 40),
        (center + cap_size//2 + 40, cap_y + 40),
        (center + cap_size//2 + 20, cap_y + 80),
        (center - cap_size//2 - 20, cap_y + 80)
    ]
    # Shadow
    shadow_points = [(x+8, y+8) for x, y in points]
    draw.polygon(shadow_points, fill=(0, 0, 0, 100))
    # Gold board
    draw.polygon(points, fill=(255, 193, 7))

    # Center button
    button_r = 45
    draw.ellipse(
        [center-button_r, cap_y+60-button_r, center+button_r, cap_y+60+button_r],
        fill=(255, 235, 59)
    )

    # Tassel
    draw.line([(center, cap_y+60), (center+80, cap_y+150)], fill=(255, 193, 7), width=8)
    draw.ellipse([center+60, cap_y+130, center+100, cap_y+170], fill=(255, 193, 7))

    # Book stack
    books = [
        {'y': int(size*0.52), 'width': int(size*0.50), 'height': 55, 'color': (123, 31, 162)},
        {'y': int(size*0.61), 'width': int(size*0.55), 'height': 55, 'color': (81, 45, 168)},
        {'y': int(size*0.70), 'width': int(size*0.48), 'height': 55, 'color': (94, 53, 177)}
    ]

    for book in books:
        bx = (size - book['width']) // 2
        # Shadow
        draw.rounded_rectangle(
            [bx+6, book['y']+6, bx+book['width']+6, book['y']+book['height']+6],
            radius=15, fill=(0, 0, 0, 80)
        )
        # Book
        draw.rounded_rectangle(
            [bx, book['y'], bx+book['width'], book['y']+book['height']],
            radius=15, fill=book['color']
        )
        # Spine
        draw.rectangle(
            [bx+15, book['y']+10, bx+30, book['y']+book['height']-10],
            fill=(book['color'][0]+30, book['color'][1]+30, book['color'][2]+30)
        )

    # Play button - teal accent
    play_size = int(size * 0.13)
    play_y = int(size * 0.75)

    # Glow
    for i in range(8):
        glow_size = play_size + i*4
        alpha = int(40 * (1 - i/8))
        draw.ellipse(
            [center-glow_size, play_y-glow_size, center+glow_size, play_y+glow_size],
            fill=(0, 188, 212, alpha)
        )

    # Button
    draw.ellipse(
        [center-play_size, play_y-play_size, center+play_size, play_y+play_size],
        fill=(255, 255, 255)
    )

    # Triangle
    tri_size = int(play_size * 0.65)
    tri_points = [
        (center - tri_size//2 + 10, play_y - tri_size),
        (center - tri_size//2 + 10, play_y + tri_size),
        (center + tri_size + 10, play_y)
    ]
    draw.polygon(tri_points, fill=(0, 188, 212))

    return img

def main():
    icons_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'assets', 'icons')
    os.makedirs(icons_dir, exist_ok=True)

    print("🎨 Generating ALL Crack the Code App Icons")
    print("=" * 50)
    print("")

    icons = {
        'junior': ('Junior (Grades 4-7)', create_junior_icon, 'Bright blue & orange book'),
        'middle': ('Middle (Grades 7-9)', create_middle_icon, 'Teal/green lightbulb'),
        'preboard': ('Preboard (Grade 10)', create_preboard_icon, 'Orange/red trophy'),
        'senior': ('Senior (Grades 11-12)', create_senior_icon, 'Purple graduation cap'),
    }

    for key, (name, func, desc) in icons.items():
        print(f"📱 {name}")
        print(f"   Theme: {desc}")
        icon = func(1024)
        path = os.path.join(icons_dir, f'icon_{key}.png')
        icon.save(path, 'PNG')
        print(f"   ✅ Saved: {path}")
        print("")

    print("=" * 50)
    print("✨ All 4 icons generated successfully!")
    print("")
    print("Next steps:")
    print("  1. Run: bash scripts/apply_all_icons.sh")
    print("  2. Build each flavor and test")

if __name__ == '__main__':
    main()
