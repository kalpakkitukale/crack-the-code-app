#!/usr/bin/env python3
"""
Generate multiple icon design options for each app flavor.
Creates 10+ variations per flavor for user selection.
"""

from PIL import Image, ImageDraw, ImageFont
import math
import os

OUTPUT_DIR = "assets/icons/options"
SIZE = 1024

def create_output_dir():
    """Create output directory for icon options."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for flavor in ['junior', 'middle', 'preboard', 'senior']:
        os.makedirs(f"{OUTPUT_DIR}/{flavor}", exist_ok=True)

def draw_star(draw, cx, cy, size, points=5, fill=(255, 255, 255)):
    """Draw a star shape."""
    outer_radius = size
    inner_radius = size * 0.4
    angle = math.pi / 2
    step = 2 * math.pi / points

    star_points = []
    for i in range(points * 2):
        radius = outer_radius if i % 2 == 0 else inner_radius
        x = cx + radius * math.cos(angle)
        y = cy - radius * math.sin(angle)
        star_points.append((x, y))
        angle += step / 2

    draw.polygon(star_points, fill=fill)

def draw_book(draw, x, y, width, height, color, page_color=(255, 255, 255)):
    """Draw a book shape."""
    # Book cover
    draw.rounded_rectangle([x, y, x + width, y + height], radius=20, fill=color)

    # Pages on right side
    page_width = width * 0.15
    for i in range(3):
        offset = (i + 1) * 8
        draw.rectangle([x + width - page_width - offset, y + 10,
                       x + width - offset, y + height - 10], fill=page_color)

def draw_play_button(draw, cx, cy, size, bg_color=(255, 255, 255), triangle_color=(0, 0, 0)):
    """Draw a play button."""
    # Circle background
    draw.ellipse([cx - size, cy - size, cx + size, cy + size], fill=bg_color)

    # Triangle
    triangle_size = size * 0.6
    points = [
        (cx - triangle_size * 0.3, cy - triangle_size),
        (cx - triangle_size * 0.3, cy + triangle_size),
        (cx + triangle_size * 0.8, cy)
    ]
    draw.polygon(points, fill=triangle_color)

def draw_lightbulb(draw, cx, cy, size, bulb_color=(255, 215, 0), base_color=(200, 200, 200)):
    """Draw a lightbulb."""
    # Bulb
    draw.ellipse([cx - size, cy - size, cx + size, cy + size], fill=bulb_color)

    # Base
    base_height = size * 0.6
    base_width = size * 0.8
    draw.rectangle([cx - base_width, cy + size * 0.7,
                   cx + base_width, cy + size * 0.7 + base_height], fill=base_color)

    # Light rays
    ray_length = size * 0.5
    for angle in [0, 45, 90, 135, 180, 225, 270, 315]:
        rad = math.radians(angle)
        x1 = cx + (size + 10) * math.cos(rad)
        y1 = cy + (size + 10) * math.sin(rad)
        x2 = cx + (size + ray_length) * math.cos(rad)
        y2 = cy + (size + ray_length) * math.sin(rad)
        draw.line([x1, y1, x2, y2], fill=bulb_color, width=15)

def draw_trophy(draw, cx, cy, size, color=(255, 215, 0)):
    """Draw a trophy."""
    # Cup
    cup_width = size * 1.5
    cup_height = size * 1.2
    draw.polygon([
        (cx - cup_width * 0.8, cy - cup_height),
        (cx + cup_width * 0.8, cy - cup_height),
        (cx + cup_width, cy),
        (cx - cup_width, cy)
    ], fill=color)

    # Handles
    handle_size = size * 0.6
    draw.arc([cx - cup_width * 1.2, cy - cup_height * 0.7,
             cx - cup_width * 0.6, cy - cup_height * 0.2],
             start=270, end=90, fill=color, width=20)
    draw.arc([cx + cup_width * 0.6, cy - cup_height * 0.7,
             cx + cup_width * 1.2, cy - cup_height * 0.2],
             start=90, end=270, fill=color, width=20)

    # Base
    base_width = size * 0.8
    base_height = size * 0.4
    draw.rectangle([cx - base_width, cy, cx + base_width, cy + base_height], fill=color)

    # Star on trophy
    draw_star(draw, cx, cy - cup_height * 0.6, size * 0.3, fill=(255, 255, 255))

def draw_graduation_cap(draw, cx, cy, size, cap_color=(0, 0, 0), tassel_color=(255, 215, 0)):
    """Draw a graduation cap."""
    # Top board
    board_size = size * 1.5
    draw.polygon([
        (cx, cy - size * 0.2),
        (cx + board_size, cy + size * 0.2),
        (cx, cy + size * 0.6),
        (cx - board_size, cy + size * 0.2)
    ], fill=cap_color)

    # Cap base
    draw.ellipse([cx - size, cy, cx + size, cy + size * 1.5], fill=cap_color)

    # Tassel
    draw.line([cx, cy - size * 0.2, cx + size * 0.5, cy - size * 0.8], fill=tassel_color, width=10)
    draw.ellipse([cx + size * 0.4, cy - size, cx + size * 0.6, cy - size * 0.8], fill=tassel_color)

# ==================== JUNIOR FLAVOR ICONS ====================

def junior_option_1():
    """Bright gradient with book and stars - Playful primary colors."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Blue to cyan gradient
    for y in range(SIZE):
        color = (33, 150 + int(y/SIZE * 93), 243)
        draw.line([(0, y), (SIZE, y)], fill=color)

    # Large orange book
    draw_book(draw, SIZE//2 - 250, SIZE//2 - 150, 500, 350, (255, 152, 0))

    # White play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 50, 120, (255, 255, 255), (76, 175, 80))

    # Stars in corners
    for x, y in [(200, 200), (SIZE-200, 200), (200, SIZE-200), (SIZE-200, SIZE-200)]:
        draw_star(draw, x, y, 40, fill=(255, 255, 0))

    return img

def junior_option_2():
    """Purple and yellow - Creative theme."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Purple to pink gradient
    for y in range(SIZE):
        r = 103 + int(y/SIZE * 100)
        g = 58
        b = 183 - int(y/SIZE * 50)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Yellow book with pencil
    draw_book(draw, SIZE//2 - 200, SIZE//2 - 100, 400, 280, (255, 235, 59))

    # Pencil shape
    draw.polygon([
        (SIZE//2 + 100, SIZE//2 - 200),
        (SIZE//2 + 150, SIZE//2 - 150),
        (SIZE//2 + 120, SIZE//2 - 120)
    ], fill=(255, 152, 0))
    draw.rectangle([SIZE//2 + 80, SIZE//2 - 120, SIZE//2 + 120, SIZE//2 + 100],
                  fill=(255, 193, 7))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 150, 100, (255, 255, 255), (103, 58, 183))

    return img

def junior_option_3():
    """Green nature theme with ABC blocks."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Green gradient
    for y in range(SIZE):
        g = 200 - int(y/SIZE * 50)
        draw.line([(0, y), (SIZE, y)], fill=(76, g, 80))

    # ABC blocks
    block_size = 150
    colors = [(244, 67, 54), (33, 150, 243), (255, 235, 59)]
    positions = [(SIZE//2 - 200, SIZE//2 - 100), (SIZE//2, SIZE//2 - 100), (SIZE//2 + 200, SIZE//2 - 100)]

    for i, (x, y) in enumerate(positions):
        # Block
        draw.rounded_rectangle([x - block_size//2, y, x + block_size//2, y + block_size],
                              radius=15, fill=colors[i])
        # Shadow
        draw.rounded_rectangle([x - block_size//2 + 10, y + block_size,
                              x + block_size//2 + 10, y + block_size + 20],
                              radius=15, fill=(0, 0, 0, 50))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 250, 120, (255, 255, 255), (76, 175, 80))

    return img

def junior_option_4():
    """Ocean theme - Blue with waves."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Ocean blue gradient
    for y in range(SIZE):
        b = 200 + int(y/SIZE * 55)
        draw.line([(0, y), (SIZE, y)], fill=(3, 169, b))

    # Book as a boat
    draw_book(draw, SIZE//2 - 220, SIZE//2 - 50, 440, 300, (255, 193, 7))

    # Sail (triangle)
    draw.polygon([
        (SIZE//2, SIZE//2 - 300),
        (SIZE//2, SIZE//2 + 100),
        (SIZE//2 + 200, SIZE//2 + 100)
    ], fill=(255, 255, 255))

    # Play button on sail
    draw_play_button(draw, SIZE//2 + 80, SIZE//2 - 50, 80, (255, 193, 7), (3, 169, 244))

    # Waves
    for i in range(5):
        y = SIZE - 100 - i * 30
        draw.arc([0 - i*100, y, 300 - i*100, y + 60], start=0, end=180, fill=(255, 255, 255), width=20)

    return img

def junior_option_5():
    """Rainbow theme - Multi-color fun."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Rainbow arcs as background
    colors = [(244, 67, 54), (255, 152, 0), (255, 235, 59), (76, 175, 80), (33, 150, 243), (103, 58, 183)]
    center = SIZE // 2

    for i, color in enumerate(colors):
        radius = 400 - i * 60
        draw.ellipse([center - radius, center - radius, center + radius, center + radius],
                    outline=color, width=50)

    # Central book
    draw_book(draw, SIZE//2 - 180, SIZE//2 - 120, 360, 240, (255, 255, 255), (244, 67, 54))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 200, 100, (255, 193, 7), (244, 67, 54))

    return img

def junior_option_6():
    """Space theme - Stars and planets."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Dark space background
    for y in range(SIZE):
        b = 30 + int(y/SIZE * 40)
        draw.line([(0, y), (SIZE, y)], fill=(10, 10, b))

    # Planet (book-shaped)
    draw.ellipse([SIZE//2 - 250, SIZE//2 - 250, SIZE//2 + 250, SIZE//2 + 250], fill=(63, 81, 181))

    # Book on planet
    draw_book(draw, SIZE//2 - 150, SIZE//2 - 100, 300, 200, (255, 193, 7))

    # Stars everywhere
    import random
    random.seed(42)
    for _ in range(30):
        x = random.randint(50, SIZE - 50)
        y = random.randint(50, SIZE - 50)
        size = random.randint(15, 35)
        draw_star(draw, x, y, size, fill=(255, 255, 255))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 150, 100, (255, 255, 255), (255, 193, 7))

    return img

def junior_option_7():
    """Sunshine theme - Yellow and orange warmth."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Radial gradient - sunny
    center = SIZE // 2
    for r in range(SIZE, 0, -5):
        intensity = int((r / SIZE) * 100)
        color = (255, 193 + intensity // 2, 7)
        draw.ellipse([center - r, center - r, center + r, center + r], fill=color)

    # Sun rays
    for angle in range(0, 360, 30):
        rad = math.radians(angle)
        x1 = center + 350 * math.cos(rad)
        y1 = center + 350 * math.sin(rad)
        x2 = center + 450 * math.cos(rad)
        y2 = center + 450 * math.sin(rad)
        draw.line([x1, y1, x2, y2], fill=(255, 152, 0), width=30)

    # Book in center
    draw_book(draw, SIZE//2 - 200, SIZE//2 - 120, 400, 240, (255, 87, 34))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 180, 100, (255, 255, 255), (255, 152, 0))

    return img

def junior_option_8():
    """Coral theme - Pink and teal contrast."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Coral pink gradient
    for y in range(SIZE):
        r = 255
        g = 128 + int(y/SIZE * 100)
        b = 171
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Teal book
    draw_book(draw, SIZE//2 - 230, SIZE//2 - 130, 460, 300, (0, 150, 136))

    # Coral circles
    for x, y, r in [(200, 200, 60), (SIZE-200, 200, 50), (200, SIZE-200, 70), (SIZE-200, SIZE-200, 55)]:
        draw.ellipse([x - r, y - r, x + r, y + r], fill=(255, 87, 34))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 100, 110, (255, 255, 255), (0, 150, 136))

    return img

def junior_option_9():
    """Forest theme - Green with tree elements."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Forest green gradient
    for y in range(SIZE):
        g = 140 + int(y/SIZE * 60)
        draw.line([(0, y), (SIZE, y)], fill=(46, g, 46))

    # Book as tree trunk
    draw.rectangle([SIZE//2 - 100, SIZE//2 - 100, SIZE//2 + 100, SIZE//2 + 250], fill=(121, 85, 72))

    # Tree leaves (circles)
    leaf_positions = [
        (SIZE//2, SIZE//2 - 200, 150),
        (SIZE//2 - 120, SIZE//2 - 100, 130),
        (SIZE//2 + 120, SIZE//2 - 100, 130),
        (SIZE//2, SIZE//2, 140)
    ]
    for x, y, r in leaf_positions:
        draw.ellipse([x - r, y - r, x + r, y + r], fill=(76, 175, 80))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 320, 90, (255, 255, 255), (139, 195, 74))

    return img

def junior_option_10():
    """Candy theme - Bright multi-color fun."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Striped background
    stripe_height = 80
    colors = [(255, 128, 171), (255, 193, 7), (33, 150, 243), (156, 39, 176), (76, 175, 80)]
    for i in range(0, SIZE, stripe_height):
        color = colors[(i // stripe_height) % len(colors)]
        draw.rectangle([0, i, SIZE, i + stripe_height], fill=color)

    # White book with candy stripes
    draw_book(draw, SIZE//2 - 200, SIZE//2 - 120, 400, 260, (255, 255, 255), (244, 67, 54))

    # Lollipop play button
    draw.ellipse([SIZE//2 - 100, SIZE//2 + 180, SIZE//2 + 100, SIZE//2 + 380], fill=(244, 67, 54))
    draw.rectangle([SIZE//2 - 15, SIZE//2 + 280, SIZE//2 + 15, SIZE//2 + 420], fill=(255, 255, 255))
    draw_play_button(draw, SIZE//2, SIZE//2 + 280, 70, (255, 255, 255), (244, 67, 54))

    return img

def junior_option_11():
    """Sky theme - Light blue with clouds."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Sky blue gradient
    for y in range(SIZE):
        b = 230 + int(y/SIZE * 25)
        draw.line([(0, y), (SIZE, y)], fill=(135, 206, b))

    # Clouds
    cloud_positions = [(200, 150), (SIZE-250, 200), (SIZE//2, 100), (150, SIZE-200), (SIZE-200, SIZE-250)]
    for cx, cy in cloud_positions:
        # Multiple circles for cloud
        for dx, dy, r in [(-40, 0, 50), (0, -20, 60), (40, 0, 50), (0, 20, 45)]:
            draw.ellipse([cx + dx - r, cy + dy - r, cx + dx + r, cy + dy + r], fill=(255, 255, 255))

    # Book
    draw_book(draw, SIZE//2 - 220, SIZE//2 - 100, 440, 280, (255, 87, 34))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 100, 100, (255, 255, 255), (33, 150, 243))

    return img

def junior_option_12():
    """Fruit theme - Orange and green fresh look."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Orange gradient
    for y in range(SIZE):
        g = 140 + int(y/SIZE * 80)
        draw.line([(0, y), (SIZE, y)], fill=(255, g, 0))

    # Green book (like a leaf)
    points = [
        (SIZE//2, SIZE//2 - 200),
        (SIZE//2 + 200, SIZE//2),
        (SIZE//2, SIZE//2 + 200),
        (SIZE//2 - 200, SIZE//2)
    ]
    draw.polygon(points, fill=(139, 195, 74))

    # Leaf veins
    draw.line([SIZE//2, SIZE//2 - 200, SIZE//2, SIZE//2 + 200], fill=(76, 175, 80), width=15)

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2, 110, (255, 255, 255), (255, 152, 0))

    return img

# ==================== MIDDLE FLAVOR ICONS ====================

def middle_option_1():
    """Modern teal with lightbulb - Innovation theme."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Teal gradient
    for y in range(SIZE):
        g = 150 + int(y/SIZE * 38)
        draw.line([(0, y), (SIZE, y)], fill=(0, g, 136))

    # Large lightbulb
    draw_lightbulb(draw, SIZE//2, SIZE//2 - 50, 180, (255, 235, 59), (200, 200, 200))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 250, 110, (255, 255, 255), (0, 188, 212))

    return img

def middle_option_2():
    """Blue and orange science theme."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Deep blue gradient
    for y in range(SIZE):
        b = 200 - int(y/SIZE * 50)
        draw.line([(0, y), (SIZE, y)], fill=(13, 71, b))

    # Atom structure
    center = (SIZE//2, SIZE//2)

    # Nucleus
    draw.ellipse([center[0] - 60, center[1] - 60, center[0] + 60, center[1] + 60], fill=(255, 152, 0))

    # Electron orbits
    for angle_offset in [0, 60, 120]:
        # Orbit line
        points = []
        for angle in range(0, 360, 5):
            rad = math.radians(angle + angle_offset)
            x = center[0] + 200 * math.cos(rad)
            y = center[1] + 100 * math.sin(rad)
            points.append((x, y))
        draw.line(points, fill=(33, 150, 243), width=8)

        # Electron
        rad = math.radians(angle_offset)
        ex = center[0] + 200 * math.cos(rad)
        ey = center[1] + 100 * math.sin(rad)
        draw.ellipse([ex - 30, ey - 30, ex + 30, ey + 30], fill=(255, 193, 7))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 180, 90, (255, 255, 255), (255, 152, 0))

    return img

def middle_option_3():
    """Purple growth theme - Ascending bars."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Purple gradient
    for y in range(SIZE):
        b = 180 + int(y/SIZE * 75)
        draw.line([(0, y), (SIZE, y)], fill=(94, 53, b))

    # Growth bars
    bar_width = 120
    heights = [200, 300, 400, 500, 600]
    colors = [(156, 39, 176), (142, 36, 170), (126, 32, 160), (111, 28, 150), (94, 24, 140)]

    start_x = 150
    for i, (height, color) in enumerate(zip(heights, colors)):
        x = start_x + i * (bar_width + 30)
        draw.rounded_rectangle([x, SIZE - 150 - height, x + bar_width, SIZE - 150],
                              radius=20, fill=color)
        # Shine effect
        draw.rounded_rectangle([x + 10, SIZE - 150 - height + 20, x + 40, SIZE - 170],
                              radius=10, fill=(200, 150, 220, 128))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 80, 60, (255, 255, 255), (156, 39, 176))

    return img

def middle_option_4():
    """Geometric pattern - Modern abstract."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gradient background
    for y in range(SIZE):
        draw.line([(0, y), (SIZE, y)], fill=(0, 188, 212))

    # Geometric hexagons
    hex_size = 140
    colors = [(255, 193, 7), (255, 152, 0), (244, 67, 54), (233, 30, 99)]

    positions = [
        (SIZE//2 - 150, SIZE//2 - 150),
        (SIZE//2 + 150, SIZE//2 - 150),
        (SIZE//2, SIZE//2),
        (SIZE//2 - 150, SIZE//2 + 150),
        (SIZE//2 + 150, SIZE//2 + 150)
    ]

    for i, (cx, cy) in enumerate(positions[:4]):
        # Hexagon
        hex_points = []
        for angle in range(0, 360, 60):
            rad = math.radians(angle)
            x = cx + hex_size * math.cos(rad)
            y = cy + hex_size * math.sin(rad)
            hex_points.append((x, y))
        draw.polygon(hex_points, fill=colors[i % len(colors)])

    # Central play button
    draw_play_button(draw, SIZE//2, SIZE//2, 100, (255, 255, 255), (0, 188, 212))

    return img

def middle_option_5():
    """Gradient waves - Dynamic energy."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Multi-color gradient waves
    for y in range(SIZE):
        progress = y / SIZE
        if progress < 0.33:
            # Blue to purple
            r = int(63 + progress * 3 * (156 - 63))
            g = int(81 - progress * 3 * 42)
            b = 181
        elif progress < 0.66:
            # Purple to pink
            local_p = (progress - 0.33) * 3
            r = int(156 + local_p * (233 - 156))
            g = int(39 - local_p * 9)
            b = int(176 - local_p * 77)
        else:
            # Pink to orange
            local_p = (progress - 0.66) * 3
            r = int(233 + local_p * 22)
            g = int(30 + local_p * 122)
            b = int(99 - local_p * 99)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Book
    draw_book(draw, SIZE//2 - 220, SIZE//2 - 120, 440, 280, (255, 255, 255), (63, 81, 181))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 200, 100, (255, 193, 7), (156, 39, 176))

    return img

def middle_option_6():
    """Brain and gears - Learning mechanism."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gray-blue gradient
    for y in range(SIZE):
        b = 140 + int(y/SIZE * 100)
        draw.line([(0, y), (SIZE, y)], fill=(69, 90, b))

    # Brain outline (simplified)
    draw.ellipse([SIZE//2 - 200, SIZE//2 - 180, SIZE//2 + 200, SIZE//2 + 180], fill=(255, 193, 7))

    # Gear (simplified)
    gear_center = (SIZE//2, SIZE//2)
    outer_r = 150
    inner_r = 100

    # Gear teeth (simplified as octagon)
    for angle in range(0, 360, 45):
        rad = math.radians(angle)
        x1 = gear_center[0] + inner_r * math.cos(rad)
        y1 = gear_center[1] + inner_r * math.sin(rad)
        x2 = gear_center[0] + outer_r * math.cos(rad)
        y2 = gear_center[1] + outer_r * math.sin(rad)
        draw.line([x1, y1, x2, y2], fill=(96, 125, 139), width=25)

    # Center circle
    draw.ellipse([gear_center[0] - 70, gear_center[1] - 70,
                 gear_center[0] + 70, gear_center[1] + 70], fill=(255, 255, 255))

    # Play button in center
    draw_play_button(draw, SIZE//2, SIZE//2, 50, (255, 193, 7), (69, 90, 140))

    return img

def middle_option_7():
    """Mountain peak - Achievement journey."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Sky gradient
    for y in range(SIZE):
        r = 100 - int(y/SIZE * 50)
        g = 181 - int(y/SIZE * 81)
        b = 246 - int(y/SIZE * 46)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Mountains
    mountains = [
        # Back mountain (lighter)
        [(0, SIZE), (SIZE//3, SIZE//3), (SIZE*2//3, SIZE)],
        # Front mountain (darker)
        [(SIZE//4, SIZE), (SIZE//2, SIZE//4), (SIZE*3//4, SIZE)]
    ]

    colors = [(121, 134, 203), (63, 81, 181)]

    for mountain, color in zip(mountains, colors):
        draw.polygon(mountain, fill=color)

    # Sun/Book
    draw.ellipse([SIZE//2 - 120, SIZE//4 - 120, SIZE//2 + 120, SIZE//4 + 120], fill=(255, 193, 7))

    # Play button on peak
    draw_play_button(draw, SIZE//2, SIZE//4 + 200, 80, (255, 255, 255), (244, 67, 54))

    return img

def middle_option_8():
    """Circuit board - Technology theme."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Dark tech background
    for y in range(SIZE):
        g = 30 + int(y/SIZE * 40)
        draw.line([(0, y), (SIZE, y)], fill=(15, g, 15))

    # Circuit lines
    import random
    random.seed(123)

    # Vertical lines
    for x in [200, 400, 600, 800]:
        draw.line([(x, 0), (x, SIZE)], fill=(0, 230, 118), width=8)

    # Horizontal lines
    for y in [200, 400, 600, 800]:
        draw.line([(0, y), (SIZE, y)], fill=(0, 230, 118), width=8)

    # Connection nodes
    for x in [200, 400, 600, 800]:
        for y in [200, 400, 600, 800]:
            draw.ellipse([x - 20, y - 20, x + 20, y + 20], fill=(0, 255, 0))

    # Central processor (book)
    draw_book(draw, SIZE//2 - 180, SIZE//2 - 120, 360, 240, (255, 193, 7))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 200, 90, (0, 230, 118), (15, 70, 15))

    return img

def middle_option_9():
    """Globe - Global knowledge."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Space background
    for y in range(SIZE):
        b = 20 + int(y/SIZE * 60)
        draw.line([(0, y), (SIZE, y)], fill=(10, 10, b))

    # Globe
    draw.ellipse([SIZE//2 - 280, SIZE//2 - 280, SIZE//2 + 280, SIZE//2 + 280], fill=(33, 150, 243))

    # Continents (simplified as blobs)
    draw.ellipse([SIZE//2 - 150, SIZE//2 - 100, SIZE//2 + 50, SIZE//2 + 100], fill=(76, 175, 80))
    draw.ellipse([SIZE//2 + 20, SIZE//2 - 150, SIZE//2 + 180, SIZE//2 + 50], fill=(76, 175, 80))

    # Latitude lines
    for offset in [-150, -80, 0, 80, 150]:
        draw.arc([SIZE//2 - 280, SIZE//2 - 280 + offset, SIZE//2 + 280, SIZE//2 + 280 + offset],
                start=180, end=360, fill=(255, 255, 255, 128), width=4)

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 350, 80, (255, 255, 255), (33, 150, 243))

    return img

def middle_option_10():
    """Puzzle pieces - Problem solving."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gray gradient
    for y in range(SIZE):
        v = 189 + int(y/SIZE * 35)
        draw.line([(0, y), (SIZE, y)], fill=(v, v, v + 30))

    # Puzzle pieces (simplified as rounded squares)
    piece_size = 200
    colors = [(244, 67, 54), (33, 150, 243), (255, 193, 7), (76, 175, 80)]

    positions = [
        (SIZE//2 - piece_size//2, SIZE//2 - piece_size//2),
        (SIZE//2 + piece_size//2, SIZE//2 - piece_size//2),
        (SIZE//2 - piece_size//2, SIZE//2 + piece_size//2),
        (SIZE//2 + piece_size//2, SIZE//2 + piece_size//2)
    ]

    for i, (x, y) in enumerate(positions):
        draw.rounded_rectangle([x, y, x + piece_size, y + piece_size],
                              radius=30, fill=colors[i])
        # Tab
        if i in [0, 1]:
            draw.ellipse([x + piece_size//2 - 30, y + piece_size - 15,
                         x + piece_size//2 + 30, y + piece_size + 45], fill=colors[i])

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 150, 80, (255, 255, 255), (96, 125, 139))

    return img

def middle_option_11():
    """DNA helix - Science theme."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gradient background
    for y in range(SIZE):
        r = 100 + int(y/SIZE * 100)
        draw.line([(0, y), (SIZE, y)], fill=(r, 50, 150))

    # DNA double helix
    for i in range(0, 360, 10):
        angle = math.radians(i * 4)
        y = SIZE//2 - 300 + i * 2

        # Left strand
        x1 = SIZE//2 - 150 + 100 * math.sin(angle)
        # Right strand
        x2 = SIZE//2 + 150 + 100 * math.sin(angle + math.pi)

        # Base pair connection
        if i % 30 == 0:
            draw.line([x1, y, x2, y], fill=(255, 193, 7), width=12)

        # Strands
        draw.ellipse([x1 - 25, y - 25, x1 + 25, y + 25], fill=(33, 150, 243))
        draw.ellipse([x2 - 25, y - 25, x2 + 25, y + 25], fill=(244, 67, 54))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 150, 80, (255, 255, 255), (156, 39, 176))

    return img

def middle_option_12():
    """Rocket launch - Ambition theme."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Sky gradient
    for y in range(SIZE):
        r = 25 + int(y/SIZE * 100)
        g = 25 + int(y/SIZE * 100)
        b = 112 + int(y/SIZE * 100)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Rocket body
    rocket_x = SIZE//2
    rocket_bottom = SIZE - 150
    rocket_top = SIZE//2 - 200

    # Main body
    draw.rectangle([rocket_x - 100, rocket_top, rocket_x + 100, rocket_bottom], fill=(236, 239, 241))

    # Nose cone
    draw.polygon([
        (rocket_x, rocket_top - 150),
        (rocket_x - 100, rocket_top),
        (rocket_x + 100, rocket_top)
    ], fill=(244, 67, 54))

    # Window
    draw.ellipse([rocket_x - 60, rocket_top + 50, rocket_x + 60, rocket_top + 170], fill=(33, 150, 243))

    # Play button in window
    draw_play_button(draw, rocket_x, rocket_top + 110, 40, (255, 255, 255), (33, 150, 243))

    # Fins
    draw.polygon([
        (rocket_x - 100, rocket_bottom - 100),
        (rocket_x - 100, rocket_bottom),
        (rocket_x - 200, rocket_bottom)
    ], fill=(255, 152, 0))
    draw.polygon([
        (rocket_x + 100, rocket_bottom - 100),
        (rocket_x + 100, rocket_bottom),
        (rocket_x + 200, rocket_bottom)
    ], fill=(255, 152, 0))

    # Flames
    flame_colors = [(255, 87, 34), (255, 193, 7), (255, 235, 59)]
    for i, color in enumerate(flame_colors):
        offset = i * 40
        draw.polygon([
            (rocket_x - 80 + offset, rocket_bottom),
            (rocket_x - 40 + offset, rocket_bottom + 100),
            (rocket_x + offset, rocket_bottom)
        ], fill=color)

    return img

# ==================== PREBOARD FLAVOR ICONS ====================

def preboard_option_1():
    """Trophy on podium - Achievement focus."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Orange to red gradient
    for y in range(SIZE):
        r = 255
        g = 87 + int(y/SIZE * 65)
        b = 34 - int(y/SIZE * 34)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Large trophy
    draw_trophy(draw, SIZE//2, SIZE//2 - 50, 150, (255, 215, 0))

    # Podium
    draw.rectangle([SIZE//2 - 180, SIZE//2 + 200, SIZE//2 + 180, SIZE//2 + 350], fill=(189, 189, 189))
    draw.polygon([
        (SIZE//2 - 200, SIZE//2 + 200),
        (SIZE//2 + 200, SIZE//2 + 200),
        (SIZE//2 + 180, SIZE//2 + 350),
        (SIZE//2 - 180, SIZE//2 + 350)
    ], fill=(224, 224, 224))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 120, 80, (255, 255, 255), (255, 152, 0))

    return img

def preboard_option_2():
    """Target with arrow - Goal focused."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Red gradient
    for y in range(SIZE):
        r = 211 + int(y/SIZE * 44)
        draw.line([(0, y), (SIZE, y)], fill=(r, 47, 47))

    # Target circles
    colors = [(255, 255, 255), (244, 67, 54), (255, 255, 255), (244, 67, 54), (255, 193, 7)]
    radii = [300, 240, 180, 120, 60]

    for radius, color in zip(radii, colors):
        draw.ellipse([SIZE//2 - radius, SIZE//2 - radius,
                     SIZE//2 + radius, SIZE//2 + radius], fill=color)

    # Arrow pointing to center
    arrow_start = (SIZE - 200, 200)
    arrow_end = (SIZE//2 + 40, SIZE//2 - 40)

    # Arrow shaft
    draw.line([arrow_start, arrow_end], fill=(33, 33, 33), width=25)

    # Arrow head
    draw.polygon([
        arrow_end,
        (arrow_end[0] - 60, arrow_end[1] - 20),
        (arrow_end[0] - 40, arrow_end[1] + 40)
    ], fill=(33, 33, 33))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2, 40, (255, 255, 255), (255, 193, 7))

    return img

def preboard_option_3():
    """Medal and ribbon - Excellence."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gold gradient
    for y in range(SIZE):
        r = 255
        g = 193 + int(y/SIZE * 32)
        b = 7
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Medal circle
    draw.ellipse([SIZE//2 - 220, SIZE//2 - 100, SIZE//2 + 220, SIZE//2 + 340], fill=(255, 215, 0))
    draw.ellipse([SIZE//2 - 180, SIZE//2 - 60, SIZE//2 + 180, SIZE//2 + 300], fill=(255, 193, 7))

    # Star in medal
    draw_star(draw, SIZE//2, SIZE//2 + 120, 120, fill=(255, 255, 255))

    # Ribbon
    draw.polygon([
        (SIZE//2 - 100, SIZE//2 - 300),
        (SIZE//2 - 60, SIZE//2 - 100),
        (SIZE//2 - 120, SIZE//2 - 100),
        (SIZE//2 - 180, SIZE//2 - 400)
    ], fill=(244, 67, 54))

    draw.polygon([
        (SIZE//2 + 100, SIZE//2 - 300),
        (SIZE//2 + 60, SIZE//2 - 100),
        (SIZE//2 + 120, SIZE//2 - 100),
        (SIZE//2 + 180, SIZE//2 - 400)
    ], fill=(33, 150, 243))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 120, 80, (255, 193, 7), (255, 255, 255))

    return img

def preboard_option_4():
    """Certificate scroll - Achievement."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Burgundy gradient
    for y in range(SIZE):
        r = 136 + int(y/SIZE * 50)
        g = 14 + int(y/SIZE * 20)
        b = 79 - int(y/SIZE * 20)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Scroll/Certificate
    scroll_color = (255, 248, 220)
    draw.rounded_rectangle([SIZE//2 - 300, SIZE//2 - 250, SIZE//2 + 300, SIZE//2 + 250],
                          radius=30, fill=scroll_color)

    # Border decoration
    draw.rounded_rectangle([SIZE//2 - 280, SIZE//2 - 230, SIZE//2 + 280, SIZE//2 + 230],
                          radius=25, outline=(184, 134, 11), width=15)

    # Seal
    draw.ellipse([SIZE//2 - 80, SIZE//2 + 100, SIZE//2 + 80, SIZE//2 + 260], fill=(220, 20, 60))
    draw_star(draw, SIZE//2, SIZE//2 + 180, 50, fill=(255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 - 50, 90, (255, 193, 7), (184, 134, 11))

    return img

def preboard_option_5():
    """Finish line - Success completion."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Checkered background pattern
    square_size = 128
    for row in range(8):
        for col in range(8):
            if (row + col) % 2 == 0:
                color = (33, 33, 33)
            else:
                color = (255, 255, 255)
            draw.rectangle([col * square_size, row * square_size,
                          (col + 1) * square_size, (row + 1) * square_size], fill=color)

    # Trophy in center
    draw_trophy(draw, SIZE//2, SIZE//2, 140, (255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 140, 70, (255, 193, 7), (33, 33, 33))

    return img

def preboard_option_6():
    """Crown - Excellence symbol."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Purple royal gradient
    for y in range(SIZE):
        r = 74 + int(y/SIZE * 80)
        g = 20 + int(y/SIZE * 30)
        b = 140 + int(y/SIZE * 40)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Crown base
    crown_y = SIZE//2
    draw.polygon([
        (SIZE//2 - 300, crown_y + 100),
        (SIZE//2 - 250, crown_y - 100),
        (SIZE//2 - 100, crown_y + 50),
        (SIZE//2, crown_y - 150),
        (SIZE//2 + 100, crown_y + 50),
        (SIZE//2 + 250, crown_y - 100),
        (SIZE//2 + 300, crown_y + 100)
    ], fill=(255, 215, 0))

    # Crown band
    draw.rectangle([SIZE//2 - 300, crown_y + 100, SIZE//2 + 300, crown_y + 200], fill=(255, 193, 7))

    # Jewels
    jewel_positions = [(SIZE//2 - 200, crown_y), (SIZE//2, crown_y - 80), (SIZE//2 + 200, crown_y)]
    jewel_colors = [(244, 67, 54), (76, 175, 80), (33, 150, 243)]

    for pos, color in zip(jewel_positions, jewel_colors):
        draw.ellipse([pos[0] - 40, pos[1] - 40, pos[0] + 40, pos[1] + 40], fill=color)

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 150, 80, (255, 255, 255), (255, 215, 0))

    return img

def preboard_option_7():
    """Mountain peak with flag - Goal achievement."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Sunset gradient
    for y in range(SIZE):
        if y < SIZE//2:
            # Sky
            r = 255
            g = 152 - int(y/(SIZE//2) * 80)
            b = 0 + int(y/(SIZE//2) * 100)
        else:
            # Mountain shadow
            ratio = (y - SIZE//2) / (SIZE//2)
            r = int(255 * (1 - ratio * 0.6))
            g = int(152 * (1 - ratio * 0.8))
            b = int(100 * (1 - ratio * 0.5))
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Mountain peak
    draw.polygon([
        (0, SIZE),
        (SIZE//2, SIZE//3),
        (SIZE, SIZE)
    ], fill=(62, 39, 35))

    # Flag at peak
    flag_pole_x = SIZE//2
    flag_pole_top = SIZE//3

    # Pole
    draw.line([flag_pole_x, flag_pole_top, flag_pole_x, flag_pole_top - 200],
             fill=(121, 85, 72), width=15)

    # Flag
    draw.polygon([
        (flag_pole_x, flag_pole_top - 200),
        (flag_pole_x + 180, flag_pole_top - 150),
        (flag_pole_x, flag_pole_top - 100)
    ], fill=(244, 67, 54))

    # Play button on flag
    draw_play_button(draw, flag_pole_x + 90, flag_pole_top - 150, 50, (255, 255, 255), (244, 67, 54))

    return img

def preboard_option_8():
    """Stairway to success - Progress journey."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gradient
    for y in range(SIZE):
        b = 100 + int(y/SIZE * 140)
        draw.line([(0, y), (SIZE, y)], fill=(41, 98, b))

    # Stairs
    step_height = 100
    step_width = 150
    colors = [(63, 81, 181), (92, 107, 192), (121, 134, 203), (159, 168, 218), (197, 202, 233)]

    for i in range(5):
        x = 150 + i * step_width
        y = SIZE - 150 - i * step_height

        # Step
        draw.rectangle([x, y, x + step_width, SIZE - 150], fill=colors[i])

        # 3D effect
        draw.polygon([
            (x + step_width, y),
            (x + step_width + 40, y - 40),
            (x + step_width + 40, SIZE - 150 - 40),
            (x + step_width, SIZE - 150)
        ], fill=tuple(int(c * 0.7) for c in colors[i]))

    # Trophy at top
    draw_trophy(draw, 150 + 4 * step_width + 75, SIZE - 150 - 4 * step_height - 120, 80, (255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 80, 60, (255, 255, 255), (255, 193, 7))

    return img

def preboard_option_9():
    """Rocket reaching target - Goal achievement."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Space background
    for y in range(SIZE):
        b = 10 + int(y/SIZE * 40)
        draw.line([(0, y), (SIZE, y)], fill=(5, 5, b))

    # Target/Goal (like a planet)
    draw.ellipse([SIZE - 400, 100, SIZE - 100, 400], fill=(255, 193, 7))

    # Target rings
    for r in [140, 120, 100]:
        draw.ellipse([SIZE - 250 - r, 250 - r, SIZE - 250 + r, 250 + r],
                    outline=(255, 152, 0), width=8)

    # Rocket
    rocket_x = SIZE//3
    rocket_y = SIZE - 300

    # Body (tilted toward target)
    draw.polygon([
        (rocket_x, rocket_y - 150),
        (rocket_x + 60, rocket_y - 120),
        (rocket_x + 80, rocket_y + 30),
        (rocket_x + 20, rocket_y)
    ], fill=(224, 224, 224))

    # Nose
    draw.polygon([
        (rocket_x, rocket_y - 150),
        (rocket_x - 40, rocket_y - 110),
        (rocket_x + 60, rocket_y - 120)
    ], fill=(244, 67, 54))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 100, 70, (255, 255, 255), (255, 193, 7))

    return img

def preboard_option_10():
    """Checkmark in circle - Success confirmation."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Green gradient
    for y in range(SIZE):
        g = 150 + int(y/SIZE * 50)
        draw.line([(0, y), (SIZE, y)], fill=(46, g, 46))

    # Large circle
    draw.ellipse([SIZE//2 - 320, SIZE//2 - 320, SIZE//2 + 320, SIZE//2 + 320], fill=(76, 175, 80))
    draw.ellipse([SIZE//2 - 280, SIZE//2 - 280, SIZE//2 + 280, SIZE//2 + 280], fill=(67, 160, 71))

    # Checkmark
    check_points = [
        (SIZE//2 - 150, SIZE//2),
        (SIZE//2 - 50, SIZE//2 + 150),
        (SIZE//2 + 200, SIZE//2 - 200)
    ]

    # Thick checkmark
    for offset in range(-30, 31, 10):
        points_offset = [(x + offset, y) for x, y in check_points]
        draw.line(points_offset, fill=(255, 255, 255), width=40)

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 120, 80, (255, 255, 255), (76, 175, 80))

    return img

def preboard_option_11():
    """Spotlight on trophy - Highlight success."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Dark stage background
    for y in range(SIZE):
        v = 20 + int(y/SIZE * 30)
        draw.line([(0, y), (SIZE, y)], fill=(v, v, v))

    # Spotlight (radial gradient approximation)
    center = SIZE // 2
    for r in range(400, 0, -10):
        alpha = int(255 * (1 - r/400))
        intensity = 255 - int(r/400 * 200)
        draw.ellipse([center - r, center - r, center + r, center + r],
                    fill=(intensity, intensity, 100))

    # Trophy in spotlight
    draw_trophy(draw, SIZE//2, SIZE//2, 160, (255, 215, 0))

    # Stage floor
    draw.rectangle([0, SIZE - 100, SIZE, SIZE], fill=(101, 67, 33))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 50, 40, (255, 255, 255), (255, 193, 7))

    return img

def preboard_option_12():
    """Book with graduation cap - Board exam focus."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Warm academic gradient
    for y in range(SIZE):
        r = 139 + int(y/SIZE * 100)
        g = 69 + int(y/SIZE * 50)
        b = 19
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Large book
    draw_book(draw, SIZE//2 - 280, SIZE//2 - 80, 560, 400, (205, 133, 63), (255, 248, 220))

    # Graduation cap on book
    draw_graduation_cap(draw, SIZE//2, SIZE//2 - 200, 100, (0, 0, 0), (255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 200, 90, (255, 255, 255), (139, 69, 19))

    return img

# ==================== SENIOR FLAVOR ICONS ====================

def senior_option_1():
    """Professional graduation cap - University prep."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Deep purple gradient
    for y in range(SIZE):
        r = 63 + int(y/SIZE * 40)
        g = 51 + int(y/SIZE * 30)
        b = 181 - int(y/SIZE * 50)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Large graduation cap
    draw_graduation_cap(draw, SIZE//2, SIZE//2 - 50, 180, (0, 0, 0), (255, 215, 0))

    # Books stack
    book_y = SIZE//2 + 200
    book_colors = [(103, 58, 183), (94, 53, 177), (84, 46, 170)]

    for i, color in enumerate(book_colors):
        y = book_y + i * 60
        draw_book(draw, SIZE//2 - 200, y, 400, 80, color)

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 120, 80, (255, 255, 255), (0, 188, 212))

    return img

def senior_option_2():
    """University building - Higher education."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Sky gradient
    for y in range(SIZE):
        b = 200 + int(y/SIZE * 55)
        draw.line([(0, y), (SIZE, y)], fill=(100, 181, b))

    # Building
    building_width = 500
    building_height = 600
    building_x = SIZE//2 - building_width//2
    building_y = SIZE - building_height - 100

    # Main structure
    draw.rectangle([building_x, building_y, building_x + building_width, SIZE - 100],
                  fill=(189, 189, 189))

    # Columns
    for i in range(5):
        x = building_x + 60 + i * 100
        draw.rectangle([x, building_y + 100, x + 40, SIZE - 100], fill=(255, 255, 255))

    # Roof/Pediment
    draw.polygon([
        (building_x - 50, building_y + 100),
        (SIZE//2, building_y - 100),
        (building_x + building_width + 50, building_y + 100)
    ], fill=(117, 117, 117))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 50, 40, (255, 255, 255), (63, 81, 181))

    return img

def senior_option_3():
    """Compass - Direction and guidance."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Navy gradient
    for y in range(SIZE):
        b = 100 + int(y/SIZE * 80)
        draw.line([(0, y), (SIZE, y)], fill=(25, 42, b))

    # Compass circle
    draw.ellipse([SIZE//2 - 300, SIZE//2 - 300, SIZE//2 + 300, SIZE//2 + 300],
                fill=(52, 73, 94))
    draw.ellipse([SIZE//2 - 280, SIZE//2 - 280, SIZE//2 + 280, SIZE//2 + 280],
                fill=(44, 62, 80))

    # Cardinal directions
    directions = ['N', 'E', 'S', 'W']
    angles = [0, 90, 180, 270]

    for direction, angle in zip(directions, angles):
        rad = math.radians(angle - 90)
        x = SIZE//2 + 250 * math.cos(rad)
        y = SIZE//2 + 250 * math.sin(rad)

        # Direction marker
        draw.ellipse([x - 30, y - 30, x + 30, y + 30], fill=(255, 193, 7))

    # Compass needle
    draw.polygon([
        (SIZE//2, SIZE//2 - 200),
        (SIZE//2 - 30, SIZE//2),
        (SIZE//2, SIZE//2 + 200),
        (SIZE//2 + 30, SIZE//2)
    ], fill=(244, 67, 54))

    # North point
    draw.polygon([
        (SIZE//2, SIZE//2 - 200),
        (SIZE//2 - 30, SIZE//2),
        (SIZE//2 + 30, SIZE//2)
    ], fill=(255, 255, 255))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 140, 70, (255, 255, 255), (255, 193, 7))

    return img

def senior_option_4():
    """Open book with knowledge symbols - Academic excellence."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Elegant gradient
    for y in range(SIZE):
        r = 30 + int(y/SIZE * 60)
        g = 30 + int(y/SIZE * 80)
        b = 90 + int(y/SIZE * 100)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Open book (two pages)
    book_y = SIZE//2

    # Left page
    draw.polygon([
        (SIZE//2, book_y - 200),
        (SIZE//2 - 300, book_y - 150),
        (SIZE//2 - 300, book_y + 250),
        (SIZE//2, book_y + 200)
    ], fill=(255, 248, 220))

    # Right page
    draw.polygon([
        (SIZE//2, book_y - 200),
        (SIZE//2 + 300, book_y - 150),
        (SIZE//2 + 300, book_y + 250),
        (SIZE//2, book_y + 200)
    ], fill=(255, 245, 210))

    # Knowledge symbols on pages
    # Mathematical symbols on left
    symbols_left = ['π', '∑', '∫']
    # Science symbols on right
    symbols_right = ['⚛', '🔬', '🧬']

    # Play button
    draw_play_button(draw, SIZE//2, book_y, 100, (255, 193, 7), (63, 81, 181))

    return img

def senior_option_5():
    """Globe with graduation cap - Global education."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Deep blue gradient
    for y in range(SIZE):
        b = 140 + int(y/SIZE * 100)
        draw.line([(0, y), (SIZE, y)], fill=(13, 71, b))

    # Globe
    draw.ellipse([SIZE//2 - 280, SIZE//2 - 180, SIZE//2 + 280, SIZE//2 + 320],
                fill=(33, 150, 243))

    # Continents
    draw.ellipse([SIZE//2 - 150, SIZE//2, SIZE//2 + 50, SIZE//2 + 200], fill=(76, 175, 80))
    draw.ellipse([SIZE//2 + 20, SIZE//2 - 50, SIZE//2 + 180, SIZE//2 + 150], fill=(76, 175, 80))

    # Graduation cap on top of globe
    draw_graduation_cap(draw, SIZE//2, SIZE//2 - 280, 120, (0, 0, 0), (255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 120, 70, (255, 255, 255), (33, 150, 243))

    return img

def senior_option_6():
    """Briefcase - Professional career focus."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Professional gray gradient
    for y in range(SIZE):
        v = 60 + int(y/SIZE * 80)
        draw.line([(0, y), (SIZE, y)], fill=(v, v, v + 40))

    # Briefcase
    briefcase_width = 500
    briefcase_height = 350
    briefcase_x = SIZE//2 - briefcase_width//2
    briefcase_y = SIZE//2 - briefcase_height//2

    # Main body
    draw.rounded_rectangle([briefcase_x, briefcase_y,
                           briefcase_x + briefcase_width, briefcase_y + briefcase_height],
                          radius=30, fill=(62, 39, 35))

    # Handle
    draw.arc([briefcase_x + 150, briefcase_y - 100,
             briefcase_x + briefcase_width - 150, briefcase_y + 50],
            start=0, end=180, fill=(52, 29, 25), width=30)

    # Lock/Clasp
    draw.rectangle([SIZE//2 - 40, briefcase_y + briefcase_height//2 - 30,
                   SIZE//2 + 40, briefcase_y + briefcase_height//2 + 30],
                  fill=(255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 + 250, 70, (255, 255, 255), (0, 188, 212))

    return img

def senior_option_7():
    """Diploma scroll - Higher education achievement."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Burgundy gradient
    for y in range(SIZE):
        r = 109 + int(y/SIZE * 50)
        g = 33 + int(y/SIZE * 20)
        b = 79 - int(y/SIZE * 20)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Diploma scroll
    scroll_width = 600
    scroll_height = 400

    # Scroll background
    draw.rounded_rectangle([SIZE//2 - scroll_width//2, SIZE//2 - scroll_height//2,
                           SIZE//2 + scroll_width//2, SIZE//2 + scroll_height//2],
                          radius=40, fill=(255, 248, 220))

    # Border
    draw.rounded_rectangle([SIZE//2 - scroll_width//2 + 30, SIZE//2 - scroll_height//2 + 30,
                           SIZE//2 + scroll_width//2 - 30, SIZE//2 + scroll_height//2 - 30],
                          radius=30, outline=(184, 134, 11), width=12)

    # Ribbon/Seal
    ribbon_y = SIZE//2 + scroll_height//2 - 80
    draw.ellipse([SIZE//2 - 70, ribbon_y - 70, SIZE//2 + 70, ribbon_y + 70],
                fill=(184, 134, 11))

    # Ribbon tails
    draw.polygon([
        (SIZE//2 - 40, ribbon_y + 60),
        (SIZE//2 - 60, ribbon_y + 200),
        (SIZE//2 - 20, ribbon_y + 180)
    ], fill=(184, 134, 11))

    draw.polygon([
        (SIZE//2 + 40, ribbon_y + 60),
        (SIZE//2 + 60, ribbon_y + 200),
        (SIZE//2 + 20, ribbon_y + 180)
    ], fill=(184, 134, 11))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE//2 - 50, 80, (184, 134, 11), (255, 248, 220))

    return img

def senior_option_8():
    """Chess king - Strategic thinking."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Checkered sophisticated background
    for y in range(SIZE):
        g = 40 + int(y/SIZE * 60)
        b = 60 + int(y/SIZE * 90)
        draw.line([(0, y), (SIZE, y)], fill=(30, g, b))

    # Chess king piece (simplified)
    king_x = SIZE//2
    king_base_y = SIZE//2 + 200

    # Base
    draw.ellipse([king_x - 180, king_base_y, king_x + 180, king_base_y + 100],
                fill=(255, 215, 0))

    # Body (cone shape)
    draw.polygon([
        (king_x - 120, king_base_y),
        (king_x - 80, king_base_y - 300),
        (king_x + 80, king_base_y - 300),
        (king_x + 120, king_base_y)
    ], fill=(255, 215, 0))

    # Top sphere
    draw.ellipse([king_x - 90, king_base_y - 380, king_x + 90, king_base_y - 260],
                fill=(255, 215, 0))

    # Crown cross
    draw.rectangle([king_x - 15, king_base_y - 480, king_x + 15, king_base_y - 340],
                  fill=(255, 215, 0))
    draw.rectangle([king_x - 60, king_base_y - 430, king_x + 60, king_base_y - 400],
                  fill=(255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 100, 60, (255, 255, 255), (255, 193, 7))

    return img

def senior_option_9():
    """Telescope - Vision and exploration."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Night sky gradient
    for y in range(SIZE):
        v = 10 + int(y/SIZE * 30)
        b = 40 + int(y/SIZE * 80)
        draw.line([(0, y), (SIZE, y)], fill=(v, v, b))

    # Stars
    import random
    random.seed(456)
    for _ in range(40):
        x = random.randint(50, SIZE - 50)
        y = random.randint(50, SIZE - 50)
        size = random.randint(10, 25)
        draw_star(draw, x, y, size, fill=(255, 255, 255))

    # Telescope
    # Tripod
    draw.polygon([
        (SIZE//2, SIZE - 100),
        (SIZE//2 - 200, SIZE - 100),
        (SIZE//2, SIZE - 300)
    ], fill=(96, 125, 139))

    draw.polygon([
        (SIZE//2, SIZE - 100),
        (SIZE//2 + 200, SIZE - 100),
        (SIZE//2, SIZE - 300)
    ], fill=(96, 125, 139))

    # Telescope tube
    draw.polygon([
        (SIZE//2 - 50, SIZE - 300),
        (SIZE - 200, 200),
        (SIZE - 150, 180),
        (SIZE//2, SIZE - 280)
    ], fill=(69, 90, 100))

    # Lens
    draw.ellipse([SIZE - 220, 170, SIZE - 130, 210], fill=(135, 206, 250))

    # Play button
    draw_play_button(draw, SIZE//2 - 200, SIZE - 200, 50, (255, 255, 255), (33, 150, 243))

    return img

def senior_option_10():
    """Stacked books with apple - Classic education."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Warm library gradient
    for y in range(SIZE):
        r = 101 + int(y/SIZE * 60)
        g = 67 + int(y/SIZE * 40)
        b = 33
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Stack of books
    book_colors = [(63, 81, 181), (156, 39, 176), (0, 150, 136), (255, 152, 0), (244, 67, 54)]
    book_y = SIZE - 150

    for i, color in enumerate(book_colors):
        y = book_y - i * 90
        # Slight rotation effect
        draw_book(draw, SIZE//2 - 220 + (i * 10), y, 440, 100, color)

    # Apple on top
    apple_y = book_y - len(book_colors) * 90 - 120
    draw.ellipse([SIZE//2 - 80, apple_y, SIZE//2 + 80, apple_y + 160], fill=(244, 67, 54))

    # Leaf
    draw.ellipse([SIZE//2 + 40, apple_y - 20, SIZE//2 + 100, apple_y + 40], fill=(76, 175, 80))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 80, 60, (255, 255, 255), (101, 67, 33))

    return img

def senior_option_11():
    """Atom with graduation cap - Science and achievement."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gradient
    for y in range(SIZE):
        r = 13 + int(y/SIZE * 50)
        g = 71 + int(y/SIZE * 50)
        b = 161 + int(y/SIZE * 70)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

    # Atomic structure
    center = (SIZE//2, SIZE//2 + 50)

    # Nucleus
    draw.ellipse([center[0] - 80, center[1] - 80, center[0] + 80, center[1] + 80],
                fill=(255, 152, 0))

    # Electron orbits (3 orbits at different angles)
    orbit_colors = [(33, 150, 243), (76, 175, 80), (156, 39, 176)]

    for i, color in enumerate(orbit_colors):
        angle_offset = i * 60

        # Draw elliptical orbit
        points = []
        for angle in range(0, 360, 5):
            rad = math.radians(angle + angle_offset)
            x = center[0] + 250 * math.cos(rad)
            y = center[1] + 140 * math.sin(rad)
            points.append((x, y))
        draw.line(points, fill=color, width=10)

        # Electron
        rad = math.radians(angle_offset * 3)
        ex = center[0] + 250 * math.cos(rad)
        ey = center[1] + 140 * math.sin(rad)
        draw.ellipse([ex - 35, ey - 35, ex + 35, ey + 35], fill=color)

    # Graduation cap above atom
    draw_graduation_cap(draw, SIZE//2, SIZE//2 - 300, 100, (0, 0, 0), (255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 100, 70, (255, 255, 255), (255, 152, 0))

    return img

def senior_option_12():
    """Ladder to success - Career advancement."""
    img = Image.new('RGB', (SIZE, SIZE))
    draw = ImageDraw.Draw(img)

    # Gradient from dark to light (bottom to top)
    for y in range(SIZE):
        progress = 1 - (y / SIZE)
        v = int(40 + progress * 160)
        draw.line([(0, y), (SIZE, y)], fill=(v, v, v + 40))

    # Ladder
    ladder_width = 200
    ladder_x1 = SIZE//2 - ladder_width//2
    ladder_x2 = SIZE//2 + ladder_width//2

    # Side rails
    draw.line([ladder_x1, SIZE - 50, ladder_x1 + 40, 100], fill=(139, 69, 19), width=25)
    draw.line([ladder_x2 - 40, SIZE - 50, ladder_x2, 100], fill=(139, 69, 19), width=25)

    # Rungs
    for i in range(8):
        y = SIZE - 100 - i * 110
        x1 = ladder_x1 + 40 - int((SIZE - 50 - y) * 0.2)
        x2 = ladder_x2 - 40 + int((SIZE - 50 - y) * 0.2)
        draw.line([x1, y, x2, y], fill=(160, 82, 45), width=20)

    # Cloud/Goal at top
    cloud_y = 150
    for dx, dy, r in [(-60, 0, 60), (0, -30, 70), (60, 0, 60), (0, 30, 55)]:
        draw.ellipse([SIZE//2 + dx - r, cloud_y + dy - r,
                     SIZE//2 + dx + r, cloud_y + dy + r], fill=(255, 255, 255))

    # Star in cloud
    draw_star(draw, SIZE//2, cloud_y, 40, fill=(255, 215, 0))

    # Play button
    draw_play_button(draw, SIZE//2, SIZE - 100, 60, (255, 255, 255), (139, 69, 19))

    return img

# ==================== MAIN GENERATION ====================

def main():
    """Generate all icon options."""
    create_output_dir()

    print("Generating icon options for all flavors...\n")

    # Junior options
    print("=== JUNIOR FLAVOR (Grades 4-7) ===")
    junior_functions = [
        junior_option_1, junior_option_2, junior_option_3, junior_option_4,
        junior_option_5, junior_option_6, junior_option_7, junior_option_8,
        junior_option_9, junior_option_10, junior_option_11, junior_option_12
    ]

    for i, func in enumerate(junior_functions, 1):
        img = func()
        filename = f"{OUTPUT_DIR}/junior/option_{i}.png"
        img.save(filename)
        print(f"  ✓ Generated option {i}")

    # Middle options
    print("\n=== MIDDLE FLAVOR (Grades 7-9) ===")
    middle_functions = [
        middle_option_1, middle_option_2, middle_option_3, middle_option_4,
        middle_option_5, middle_option_6, middle_option_7, middle_option_8,
        middle_option_9, middle_option_10, middle_option_11, middle_option_12
    ]

    for i, func in enumerate(middle_functions, 1):
        img = func()
        filename = f"{OUTPUT_DIR}/middle/option_{i}.png"
        img.save(filename)
        print(f"  ✓ Generated option {i}")

    # Preboard options
    print("\n=== PREBOARD FLAVOR (Grade 10 - Board Prep) ===")
    preboard_functions = [
        preboard_option_1, preboard_option_2, preboard_option_3, preboard_option_4,
        preboard_option_5, preboard_option_6, preboard_option_7, preboard_option_8,
        preboard_option_9, preboard_option_10, preboard_option_11, preboard_option_12
    ]

    for i, func in enumerate(preboard_functions, 1):
        img = func()
        filename = f"{OUTPUT_DIR}/preboard/option_{i}.png"
        img.save(filename)
        print(f"  ✓ Generated option {i}")

    # Senior options
    print("\n=== SENIOR FLAVOR (Grades 11-12) ===")
    senior_functions = [
        senior_option_1, senior_option_2, senior_option_3, senior_option_4,
        senior_option_5, senior_option_6, senior_option_7, senior_option_8,
        senior_option_9, senior_option_10, senior_option_11, senior_option_12
    ]

    for i, func in enumerate(senior_functions, 1):
        img = func()
        filename = f"{OUTPUT_DIR}/senior/option_{i}.png"
        img.save(filename)
        print(f"  ✓ Generated option {i}")

    print(f"\n{'='*60}")
    print(f"TOTAL: 48 icon options generated!")
    print(f"Location: {OUTPUT_DIR}/")
    print(f"{'='*60}")
    print("\nFolder structure:")
    print(f"  • {OUTPUT_DIR}/junior/   - 12 options for Junior flavor")
    print(f"  • {OUTPUT_DIR}/middle/   - 12 options for Middle flavor")
    print(f"  • {OUTPUT_DIR}/preboard/ - 12 options for Preboard flavor")
    print(f"  • {OUTPUT_DIR}/senior/   - 12 options for Senior flavor")
    print("\nReview the options and select your favorites!")

if __name__ == '__main__':
    main()
