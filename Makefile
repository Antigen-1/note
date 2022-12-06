.PHONY: render clean

render:	
	raco pollen render -p *.p *.pp *.pm *.ptree
	pandoc -f org -t html 预防医学.org -o 预防医学.html

clean:
	-rm *.html
	raco pollen reset
