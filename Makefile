currentdir = $(realpath .)

.PHONY: all dist clean build

RACO = raco
RACKET_FOR_BUILD = racket
RACKET = racket
EXF =

FIND_MAIN = $(RACKET) -e "(display (if (eq? (system-type 'os) 'windows) \"main.exe\" \"main\"))"
MAIN = $(shell $(FIND_MAIN))

all: dist

dist: $(MAIN) build
	$(RACO) dist display-note $(MAIN)

build:
	$(RACKET_FOR_BUILD) -e "(parameterize ((current-directory \"$(currentdir)\")) (local-require \"installer.rkt\") (installer #f \".\"))"

$(MAIN): main.rkt
	$(RACO) pkg install --deps search-auto --skip-installed pollen "git://github.com/Antigen-1/hasket.git"
	$(RACO) exe $(EXF) -o $(MAIN) main.rkt

clean:
	-rm -rf display-note $(MAIN) build
	$(MAKE) -C $(currentdir)/src clean
