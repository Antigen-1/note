currentdir = $(realpath .)
parentdir = $(realpath ..)

.PHONY: render clean all

all: render
	raco pollen publish $(currentdir) $(parentdir)/pollen-build

render:	
	raco pollen render -p $(currentdir)/*.p $(currentdir)/*.pp $(currentdir)/*.pm $(currentdir)/*.ptree $(currentdir)/*.pmd \
			      $(currentdir)/pollen/*.p $(currentdir)/pollen/*.pp $(currentdir)/pollen/*.pm $(currentdir)/pollen/*.ptree $(currentdir)/pollen/*.pmd 

clean:
	-rm -rf $(currentdir)/*.html $(currentdir)/pollen/*.html $(parentdir)/pollen-build
	raco pollen reset
