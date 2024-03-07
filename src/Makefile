RACO_FOR_BUILD = raco
export RACO_FOR_BUILD

HTML_OBJECTS=$(shell ls *.html.pm)
CSS_OBJECTS=$(shell ls *.css.pp)
HTML=$(basename $(HTML_OBJECTS))
CSS=$(basename $(CSS_OBJECTS))

.PHONY: render clean all

all: render $(HTML) $(CSS)
	$(RACO_FOR_BUILD) pollen publish . ../pollen-build

$(HTML): %.html: %.html.pm
	$(RACO_FOR_BUILD) pollen render $^

$(CSS): %.css: %.css.pp
	$(RACO_FOR_BUILD) pollen render $^

render:
	$(MAKE) -C pollen

clean:
	-rm -rf ./*.html ./*.css ../pollen-build
	$(MAKE) -C pollen clean
	$(RACO_FOR_BUILD) pollen reset
