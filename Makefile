.PHONY: clean all

RACO = raco
RACKET_FOR_BUILD = racket
RACKET = racket
RFLAGS =
MAIN = $$($$RACKET -e "(begin (require setup/cross-system) (display (if (eq? (cross-system-type 'os) 'windows) \"main.exe\" \"main\")))")

all: display-note.zip

display-note.zip: $(MAIN)
	$(RACKET_FOR_BUILD) -e "(begin (require \"installer.rkt\") (installer #f \".\"))"
	$(RACO) dist display-note $(MAIN)
	zip -r display-note.zip display-note

$(MAIN): main.rkt
	$(RACO) pkg install --deps search-auto --skip-installed pollen "git://github.com/Antigen-1/hasket.git"
	$(RACO) exe $(RFLAGS) -o $(MAIN) main.rkt

clean:
	-rm -rf display-note* $(MAIN) build
	$(MAKE) -C src clean
