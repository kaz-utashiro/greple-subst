LANGS    := JA KO ZH
RM_LANGS := JA KO ZH
IGNORE   := VERSION AUTHOR LICENSE

MOD_NAME := $(shell perl -MJSON -0777nE 'say decode_json($$_)->{name}' ../META.json)
MOD_PATH := ../lib/$(subst -,/,$(MOD_NAME)).pm
MOD_FILE := $(notdir $(MOD_PATH))
MOD_DIR  := $(dir $(MOD_PATH))
MOD_NAME := $(MOD_FILE:.pm=)
SRC_DIR  := src

ORIGIN   := $(wildcard $(MOD_DIR)*.pm)
PM       := $(notdir $(ORIGIN))
SRC      := $(PM:%=$(if $(SRC_DIR),$(SRC_DIR)/,)%)
PMS      := $(foreach lang,$(LANGS),$(SRC:.pm=.$(lang).pm))
MDS      := $(foreach lang,$(LANGS),$(PM:.pm=.$(lang).md))
READMES  := $(RM_LANGS:%=../README.%.md)
ALL      := $(PMS) $(MDS) README.md $(READMES)

all: $(ALL)

ifdef SRC_DIR
  $(SRC_DIR):
	mkdir -p $(SRC_DIR)
endif
SRCPATH := $(if $(SRC_DIR),$(SRC_DIR)/,)

$(foreach mod,$(ORIGIN),$(eval $(SRCPATH)$(notdir $(mod)): $(mod) $(SRC_DIR); cp $$< $(if $(SRCPATH),$(SRCPATH),.)))

XLATE := greple -Mxlate::deepl
XLATE += $(if $(XLATE_LABOR),--xlate-labor,--xlate)
XLATE += --xlate-cache=$(if $(XLATE_INIT),clear,yes)
XLATE += --match-podtext --xlate-format=none --all --need=0

ifdef IGNORE
$(foreach ignore,$(IGNORE),$(eval \
  XLATE += --exclude '^=head\d[ ]+$(ignore)\b(?s:.*?)(?=^=|\z)'\
))
endif

JA_FORM   ?= dearu
JA_DICT   := $(wildcard *.dict)
JA_FILTER := greple -Mperl -Msubst::desumasu \
	$(if $(findstring $(JA_FORM).dict,$(JA_DICT)), --dict $(JA_FORM).dict) \
	--pod --subst --all --no-color --need=0 \
	--$(JA_FORM) 

define LANG_PM
  $(SRCPATH)%.$1.pm: $(SRCPATH)%.pm Makefile
  ifdef $1_FILTER
	$$(XLATE) --xlate-to $1 $$< | $$($1_FILTER) > $$@
  else
	$$(XLATE) --xlate-to $1 $$< > $$@
  endif
endef

$(foreach lang,$(LANGS),$(eval $(call LANG_PM,$(lang))))

%.md: $(SRCPATH)%.pm
	pod2markdown $< > $@

define LANG_README
  ../README.$1.md: $(MOD_NAME).$1.md
	cp $$< $$@
endef

$(foreach lang,$(RM_LANGS),$(eval $(call LANG_README,$(lang))))

README.md: Makefile
	exec > $@ && \
	printf '## Languages\n\n' && \
	for md in $(MDS) ; \
	do \
	    echo "- [$$md]($$md)" ; \
	done

clean:
	rm -f $(SRC) $(ALL)
