from pathlib import Path
import textwrap

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs" / "projeto_openweather_estudo.md"
OUTPUT = ROOT / "docs" / "OpenWeather_Estudo_Apresentacao.pdf"

PAGE_W, PAGE_H = 1240, 1754
MARGIN_X = 92
MARGIN_TOP = 86
MARGIN_BOTTOM = 80
CONTENT_W = PAGE_W - (MARGIN_X * 2)

BLUE = (21, 101, 192)
DARK = (31, 42, 55)
BODY = (55, 65, 81)
MUTED = (107, 114, 128)
LIGHT_BG = (248, 250, 252)
CODE_BG = (235, 241, 247)


def font_path(name):
    candidates = [
        Path("C:/Windows/Fonts") / name,
        Path("/usr/share/fonts/truetype/dejavu") / name,
    ]
    for candidate in candidates:
        if candidate.exists():
            return str(candidate)
    return None


REGULAR = font_path("arial.ttf") or font_path("DejaVuSans.ttf")
BOLD = font_path("arialbd.ttf") or font_path("DejaVuSans-Bold.ttf")
MONO = font_path("consola.ttf") or font_path("DejaVuSansMono.ttf")


def load_font(path, size):
    return ImageFont.truetype(path, size) if path else ImageFont.load_default()


FONTS = {
    "title": load_font(BOLD, 52),
    "subtitle": load_font(REGULAR, 25),
    "h1": load_font(BOLD, 34),
    "h2": load_font(BOLD, 27),
    "body": load_font(REGULAR, 24),
    "body_bold": load_font(BOLD, 24),
    "small": load_font(REGULAR, 18),
    "code": load_font(MONO, 20),
}


def text_width(draw, text, font):
    if not text:
        return 0
    box = draw.textbbox((0, 0), text, font=font)
    return box[2] - box[0]


def wrap_text(draw, text, font, max_width):
    words = text.split()
    if not words:
        return [""]

    lines = []
    current = words[0]
    for word in words[1:]:
        candidate = f"{current} {word}"
        if text_width(draw, candidate, font) <= max_width:
            current = candidate
        else:
            lines.append(current)
            current = word
    lines.append(current)
    return lines


def new_page(page_no):
    img = Image.new("RGB", (PAGE_W, PAGE_H), "white")
    draw = ImageDraw.Draw(img)
    draw.rectangle((0, 0, PAGE_W, 22), fill=BLUE)
    draw.text(
        (MARGIN_X, PAGE_H - 48),
        f"Open Weather Flutter | Página {page_no}",
        fill=MUTED,
        font=FONTS["small"],
    )
    return img, draw


def draw_cover():
    img = Image.new("RGB", (PAGE_W, PAGE_H), LIGHT_BG)
    draw = ImageDraw.Draw(img)
    draw.rectangle((0, 0, PAGE_W, 360), fill=BLUE)
    draw.text((MARGIN_X, 130), "Open Weather Flutter", fill="white", font=FONTS["title"])
    draw.text(
        (MARGIN_X, 205),
        "Material de estudo e apresentação",
        fill=(219, 234, 254),
        font=FONTS["subtitle"],
    )

    y = 470
    blocks = [
        "Aplicativo Flutter de clima com API OpenWeather.",
        "Inclui busca de cidades, histórico, alertas e mapa climático interativo.",
        "Projeto organizado em camadas com Riverpod, Dio, Geolocator e Flutter Map.",
    ]
    for block in blocks:
        for line in wrap_text(draw, block, FONTS["body"], CONTENT_W):
            draw.text((MARGIN_X, y), line, fill=BODY, font=FONTS["body"])
            y += 34
        y += 22

    card_y = 760
    draw.rounded_rectangle(
        (MARGIN_X, card_y, PAGE_W - MARGIN_X, card_y + 380),
        radius=18,
        fill="white",
        outline=(226, 232, 240),
        width=2,
    )
    items = [
        ("Tema", "Aplicativo mobile de previsão do tempo"),
        ("Linguagem", "Dart"),
        ("Framework", "Flutter"),
        ("API", "OpenWeather"),
        ("Objetivo", "Estudo, demonstração e apresentação acadêmica"),
    ]
    y = card_y + 52
    for label, value in items:
        draw.text((MARGIN_X + 42, y), f"{label}:", fill=BLUE, font=FONTS["body_bold"])
        draw.text((MARGIN_X + 190, y), value, fill=BODY, font=FONTS["body"])
        y += 58

    draw.text(
        (MARGIN_X, PAGE_H - 120),
        "Documento gerado para apoiar explicação técnica e apresentação na faculdade.",
        fill=MUTED,
        font=FONTS["small"],
    )
    return img


