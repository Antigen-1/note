RACO_FOR_BUILD = raco

.PHONY: render clean all

all: render
	$(RACO_FOR_BUILD) pollen publish . ../pollen-build

render:	
	$(RACO_FOR_BUILD) pollen render -p ./*.pp ./*.pm ./pollen/*.ptree ./pollen/*.pm ./pollen/*.p 

clean:
	-rm -rf ./*.html ./*.css ./pollen/*.html ../pollen-build
	$(RACO_FOR_BUILD) pollen reset
