.DEFAULT_GOAL = all
APP_NAME = lab06

CXXFLAGS = -Wall -std=c++11 -fopenmp
LINKFLAGS = -Wall -fopenmp

obj:
	mkdir obj

obj/matrix.o: obj src/matrix.h src/matrix.cpp
	${CXX} ${CXXFLAGS} -c src/matrix.cpp -o obj/matrix.o

obj/vector.o: obj src/vector.h src/vector.cpp src/matrix.h
	${CXX} ${CXXFLAGS} -c src/vector.cpp -o obj/vector.o

obj/functions.o: obj src/functions.h src/functions.cpp src/vector.h src/matrix.h
	${CXX} ${CXXFLAGS} -c src/functions.cpp -o obj/functions.o

obj/tasks.o: obj src/tasks.h src/tasks.cpp src/functions.h src/vector.h src/matrix.h
	${CXX} ${CXXFLAGS} -c src/tasks.cpp -o obj/tasks.o

obj/cmdopts.o: obj src/cmdopts.h src/cmdopts.cpp
	${CXX} ${CXXFLAGS} -c src/cmdopts.cpp -o obj/cmdopts.o

obj/main.o: obj src/lab06.cpp src/tasks.h src/functions.h src/vector.h src/matrix.h
	${CXX} ${CXXFLAGS} -c src/lab06.cpp -o obj/main.o

bin:
	mkdir bin

bin/${APP_NAME}: bin obj/matrix.o obj/vector.o obj/functions.o obj/tasks.o obj/cmdopts.o obj/main.o
	${CXX} ${LINKFLAGS} -o bin/${APP_NAME} obj/*

clean:
	rm -rf obj bin

all: bin/${APP_NAME}

