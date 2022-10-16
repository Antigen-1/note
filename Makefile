.PHONY: render clean

render:	
	raco pollen render -p *.p *.pp *.pm *.ptree

clean:
	-rm *.html
	raco pollen reset
