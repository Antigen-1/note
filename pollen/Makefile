.PHONY: render clean all

all: render
	raco pollen publish . ./build

render:	
	raco pollen render -p *.p *.pp *.pm *.ptree *.pmd

clean:
	-rm -rf *.html build
	raco pollen reset
