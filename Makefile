
BIN_FOLDER=./bin
TMP_FOLDER=./tmp
SRC_FOLDER=./src
all:
	gcc -c FileLibs.c
	nvcc MatrixMultiply.cu -o MatrixMultiply.out
	gcc -o MatrixMultiply.out FileLibs.o MatrixMultiply.o
clean:
	rm ./*.out
