HTML_OBJECTS=$(shell ls *.html.pm)
HTML=$(basename ${HTML_OBJECTS})

.PHONY: all clean index

all: $(HTML) index

$(HTML): %.html: %.html.pm
	$(RACO_FOR_BUILD) pollen render $^

index: index.ptree
	$(RACO_FOR_BUILD) pollen render $^

clean:
	-rm -rf *.html
	$(RACO_FOR_BUILD) pollen reset
