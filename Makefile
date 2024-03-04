currentdir = $(realpath .)

.PHONY: all dist clean build

RACO = raco
RACKET_FOR_BUILD = racket

all: dist

dist: main build
	$(RACO) dist display-note main

build:
	$(RACKET_FOR_BUILD) -e "(parameterize ((current-directory \"$(currentdir)\")) (local-require \"installer.rkt\") (installer #f \".\"))"
	mkdir -p $(currentdir)/build
	cp -r $(currentdir)/htdocs $(currentdir)/pollen-build $(currentdir)/xexpr $(currentdir)/src/pollen-images $(currentdir)/build

main: main.rkt
	$(RACO) pkg install --deps search-auto web-server-lib pollen "git://github.com/Antigen-1/hasket.git"
	$(RACO) exe -o main main.rkt

clean:
	-rm -rf display-note main build
	$(MAKE) -C $(currentdir)/src clean
