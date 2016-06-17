.DEFAULT_GOAL = all
APP_NAME = lab04

CXXFLAGS = -Wall -std=c++11 -fopenmp
LINKFLAGS = -Wall -fopenmp

obj:
	mkdir obj

obj/util.o: obj src/util.cpp src/util.h
	${CXX} ${CXXFLAGS} -c src/util.cpp -o obj/util.o

obj/main.o: obj src/lab04.cpp src/lab04.h src/util.h
	${CXX} ${CXXFLAGS} -c src/lab04.cpp -o obj/main.o

bin:
	mkdir bin

bin/${APP_NAME}: bin obj/main.o obj/util.o
	${CXX} ${LINKFLAGS} -o bin/${APP_NAME} obj/*

clean:
	rm -rf obj bin

all: bin/${APP_NAME}
