# CV — Agustin Loos

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
│   ├── en.yaml          # English CV content (source of truth)
│   └── es.yaml          # Spanish CV content (source of truth)
├── Makefile             # Build system
├── .gitignore
└── README.md
```

## Available Themes

| Theme | Style |
|-------|-------|
| `classic` | Clean, professional, blue accents (default) |
| `harvard` | Serif font, centered section titles, black & white |
| `moderncv` | Modern sidebar-style layout with color bar |
| `sb2nov` | LaTeX Computer Modern feel, minimalist |
| `engineeringresumes` | Dense, ATS-friendly, full-width lines |
| `engineeringclassic` | Raleway font, engineering-oriented |

Preview all themes at [rendercv.com](https://docs.rendercv.com/user_guide/themes/).

## Makefile Targets

```bash
make                    # classic theme, both languages (default)
make all                # all 6 themes × 2 languages = 12 PDFs
make collect            # build all + collect PDFs into output/pdf/

# Per language
make en                 # all themes, English
make es                 # all themes, Spanish

# Per theme
make classic            # classic, both languages
make harvard            # harvard, both languages
make moderncv           # moderncv, both languages
make sb2nov             # sb2nov, both languages
make engineeringresumes # engineeringresumes, both languages
make engineeringclassic # engineeringclassic, both languages

# Specific combinations
make en-classic         # English + classic
make es-moderncv        # Spanish + moderncv
make en-sb2nov          # English + sb2nov
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
│   ├── Agustin_Loos_CV.pdf      # PDF
│   ├── Agustin_Loos_CV.typ      # Typst source
│   ├── Agustin_Loos_CV_1.png    # Page previews
│   ├── Agustin_Loos_CV_2.png
│   └── Agustin_Loos_CV_3.png
└── es-classic/
    └── ...
```

`make collect` copies all PDFs to `output/pdf/` with descriptive names:

```
output/pdf/
├── Agustin_Loos_CV_en-classic.pdf
├── Agustin_Loos_CV_en-harvard.pdf
├── Agustin_Loos_CV_es-classic.pdf
└── ...
```

## License

Personal CV content. Not for reuse.
