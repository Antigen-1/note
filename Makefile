currentdir = $(realpath .)

.PHONY: all dist clean build

RACO = raco
RACKET_FOR_BUILD = racket
EXF =

all: dist

dist: main build
	$(RACO) dist display-note main

build:
	$(RACKET_FOR_BUILD) -e "(parameterize ((current-directory \"$(currentdir)\")) (local-require \"installer.rkt\") (installer #f \".\"))"

main: main.rkt
	$(RACO) pkg install --deps search-auto --skip-installed pollen "git://github.com/Antigen-1/hasket.git"
	$(RACO) exe $(EXF) -o main main.rkt

clean:
	-rm -rf display-note main build
	$(MAKE) -C $(currentdir)/src clean
