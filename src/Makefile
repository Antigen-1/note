RACO_FOR_BUILD = raco
export RACO_FOR_BUILD

.PHONY: render clean all

all: render
	$(RACO_FOR_BUILD) pollen publish . ../pollen-build

render:	
	$(RACO_FOR_BUILD) pollen render -p ./*.pp ./*.pm
	$(MAKE) -C pollen

clean:
	-rm -rf ./*.html ./*.css ../pollen-build
	$(MAKE) -C pollen clean
	$(RACO_FOR_BUILD) pollen reset
