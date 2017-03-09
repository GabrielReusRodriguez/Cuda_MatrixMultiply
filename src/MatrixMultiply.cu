#include<stdio.h>
#include "Structures.h"
#include "MemoryLib.h"
#include "FileLib.h"



int main(void){

	const char* fileA = "./data/A.txt";
	const char* fileB = "./data/B.txt";
	const char* fileRes = "./data/Res.txt";

	float ** matrizA = NULL;
	float ** matrizB = NULL;
	float ** matrizRes = NULL;

	int size_i_matrixA,size_j_matrixA;
	int size_i_matrixB,size_j_matrixB;
	int size_i_matrixRes,size_j_matrixRes;

	matrizA = leeFichero(fileA,size_i_matrixA,size_j_matrixA);
	if (matrizA == NULL){
		return 1;
	}
	matrizB = leeFichero(fileB,size_i_matrixB,size_j_matrixB);
	if (matrizB == NULL){
		return 1;
	}





	liberaMemoriaMatriz(matrizA,size_i_matrixA);
	liberaMemoriaMatriz(matrizB,size_i_matrixB);

	printf("Hola mundo!\n");

}
