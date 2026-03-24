#!/usr/bin/env python3
"""
Generate app icons for Crack the Code segments
Each segment gets a unique, professionally designed icon
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_gradient_background(size, color1, color2):
    """Create a gradient background"""
    base = Image.new('RGB', (size, size), color1)
    draw = ImageDraw.Draw(base)

    for i in range(size):
        # Linear gradient from top to bottom
        r = int(color1[0] + (color2[0] - color1[0]) * i / size)
        g = int(color1[1] + (color2[1] - color1[1]) * i / size)
        b = int(color1[2] + (color2[2] - color1[2]) * i / size)
        draw.line([(0, i), (size, i)], fill=(r, g, b))

    return base

def draw_rounded_rectangle(draw, xy, radius, fill):
    """Draw a rounded rectangle"""
    x1, y1, x2, y2 = xy
    draw.rectangle([x1 + radius, y1, x2 - radius, y2], fill=fill)
    draw.rectangle([x1, y1 + radius, x2, y2 - radius], fill=fill)
    draw.pieslice([x1, y1, x1 + radius * 2, y1 + radius * 2], 180, 270, fill=fill)
    draw.pieslice([x2 - radius * 2, y1, x2, y1 + radius * 2], 270, 360, fill=fill)
    draw.pieslice([x1, y2 - radius * 2, x1 + radius * 2, y2], 90, 180, fill=fill)
    draw.pieslice([x2 - radius * 2, y2 - radius * 2, x2, y2], 0, 90, fill=fill)

def create_junior_icon(size=1024):
    """
    Junior app icon: Playful, bright, welcoming (grades 4-7)
    Theme: Rocket launching into learning
    Colors: Bright blue and orange gradient
    """
    # Gradient background - sky blue to light blue
    img = create_gradient_background(size, (33, 150, 243), (100, 181, 246))
    draw = ImageDraw.Draw(img)

    # Add circular glow in center
    center = size // 2
    for i in range(10):
        alpha = int(255 * (1 - i / 10) * 0.1)
        radius = int(size * 0.6) + i * 10
        draw.ellipse([center - radius, center - radius, center + radius, center + radius],
                     fill=(255, 255, 255, alpha))

    # Draw a stylized book/learning icon with play button
    # Book base
    book_width = int(size * 0.5)
    book_height = int(size * 0.6)
    book_x = (size - book_width) // 2
    book_y = int(size * 0.25)

    # Book shadow
    shadow_offset = 8
    draw_rounded_rectangle(draw,
                          [book_x + shadow_offset, book_y + shadow_offset,
                           book_x + book_width + shadow_offset, book_y + book_height + shadow_offset],
                          30, (0, 0, 0, 50))

    # Book body - vibrant orange
    draw_rounded_rectangle(draw,
                          [book_x, book_y, book_x + book_width, book_y + book_height],
                          30, (255, 152, 0))

    # Book spine highlight
    draw.rectangle([book_x + 10, book_y + 10, book_x + 40, book_y + book_height - 10],
                   fill=(255, 193, 7))

    # Play button in center - white circle with triangle
    play_center_x = center
    play_center_y = center + int(size * 0.05)
    play_radius = int(size * 0.15)

    # Play button circle - white with shadow
    draw.ellipse([play_center_x - play_radius - 3, play_center_y - play_radius - 3,
                  play_center_x + play_radius + 3, play_center_y + play_radius + 3],
                 fill=(0, 0, 0, 80))
    draw.ellipse([play_center_x - play_radius, play_center_y - play_radius,
                  play_center_x + play_radius, play_center_y + play_radius],
                 fill=(255, 255, 255))

    # Play triangle - bright green
    triangle_size = int(play_radius * 0.6)
    triangle_offset_x = int(triangle_size * 0.2)
    triangle_points = [
        (play_center_x - triangle_size // 2 + triangle_offset_x, play_center_y - triangle_size),
        (play_center_x - triangle_size // 2 + triangle_offset_x, play_center_y + triangle_size),
        (play_center_x + triangle_size + triangle_offset_x, play_center_y)
    ]
    draw.polygon(triangle_points, fill=(76, 175, 80))

    # Add sparkles for playfulness
    sparkle_positions = [
        (int(size * 0.15), int(size * 0.20)),
        (int(size * 0.85), int(size * 0.30)),
        (int(size * 0.20), int(size * 0.75)),
        (int(size * 0.80), int(size * 0.80))
    ]

    for x, y in sparkle_positions:
        sparkle_size = 15
        draw.polygon([
            (x, y - sparkle_size),
            (x + sparkle_size // 3, y - sparkle_size // 3),
            (x + sparkle_size, y),
            (x + sparkle_size // 3, y + sparkle_size // 3),
            (x, y + sparkle_size),
            (x - sparkle_size // 3, y + sparkle_size // 3),
            (x - sparkle_size, y),
            (x - sparkle_size // 3, y - sparkle_size // 3),
        ], fill=(255, 255, 255))

    return img

def create_senior_icon(size=1024):
    """
    Senior app icon: Professional, sophisticated (grades 11-12)
    Theme: Academic excellence with modern touch
    Colors: Deep purple and teal gradient
    """
    # Gradient background - deep purple to dark blue
    img = create_gradient_background(size, (63, 81, 181), (48, 63, 159))
    draw = ImageDraw.Draw(img)

    # Subtle geometric pattern background
    center = size // 2
    for i in range(3):
        radius = int(size * (0.3 + i * 0.15))
        draw.ellipse([center - radius, center - radius, center + radius, center + radius],
                     outline=(255, 255, 255, 30), width=2)

    # Academic cap (graduation cap) - modern style
    cap_width = int(size * 0.6)
    cap_height = int(size * 0.08)
    cap_x = (size - cap_width) // 2
    cap_y = int(size * 0.3)

    # Cap board - teal accent
    board_points = [
        (cap_x - 30, cap_y + 30),
        (cap_x + cap_width + 30, cap_y + 30),
        (cap_x + cap_width + 10, cap_y + 60),
        (cap_x - 10, cap_y + 60)
    ]
    # Shadow
    shadow_points = [(x + 5, y + 5) for x, y in board_points]
    draw.polygon(shadow_points, fill=(0, 0, 0, 80))
    # Main board
    draw.polygon(board_points, fill=(0, 188, 212))

    # Cap center button
    button_size = 35
    button_x = center
    button_y = cap_y + 45
    draw.ellipse([button_x - button_size, button_y - button_size,
                  button_x + button_size, button_y + button_size],
                 fill=(255, 193, 7))

    # Book stack below cap - modern minimalist
    books = [
        {'y': int(size * 0.50), 'width': int(size * 0.45), 'height': 35, 'color': (156, 39, 176)},
        {'y': int(size * 0.57), 'width': int(size * 0.50), 'height': 35, 'color': (103, 58, 183)},
        {'y': int(size * 0.64), 'width': int(size * 0.42), 'height': 35, 'color': (63, 81, 181)}
    ]

    for book in books:
        book_x = (size - book['width']) // 2
        # Shadow
        draw_rounded_rectangle(draw,
                              [book_x + 4, book['y'] + 4,
                               book_x + book['width'] + 4, book['y'] + book['height'] + 4],
                              10, (0, 0, 0, 60))
        # Book
        draw_rounded_rectangle(draw,
                              [book_x, book['y'],
                               book_x + book['width'], book['y'] + book['height']],
                              10, book['color'])
        # Highlight line
        draw.line([(book_x + 15, book['y'] + book['height'] // 2),
                   (book_x + book['width'] - 15, book['y'] + book['height'] // 2)],
                  fill=(255, 255, 255, 100), width=3)

    # Play button overlay - clean modern design
    play_center_y = int(size * 0.70)
    play_radius = int(size * 0.12)

    # Glow effect
    for i in range(5):
        glow_radius = play_radius + i * 5
        alpha = int(50 * (1 - i / 5))
        draw.ellipse([center - glow_radius, play_center_y - glow_radius,
                      center + glow_radius, play_center_y + glow_radius],
                     fill=(255, 255, 255, alpha))

    # Play button
    draw.ellipse([center - play_radius, play_center_y - play_radius,
                  center + play_radius, play_center_y + play_radius],
                 fill=(255, 255, 255))

    # Play triangle
    triangle_size = int(play_radius * 0.55)
    triangle_offset_x = int(triangle_size * 0.15)
    triangle_points = [
        (center - triangle_size // 2 + triangle_offset_x, play_center_y - triangle_size),
        (center - triangle_size // 2 + triangle_offset_x, play_center_y + triangle_size),
        (center + triangle_size + triangle_offset_x, play_center_y)
    ]
    draw.polygon(triangle_points, fill=(0, 188, 212))

    return img

def create_middle_icon(size=1024):
    """
    Middle app icon: Balanced between playful and professional (grades 7-9)
    Theme: Growth and exploration
    Colors: Green and blue gradient
    """
    # Gradient background - teal to green
    img = create_gradient_background(size, (0, 150, 136), (76, 175, 80))
    draw = ImageDraw.Draw(img)

    center = size // 2

    # Circular background elements
    for i in range(4):
        radius = int(size * (0.25 + i * 0.08))
        alpha = int(30 * (1 - i / 4))
        draw.ellipse([center - radius, center - radius, center + radius, center + radius],
                     outline=(255, 255, 255, alpha), width=3)

    # Central icon - lightbulb representing ideas/learning
    bulb_width = int(size * 0.35)
    bulb_height = int(size * 0.45)
    bulb_x = center
    bulb_y = int(size * 0.35)

    # Bulb top (rounded) - yellow
    bulb_radius = int(bulb_width * 0.7)
    draw.ellipse([bulb_x - bulb_radius, bulb_y - bulb_radius,
                  bulb_x + bulb_radius, bulb_y + bulb_radius],
                 fill=(255, 235, 59))

    # Bulb base - gray
    base_width = int(bulb_width * 0.5)
    base_height = int(bulb_height * 0.25)
    base_y = bulb_y + bulb_radius - 20
    draw_rounded_rectangle(draw,
                          [bulb_x - base_width, base_y,
                           bulb_x + base_width, base_y + base_height],
                          10, (158, 158, 158))

    # Add lines for base detail
    for i in range(3):
        line_y = base_y + (i + 1) * (base_height // 4)
        draw.line([(bulb_x - base_width, line_y), (bulb_x + base_width, line_y)],
                  fill=(117, 117, 117), width=2)

    # Light rays
    ray_length = int(size * 0.15)
    ray_angles = [0, 45, 90, 135, 180, 225, 270, 315]
    import math

    for angle in ray_angles:
        rad = math.radians(angle)
        start_x = bulb_x + int((bulb_radius + 15) * math.cos(rad))
        start_y = bulb_y + int((bulb_radius + 15) * math.sin(rad))
        end_x = bulb_x + int((bulb_radius + 15 + ray_length) * math.cos(rad))
        end_y = bulb_y + int((bulb_radius + 15 + ray_length) * math.sin(rad))
        draw.line([(start_x, start_y), (end_x, end_y)], fill=(255, 255, 255), width=8)

    # Play button
    play_y = int(size * 0.70)
    play_radius = int(size * 0.13)

    # Shadow
    draw.ellipse([center - play_radius - 3, play_y - play_radius - 3,
                  center + play_radius + 3, play_y + play_radius + 3],
                 fill=(0, 0, 0, 80))

    # Button
    draw.ellipse([center - play_radius, play_y - play_radius,
                  center + play_radius, play_y + play_radius],
                 fill=(255, 255, 255))

    # Triangle
    triangle_size = int(play_radius * 0.6)
    triangle_offset_x = int(triangle_size * 0.2)
    triangle_points = [
        (center - triangle_size // 2 + triangle_offset_x, play_y - triangle_size),
        (center - triangle_size // 2 + triangle_offset_x, play_y + triangle_size),
        (center + triangle_size + triangle_offset_x, play_y)
    ]
    draw.polygon(triangle_points, fill=(0, 150, 136))

    return img

def create_preboard_icon(size=1024):
    """
    Preboard app icon: Focus and achievement (grade 10)
    Theme: Target and success
    Colors: Deep orange and red gradient
    """
    # Gradient background - orange to deep orange
    img = create_gradient_background(size, (255, 87, 34), (244, 67, 54))
    draw = ImageDraw.Draw(img)

    center = size // 2

    # Target circles - representing focus
    target_colors = [(255, 255, 255, 150), (255, 255, 255, 100), (255, 255, 255, 50)]
    target_radii = [int(size * 0.45), int(size * 0.35), int(size * 0.25)]

    for radius, color in zip(target_radii, target_colors):
        draw.ellipse([center - radius, center - radius, center + radius, center + radius],
                     outline=color, width=8)

    # Trophy/achievement icon in center
    trophy_width = int(size * 0.35)
    trophy_height = int(size * 0.40)

    # Trophy cup
    cup_top_y = int(size * 0.30)
    cup_bottom_y = cup_top_y + int(trophy_height * 0.6)
    cup_top_width = int(trophy_width * 0.9)
    cup_bottom_width = int(trophy_width * 0.6)

    # Shadow
    shadow_points = [
        (center - cup_top_width // 2 + 5, cup_top_y + 5),
        (center + cup_top_width // 2 + 5, cup_top_y + 5),
        (center + cup_bottom_width // 2 + 5, cup_bottom_y + 5),
        (center - cup_bottom_width // 2 + 5, cup_bottom_y + 5)
    ]
    draw.polygon(shadow_points, fill=(0, 0, 0, 100))

    # Cup body - gold
    cup_points = [
        (center - cup_top_width // 2, cup_top_y),
        (center + cup_top_width // 2, cup_top_y),
        (center + cup_bottom_width // 2, cup_bottom_y),
        (center - cup_bottom_width // 2, cup_bottom_y)
    ]
    draw.polygon(cup_points, fill=(255, 193, 7))

    # Trophy handles
    handle_width = 20
    handle_height = int(trophy_height * 0.35)
    left_handle_x = center - cup_top_width // 2 - 25
    right_handle_x = center + cup_top_width // 2 + 5
    handle_y = cup_top_y + 20

    # Left handle
    draw.ellipse([left_handle_x, handle_y, left_handle_x + handle_width, handle_y + handle_height],
                 outline=(255, 193, 7), width=8)
    # Right handle
    draw.ellipse([right_handle_x, handle_y, right_handle_x + handle_width, handle_y + handle_height],
                 outline=(255, 193, 7), width=8)

    # Trophy base
    base_width = int(trophy_width * 0.7)
    base_height = 25
    base_y = cup_bottom_y + 5
    draw_rounded_rectangle(draw,
                          [center - base_width // 2, base_y,
                           center + base_width // 2, base_y + base_height],
                          8, (255, 193, 7))

    # Star on trophy
    star_y = cup_top_y + int(trophy_height * 0.2)
    star_size = 30
    import math

    star_points = []
    for i in range(10):
        angle = math.radians(i * 36 - 90)
        radius = star_size if i % 2 == 0 else star_size // 2
        x = center + int(radius * math.cos(angle))
        y = star_y + int(radius * math.sin(angle))
        star_points.append((x, y))
    draw.polygon(star_points, fill=(255, 255, 255))

    # Play button
    play_y = int(size * 0.75)
    play_radius = int(size * 0.12)

    draw.ellipse([center - play_radius, play_y - play_radius,
                  center + play_radius, play_y + play_radius],
                 fill=(255, 255, 255))

    triangle_size = int(play_radius * 0.6)
    triangle_offset_x = int(triangle_size * 0.2)
    triangle_points = [
        (center - triangle_size // 2 + triangle_offset_x, play_y - triangle_size),
        (center - triangle_size // 2 + triangle_offset_x, play_y + triangle_size),
        (center + triangle_size + triangle_offset_x, play_y)
    ]
    draw.polygon(triangle_points, fill=(255, 87, 34))

    return img

def main():
    # Create assets/icons directory if it doesn't exist
    icons_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'assets', 'icons')
    os.makedirs(icons_dir, exist_ok=True)

    print("🎨 Generating Crack the Code app icons...")

    # Generate icons for each segment
    segments = {
        'junior': create_junior_icon,
        'middle': create_middle_icon,
        'senior': create_senior_icon,
        'preboard': create_preboard_icon
    }

    for segment_name, create_func in segments.items():
        print(f"  📱 Creating {segment_name} icon...")
        icon = create_func(1024)
        output_path = os.path.join(icons_dir, f'icon_{segment_name}.png')
        icon.save(output_path, 'PNG')
        print(f"     ✅ Saved: {output_path}")

    print("\n✨ All icons generated successfully!")
    print(f"📂 Icons saved to: {icons_dir}")
    print("\nNext steps:")
    print("  1. Run: flutter pub get")
    print("  2. Run: dart run flutter_launcher_icons")
    print("  3. Icons will be automatically applied to all platforms")

if __name__ == '__main__':
    main()
