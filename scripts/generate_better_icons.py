#!/usr/bin/env python3
"""
Generate distinctive app icons for StreamShaala segments using actual PNG composition
"""

from PIL import Image, ImageDraw, ImageFont
import os
import math

def create_junior_icon_improved(size=1024):
    """Junior: Bright, playful with clear visual elements"""
    # Create base with radial gradient
    img = Image.new('RGB', (size, size), (33, 150, 243))  # Bright blue
    draw = ImageDraw.Draw(img)

    center = size // 2

    # Create vibrant background with circular gradient
    for r in range(size//2, 0, -10):
        alpha = int(255 * (r / (size//2)))
        color = (
            33 + int((100 - 33) * (1 - r/(size//2))),
            150 + int((181 - 150) * (1 - r/(size//2))),
            243 + int((246 - 243) * (1 - r/(size//2)))
        )
        draw.ellipse([center-r, center-r, center+r, center+r], fill=color)

    # Large book shape - Orange
    book_size = int(size * 0.5)
    book_x = center - book_size//2
    book_y = int(size * 0.25)

    # Book shadow
    shadow_color = (200, 100, 0)
    draw.rounded_rectangle(
        [book_x+15, book_y+15, book_x+book_size+15, book_y+book_size+15],
        radius=40, fill=shadow_color
    )

    # Book body - Bright orange
    draw.rounded_rectangle(
        [book_x, book_y, book_x+book_size, book_y+book_size],
        radius=40, fill=(255, 152, 0)
    )

    # Book spine - Yellow accent
    draw.rectangle(
        [book_x+20, book_y+20, book_x+60, book_y+book_size-20],
        fill=(255, 193, 7)
    )

    # Book pages - white lines
    for i in range(3):
        y = book_y + 80 + i*40
        draw.rectangle(
            [book_x+80, y, book_x+book_size-30, y+20],
            fill=(255, 255, 255)
        )

    # Large white play button circle
    play_size = int(size * 0.25)
    play_x = center
    play_y = center + int(size * 0.1)

    # Play button shadow
    draw.ellipse(
        [play_x-play_size-5, play_y-play_size-5,
         play_x+play_size+5, play_y+play_size+5],
        fill=(0, 0, 0, 80)
    )

    # Play button - White
    draw.ellipse(
        [play_x-play_size, play_y-play_size, play_x+play_size, play_y+play_size],
        fill=(255, 255, 255)
    )

    # Play triangle - Green
    triangle_size = int(play_size * 0.7)
    offset_x = int(triangle_size * 0.15)
    points = [
        (play_x - triangle_size//2 + offset_x, play_y - triangle_size),
        (play_x - triangle_size//2 + offset_x, play_y + triangle_size),
        (play_x + triangle_size + offset_x, play_y)
    ]
    draw.polygon(points, fill=(76, 175, 80))

    # Add decorative stars
    star_positions = [
        (int(size*0.15), int(size*0.15)),
        (int(size*0.85), int(size*0.20)),
        (int(size*0.15), int(size*0.80)),
        (int(size*0.85), int(size*0.75))
    ]

    for sx, sy in star_positions:
        star_size = 25
        # 5-pointed star
        star_points = []
        for i in range(10):
            angle = math.radians(i * 36 - 90)
            radius = star_size if i % 2 == 0 else star_size // 2.5
            x = sx + int(radius * math.cos(angle))
            y = sy + int(radius * math.sin(angle))
            star_points.append((x, y))
        draw.polygon(star_points, fill=(255, 255, 255))

    return img

def create_senior_icon_improved(size=1024):
    """Senior: Professional, sophisticated graduation theme"""
    # Deep purple gradient background
    img = Image.new('RGB', (size, size), (63, 81, 181))
    draw = ImageDraw.Draw(img)

    center = size // 2

    # Radial gradient
    for r in range(size//2, 0, -10):
        color = (
            63 + int((48 - 63) * (1 - r/(size//2))),
            81 + int((63 - 81) * (1 - r/(size//2))),
            181 + int((159 - 181) * (1 - r/(size//2)))
        )
        draw.ellipse([center-r, center-r, center+r, center+r], fill=color)

    # Graduation cap - Gold
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
    # Main board - Gold
    draw.polygon(points, fill=(255, 193, 7))

    # Center button
    button_r = 45
    draw.ellipse(
        [center-button_r, cap_y+60-button_r,
         center+button_r, cap_y+60+button_r],
        fill=(255, 235, 59)
    )

    # Tassel
    draw.line([(center, cap_y+60), (center+80, cap_y+150)], fill=(255, 193, 7), width=8)
    draw.ellipse([center+60, cap_y+130, center+100, cap_y+170], fill=(255, 193, 7))

    # Books stack below
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

    # Play button - Teal accent
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

    print("🎨 Generating improved StreamShaala app icons...")
    print("")

    # Generate Junior icon
    print("  📱 Creating Junior icon (improved)...")
    junior_icon = create_junior_icon_improved(1024)
    junior_path = os.path.join(icons_dir, 'icon_junior.png')
    junior_icon.save(junior_path, 'PNG')
    print(f"     ✅ Saved: {junior_path}")

    # Generate Senior icon
    print("  📱 Creating Senior icon (improved)...")
    senior_icon = create_senior_icon_improved(1024)
    senior_path = os.path.join(icons_dir, 'icon_senior.png')
    senior_icon.save(senior_path, 'PNG')
    print(f"     ✅ Saved: {senior_path}")

    print("\n✨ Improved icons generated!")
    print("\n📝 Next: Run 'bash scripts/apply_icons.sh' to apply them")

if __name__ == '__main__':
    main()
