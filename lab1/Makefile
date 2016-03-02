.DEFAULT_GOAL := all

build:
	gnatmake -Wall lab1.adb

clean-dist:
	rm -f *.o *.ali *.lst

clean: clean-dist
	rm -f lab1

all: build clean-dist
