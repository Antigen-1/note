currentdir = $(realpath .)
parentdir = $(realpath ..)

.PHONY: render clean all

all: render
	raco pollen publish $(currentdir) $(parentdir)/pollen-build

render:	
	raco pollen render -p $(currentdir)/*.p $(currentdir)/*.pp $(currentdir)/*.pm $(currentdir)/*.ptree $(currentdir)/pollen/*.pm 

clean:
	-rm -rf $(currentdir)/*.html $(currentdir)/*.css $(currentdir)/pollen/*.html $(parentdir)/pollen-build
	raco pollen reset
