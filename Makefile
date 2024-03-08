.PHONY: clean all

RACO = raco
RACKET_FOR_BUILD = racket
RACKET = racket
RFLAGS =
MAIN = $(shell ${RACKET} -e "(begin (require setup/cross-system) (display (if (eq? (cross-system-type 'os) 'windows) \"main.exe\" \"main\")))")
ARCHIVE = display-note.zip

all: $(ARCHIVE)

run: $(MAIN)
	$< --launch-browser --banner

$(ARCHIVE): $(MAIN) installer.rkt
	$(RACKET_FOR_BUILD) -e "(begin (require \"installer.rkt\") (installer #f \".\"))"
	$(RACO) dist display-note $<
	zip -r $@ display-note

$(MAIN): main.rkt
	$(RACO) pkg install --deps search-auto --skip-installed pollen sugar "git://github.com/Antigen-1/hasket.git"
	$(RACO) exe $(RFLAGS) -o $@ $<

clean:
	-rm -rf display-note* $(MAIN) build xexpr
	$(MAKE) -C src clean
