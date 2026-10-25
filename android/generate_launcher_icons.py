import os

from PIL import Image, ImageDraw, ImageFont

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
RES_DIR = os.path.join(SCRIPT_DIR, "app", "src", "main", "res")

GREEN = (46, 125, 50, 255)      # #2E7D32
WHITE = (255, 255, 255, 255)

SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}


def _load_font(size):
    candidates = [
        "arialbd.ttf",
        "arial.ttf",
        "DejaVuSans-Bold.ttf",
        "segoeuib.ttf",
    ]
    for name in candidates:
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            continue
    return ImageFont.load_default()


def _draw_text_centered(draw, text, font, box):
    try:
        left, top, right, bottom = draw.textbbox((0, 0), text, font=font)
        w, h = right - left, bottom - top
        x = (box - w) / 2 - left
        y = (box - h) / 2 - top
    except AttributeError:
        # Older Pillow API fallback.
        w, h = draw.textsize(text, font=font)
        x = (box - w) / 2
        y = (box - h) / 2
    draw.text((x, y), text, font=font, fill=WHITE)


def make_icon(size, rounded):
    scale = 4
    big = size * scale
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    margin = int(big * 0.04)
    draw.ellipse([margin, margin, big - margin, big - margin], fill=GREEN)

    font = _load_font(int(big * 0.58))
    _draw_text_centered(draw, "M", font, big)

    return img.resize((size, size), Image.LANCZOS)


def main():
    created = []
    for folder, size in SIZES.items():
        out_dir = os.path.join(RES_DIR, folder)
        os.makedirs(out_dir, exist_ok=True)

        square = make_icon(size, rounded=False)
        square_path = os.path.join(out_dir, "ic_launcher.png")
        square.save(square_path, "PNG")
        created.append((square_path, size))

        rnd = make_icon(size, rounded=True)
        rnd_path = os.path.join(out_dir, "ic_launcher_round.png")
        rnd.save(rnd_path, "PNG")
        created.append((rnd_path, size))

    for path, size in created:
        rel = os.path.relpath(path, SCRIPT_DIR)
        print(f"  {rel}  ({size}x{size})")
    print(f"\nDone. {len(created)} icon files created.")


if __name__ == "__main__":
    main()
