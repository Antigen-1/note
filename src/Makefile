RACO_FOR_BUILD = raco

.PHONY: render clean all

all: render
	$(RACO_FOR_BUILD) pollen publish . ../pollen-build

render:	
	$(RACO_FOR_BUILD) pollen render -p ./*.p ./*.pp ./*.pm ./*.ptree ./pollen/*.pm 

clean:
	-rm -rf ./*.html ./*.css ./pollen/*.html ../pollen-build
	$(RACO_FOR_BUILD) pollen reset