def parse_blocks(text):
    blocks = []
    code = []
    in_code = False

    for raw in text.splitlines():
        line = raw.rstrip()
        if line.startswith("```"):
            if in_code:
                blocks.append(("code", "\n".join(code)))
                code = []
                in_code = False
            else:
                in_code = True
            continue

        if in_code:
            code.append(line)
            continue

        if not line.strip():
            blocks.append(("space", ""))
        elif line.startswith("# "):
            blocks.append(("title", line[2:].strip()))
        elif line.startswith("## "):
            blocks.append(("h2", line[3:].strip()))
        elif line.startswith("- "):
            blocks.append(("bullet", line[2:].strip()))
        elif line[0:3].isdigit() and ". " in line[:5]:
            blocks.append(("body", line.strip()))
        else:
            blocks.append(("body", line.strip()))
    return blocks


def add_text_block(pages, img, draw, y, kind, text, page_no):
    if kind == "space":
        return img, draw, y + 16, page_no

    font = FONTS["body"]
    color = BODY
    indent = 0
    line_gap = 34
    before = 0
    after = 12

    if kind == "title":
        return img, draw, y, page_no
    if kind == "h2":
        font = FONTS["h2"]
        color = BLUE
        line_gap = 39
        before = 20
        after = 16
    elif kind == "bullet":
        indent = 28
        text = f"• {text}"
    elif kind == "code":
        font = FONTS["code"]
        color = DARK
        line_gap = 29
        before = 8
        after = 18

    y += before
    max_width = CONTENT_W - indent

    if kind == "code":
        raw_lines = []
        for code_line in text.splitlines() or [""]:
            raw_lines.extend(
                textwrap.wrap(code_line, width=82, replace_whitespace=False)
                or [""]
            )
        height = (len(raw_lines) * line_gap) + 28
        if y + height > PAGE_H - MARGIN_BOTTOM:
            pages.append(img)
            page_no += 1
            img, draw = new_page(page_no)
            y = MARGIN_TOP
        draw.rounded_rectangle(
            (MARGIN_X, y, PAGE_W - MARGIN_X, y + height),
            radius=10,
            fill=CODE_BG,
        )
        line_y = y + 14
        for code_line in raw_lines:
            draw.text((MARGIN_X + 18, line_y), code_line, fill=color, font=font)
            line_y += line_gap
        return img, draw, y + height + after, page_no

    lines = wrap_text(draw, text, font, max_width)
    height = len(lines) * line_gap
    if y + height > PAGE_H - MARGIN_BOTTOM:
        pages.append(img)
        page_no += 1
        img, draw = new_page(page_no)
        y = MARGIN_TOP

    for line in lines:
        draw.text((MARGIN_X + indent, y), line, fill=color, font=font)
        y += line_gap
    return img, draw, y + after, page_no


def build_pdf():
    source = SOURCE.read_text(encoding="utf-8")
    blocks = parse_blocks(source)

    pages = [draw_cover()]
    page_no = 2
    img, draw = new_page(page_no)
    y = MARGIN_TOP

    for kind, text in blocks:
        img, draw, y, page_no = add_text_block(pages, img, draw, y, kind, text, page_no)

    pages.append(img)
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    pages[0].save(OUTPUT, "PDF", resolution=150.0, save_all=True, append_images=pages[1:])


if __name__ == "__main__":
    build_pdf()
    print(OUTPUT)
