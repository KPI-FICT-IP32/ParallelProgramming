.DEFAULT_GOAL := all

build:
	gnatmake -Wall lab7.adb

clean-dist:
	rm -f *.o *.ali *.lst

clean: clean-dist
	rm -f lab7

all: build clean-dist
