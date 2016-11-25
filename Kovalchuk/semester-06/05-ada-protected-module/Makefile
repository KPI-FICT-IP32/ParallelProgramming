.DEFAULT_GOAL := all

build:
	gnatmake -Wall lab5.adb

clean-dist:
	rm -f *.o *.ali *.lst

clean: clean-dist
	rm -f lab5

all: build clean-dist
