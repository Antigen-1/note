currentdir = $(realpath .)
parentdir = $(realpath ..)
RACO_FOR_BUILD = raco

.PHONY: render clean all

all: render
	$(RACO_FOR_BUILD) pollen publish $(currentdir) $(parentdir)/pollen-build

render:	
	$(RACO_FOR_BUILD) pollen render -p $(currentdir)/*.p $(currentdir)/*.pp $(currentdir)/*.pm $(currentdir)/*.ptree $(currentdir)/pollen/*.pm 

clean:
	-rm -rf $(currentdir)/*.html $(currentdir)/*.css $(currentdir)/pollen/*.html $(parentdir)/pollen-build
	$(RACO_FOR_BUILD) pollen reset
