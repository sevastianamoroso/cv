# CV — Sebastian Amoroso

Personal CV managed as code. Write content in YAML, generate publication-quality PDFs with [RenderCV](https://github.com/sinaatalay/rendercv).

## Quick Start

```bash
# 1. Install dependencies
uv tool install "rendercv[full]"   # or: pip install "rendercv[full]"

# 2. Generate PDFs (classic theme, both languages)
make

# 3. Find your PDFs
ls output/en-classic/   # English
ls output/es-classic/   # Spanish
```

## Dependencies

| Tool | Version | Install | Purpose |
|------|---------|---------|---------|
| [RenderCV](https://docs.rendercv.com/) | 2.8+ | `uv tool install "rendercv[full]"` | YAML → PDF via Typst |
| [uv](https://docs.astral.sh/uv/) | any | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | Python tool manager (recommended) |
| Make | any | Pre-installed on Linux/macOS | Build orchestration |

> [!NOTE]
> RenderCV bundles its own Typst binary and fonts. No additional typesetting tools needed.

## Project Structure

```
.
├── cv/
│   ├── en.yaml              # English CV content (source of truth)
│   ├── es.yaml              # Spanish CV content (source of truth)
│   └── designs/
│       ├── compact.yaml     # Compact: tighter margins, 9pt font, fits in 2 pages
│       ├── dark.yaml        # Dark teal accents with Charter serif font
│       └── minimal.yaml     # Black & white, no icons, no footer, ATS-friendly
├── Makefile                 # Build system
├── .gitignore
└── README.md
```

## Available Themes

### Built-in RenderCV Themes

| Theme | Style |
|-------|-------|
| `classic` | Clean, professional, blue accents (default) |
| `harvard` | Serif font (XCharter), centered section titles, black & white |
| `moderncv` | Left-aligned with color bar section titles (Fontin font) |
| `sb2nov` | LaTeX Computer Modern feel, minimalist |
| `engineeringresumes` | Dense, ATS-friendly, full-width lines |
| `engineeringclassic` | Raleway font, engineering-oriented |

### Custom Design Overrides

| Design | Style |
|--------|-------|
| `compact` | Tighter margins (0.5in), 9pt font — fits CV in 2 pages |
| `dark` | Dark teal color scheme with Charter serif font |
| `minimal` | Pure black & white, no icons, no footer — maximum ATS compatibility |

Custom designs are loaded as separate files via `--design` and can be combined with any CV content.

Preview built-in themes at [rendercv.com](https://docs.rendercv.com/user_guide/themes/).

## Makefile Targets

```bash
make                    # classic theme, both languages (default)
make all                # all 9 themes × 2 languages = 18 PDFs
make collect            # build all + collect PDFs into output/pdf/

# Per language
make en                 # all themes, English
make es                 # all themes, Spanish

# Built-in themes (both languages)
make classic
make harvard
make moderncv
make sb2nov
make engineeringresumes
make engineeringclassic

# Custom designs (both languages)
make compact
make dark
make minimal

# Specific combinations
make en-classic         # English + classic
make es-moderncv        # Spanish + moderncv
make en-compact         # English + compact (2-page version)
make es-dark            # Spanish + dark teal
# ... any <lang>-<theme> combination

# Utilities
make clean              # remove all generated output
make list               # show all available targets
```

## Editing Your CV

Edit the YAML files directly:

- **English:** [`cv/en.yaml`](cv/en.yaml)
- **Spanish:** [`cv/es.yaml`](cv/es.yaml)

Then run `make` to regenerate. The YAML files are the single source of truth — no Word documents needed.

The Spanish CV includes `locale: spanish` for proper date and month translation.

### Adding a Custom Design

Create a new file in `cv/designs/` with any [RenderCV design fields](https://docs.rendercv.com/) you want to override:

```yaml
# cv/designs/my-theme.yaml
design:
  theme: classic
  colors:
    name: rgb(180, 30, 30)
    section_titles: rgb(180, 30, 30)
  typography:
    font_family:
      body: Charter
```

Then add `my-theme` to `CUSTOM_DESIGNS` in the Makefile.

### YAML Basics

```yaml
cv:
  sections:
    experience:
      - company: Acme Corp
        position: Senior Developer
        start_date: 2024-01
        end_date: present
        highlights:
          - "Built something impactful"

    skills:
      - label: Languages
        details: TypeScript, Go, Python
```

Key rules:
- **Quote strings containing colons** (`:`): `"Relevant coursework: Distributed Systems"`
- **Phone numbers** must be international format: `"+5492926407072"`
- **Dates**: `YYYY-MM`, `YYYY-MM-DD`, `YYYY`, or `"present"`
- **Section keys** in `snake_case` auto-capitalize: `work_experience` → "Work Experience"
- Supports inline Markdown: `**bold**`, `*italic*`, `[links](url)`

Full schema reference: [RenderCV docs](https://docs.rendercv.com/)

## Output

Generated files go to `output/<lang>-<theme>/`:

```
output/
├── en-classic/
│   ├── Sebastian_Amoroso_CV.pdf      # PDF
│   ├── Sebastian_Amoroso_CV.typ      # Typst source
│   ├── Sebastian_Amoroso_CV_1.png    # Page previews
│   └── ...
├── en-compact/                  # 2-page compact version
└── es-classic/
    └── ...
```

`make collect` copies all PDFs to `output/pdf/` with descriptive names:

```
output/pdf/
├── Sebastian_Amoroso_CV_en-classic.pdf
├── Sebastian_Amoroso_CV_en-compact.pdf
├── Sebastian_Amoroso_CV_en-dark.pdf
├── Sebastian_Amoroso_CV_es-classic.pdf
└── ...
```

## License

Personal CV content. Not for reuse.
