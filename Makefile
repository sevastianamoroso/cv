# CV Generation Makefile
# Generates PDFs for all theme × language combinations using RenderCV
#
# Usage:
#   make              - Build default theme (classic) for both languages
#   make all          - Build ALL themes × ALL languages (built-in + custom)
#   make en           - Build all themes for English
#   make es           - Build all themes for Spanish
#   make classic      - Build classic theme for both languages
#   make en-classic   - Build English CV with classic theme
#   make es-moderncv  - Build Spanish CV with moderncv theme
#   make en-compact   - Build English CV with compact custom design
#   make clean        - Remove all generated output
#   make list         - Show all available targets

# Built-in RenderCV themes
BUILTIN_THEMES := classic harvard moderncv sb2nov engineeringresumes engineeringclassic

# Custom design overrides (files in cv/designs/*.yaml)
CUSTOM_DESIGNS := compact dark minimal

# All available themes/designs
ALL_THEMES := $(BUILTIN_THEMES) $(CUSTOM_DESIGNS)

LANGS  := en es
OUTPUT := output

# Default: build classic for both languages
.DEFAULT_GOAL := default

default: en-classic es-classic

# Build all combinations
all: $(foreach lang,$(LANGS),$(foreach theme,$(ALL_THEMES),$(lang)-$(theme)))

# Per-language targets (all themes)
en: $(foreach theme,$(ALL_THEMES),en-$(theme))
es: $(foreach theme,$(ALL_THEMES),es-$(theme))

# Per-theme targets (all languages) — built-in
$(foreach theme,$(BUILTIN_THEMES),$(eval $(theme): $(foreach lang,$(LANGS),$(lang)-$(theme))))

# Per-theme targets (all languages) — custom
$(foreach theme,$(CUSTOM_DESIGNS),$(eval $(theme): $(foreach lang,$(LANGS),$(lang)-$(theme))))

# Generic rule for BUILT-IN themes: <lang>-<theme>
define BUILTIN_RULE
$(1)-$(2): cv/$(1).yaml | $(OUTPUT)
	@echo "╔══════════════════════════════════════════════╗"
	@echo "║  Rendering: $(1) × $(2)"
	@echo "╚══════════════════════════════════════════════╝"
	rendercv render cv/$(1).yaml \
		--design.theme $(2) \
		--output-folder $(OUTPUT)/$(1)-$(2) \
		--dont-generate-html \
		--dont-generate-markdown
	@echo "✓ Done: $(OUTPUT)/$(1)-$(2)/"
	@echo ""
endef

# Generic rule for CUSTOM designs: <lang>-<design>
define CUSTOM_RULE
$(1)-$(2): cv/$(1).yaml cv/designs/$(2).yaml | $(OUTPUT)
	@echo "╔══════════════════════════════════════════════╗"
	@echo "║  Rendering: $(1) × $(2) (custom design)"
	@echo "╚══════════════════════════════════════════════╝"
	rendercv render cv/$(1).yaml \
		--design cv/designs/$(2).yaml \
		--output-folder $(OUTPUT)/$(1)-$(2) \
		--dont-generate-html \
		--dont-generate-markdown
	@echo "✓ Done: $(OUTPUT)/$(1)-$(2)/"
	@echo ""
endef

$(foreach lang,$(LANGS),$(foreach theme,$(BUILTIN_THEMES),$(eval $(call BUILTIN_RULE,$(lang),$(theme)))))
$(foreach lang,$(LANGS),$(foreach theme,$(CUSTOM_DESIGNS),$(eval $(call CUSTOM_RULE,$(lang),$(theme)))))

$(OUTPUT):
	mkdir -p $(OUTPUT)

# Collect all PDFs into a single directory for easy access
collect: all
	@mkdir -p $(OUTPUT)/pdf
	@for lang in $(LANGS); do \
		for theme in $(ALL_THEMES); do \
			find $(OUTPUT)/$$lang-$$theme -name "*.pdf" -exec cp {} $(OUTPUT)/pdf/Sebastian_Amoroso_CV_$$lang-$$theme.pdf \; 2>/dev/null; \
		done; \
	done
	@echo "All PDFs collected in $(OUTPUT)/pdf/"

clean:
	rm -rf $(OUTPUT)

list:
	@echo "Available targets:"
	@echo ""
	@echo "  make              → classic theme, both languages (default)"
	@echo "  make all          → all themes × all languages"
	@echo "  make collect      → build all + collect PDFs into output/pdf/"
	@echo ""
	@echo "  Per language:"
	@echo "  make en           → all themes, English"
	@echo "  make es           → all themes, Spanish"
	@echo ""
	@echo "  Built-in themes (both languages):"
	@$(foreach theme,$(BUILTIN_THEMES),echo "  make $(theme)";)
	@echo ""
	@echo "  Custom designs (both languages):"
	@$(foreach theme,$(CUSTOM_DESIGNS),echo "  make $(theme)";)
	@echo ""
	@echo "  Specific combinations:"
	@$(foreach lang,$(LANGS),$(foreach theme,$(ALL_THEMES),echo "  make $(lang)-$(theme)";))
	@echo ""
	@echo "  Utilities:"
	@echo "  make clean        → remove all output"
	@echo "  make list         → show this help"

.PHONY: default all en es $(ALL_THEMES) collect clean list \
	$(foreach lang,$(LANGS),$(foreach theme,$(ALL_THEMES),$(lang)-$(theme)))
