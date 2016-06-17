.DEFAULT_GOAL := all

build:
	gnatmake -Wall lab2.adb

clean-dist:
	rm -f *.o *.ali *.lst

clean: clean-dist
	rm -f lab2

all: build clean-dist
