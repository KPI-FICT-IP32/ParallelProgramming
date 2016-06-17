# Parallel Programming Lab 3. Java
## Description
This is the third lab I wrote as a part of my university assignment for the parallel programming course.

## How To
This lab was written using [ant](http://ant.apache.org/) build tool. Here is the list of targets:
- **clean** delete all built resources (classes, artifacts)
- **compile** compile source code to `java` classes
- **jar** generate jar artifact
- **run** compile and run with no parameters

You can run lab using commandline
```[bash]
$ ant jar
$ java -jar build/jar 1000 # 1000 is the size of matricies and vectors
```

## Possible bugs
Command-line arguments are not checked, so it is possible to broke the lab passing non-integer or negative values as size

