# CV Generation Makefile
# Generates PDFs for all theme × language combinations using RenderCV
#
# Usage:
#   make              - Build default theme (classic) for both languages
#   make all          - Build ALL themes × ALL languages
#   make en           - Build all themes for English
#   make es           - Build all themes for Spanish
#   make classic      - Build classic theme for both languages
#   make en-classic   - Build English CV with classic theme
#   make es-moderncv  - Build Spanish CV with moderncv theme
#   make clean        - Remove all generated output
#   make list         - Show all available targets

THEMES := classic harvard moderncv sb2nov engineeringresumes engineeringclassic
LANGS  := en es
OUTPUT := output

# Default: build classic for both languages
.DEFAULT_GOAL := default

default: en-classic es-classic

# Build all combinations
all: $(foreach lang,$(LANGS),$(foreach theme,$(THEMES),$(lang)-$(theme)))

# Per-language targets (all themes)
en: $(foreach theme,$(THEMES),en-$(theme))
es: $(foreach theme,$(THEMES),es-$(theme))

# Per-theme targets (all languages)
$(foreach theme,$(THEMES),$(eval $(theme): $(foreach lang,$(LANGS),$(lang)-$(theme))))

# Generic rule: <lang>-<theme>
define RENDER_RULE
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

$(foreach lang,$(LANGS),$(foreach theme,$(THEMES),$(eval $(call RENDER_RULE,$(lang),$(theme)))))

$(OUTPUT):
	mkdir -p $(OUTPUT)

# Collect all PDFs into a single directory for easy access
collect: all
	@mkdir -p $(OUTPUT)/pdf
	@for lang in $(LANGS); do \
		for theme in $(THEMES); do \
			find $(OUTPUT)/$$lang-$$theme -name "*.pdf" -exec cp {} $(OUTPUT)/pdf/Agustin_Loos_CV_$$lang-$$theme.pdf \; ; \
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
	@echo "  Per theme:"
	@$(foreach theme,$(THEMES),echo "  make $(theme)        → $(theme), both languages";)
	@echo ""
	@echo "  Specific combinations:"
	@$(foreach lang,$(LANGS),$(foreach theme,$(THEMES),echo "  make $(lang)-$(theme)";))
	@echo ""
	@echo "  Utilities:"
	@echo "  make clean        → remove all output"
	@echo "  make list         → show this help"

.PHONY: default all en es $(THEMES) collect clean list \
	$(foreach lang,$(LANGS),$(foreach theme,$(THEMES),$(lang)-$(theme)))
