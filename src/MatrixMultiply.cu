#include<stdio.h>
#include "Structures.h"
#include "Constantes.h"
#include "MemoryLib.h"
#include "FileLib.h"
#include "MatrixLib.h"
#include "CudaFunctions.h"

int main(int argc, char** argv){

	//ConstString fileA = "./data/A.txt";
	//ConstString fileB = "./data/B.txt";
  //ConstString fileA = "./data/3x3.txt";
  //ConstString fileB = "./data/Identity.txt";

	printf("argc: %d,\n",argc);
	char* fileA = NULL;
	char* fileB = NULL;
	char* fileRes = NULL;

	switch(argc){
		case 3:
			fileA = argv[1];
			fileB = argv[2];
		break;
		case 4:
			fileA = argv[1];
			fileB = argv[2];
			fileRes = argv[3];
		break;
		default:
			printf("MatrixMultiply.cu <MatrixA> <MatrixB> [FileNameRes]\n");
		break;
	}
	//ConstString fileRes = "./data/Res.txt";
	/*ConstString fileA = "./data/genMatA.txt";
	ConstString fileB = "./data/genMatB.txt";
	ConstString fileRes = "./data/Res.txt";
  */


	getCudaProperties();

	
	Matrix h_matrizA;
	Matrix h_matrizB;
	Matrix h_matrizRes;

	MatrixSize matrixSize_Res;

	h_matrizA = leeFichero(fileA);
	if (h_matrizA.matrixValues == NULL){
		return 1;
	}
	h_matrizB = leeFichero(fileB);
	if (h_matrizB.matrixValues == NULL){
		return 1;
	}

	int returnValue = calculaTamanosMult(h_matrizA.size,h_matrizB.size,matrixSize_Res);
	if (returnValue != RETURN_OK){
		printf("Tamanos distintos\n");
		liberaMemoriaMatriz(h_matrizA);
		liberaMemoriaMatriz(h_matrizB);
		return 1;
	}

	h_matrizRes= reservaMemoriaMatriz(matrixSize_Res);
	if (h_matrizRes.matrixValues == NULL)
	{
		liberaMemoriaMatriz(h_matrizA);
		liberaMemoriaMatriz(h_matrizB);
		return 2;
	}

	//Empieza la multiplicacion.
	//TODO: https://www.cs.cmu.edu/afs/cs/academic/class/15668-s11/www/cuda-doc/html/group__CUDART__MEMORY_gb17fef862d4d1fefb9dba35bd62a187e.html

  Matrix* d_matrix_Res = moveMatrix_2_device(&h_matrizRes);
  Matrix* d_matrix_A = moveMatrix_2_device(&h_matrizA);
  Matrix* d_matrix_B = moveMatrix_2_device(&h_matrizB);

  if(d_matrix_Res == NULL || d_matrix_A == NULL || d_matrix_B == NULL){
    liberaMemoriaMatriz(h_matrizA);
    liberaMemoriaMatriz(h_matrizB);
    liberaMemoriaMatriz(h_matrizRes);
    return 3;
  }

  MyDim3 dimBlock = newMyDim3(matrixSize_Res.i,matrixSize_Res.j,1);
  MyDim3 dimGrid = newMyDim3(1,1,1);

  multiplica(d_matrix_A, d_matrix_B, d_matrix_Res, dimBlock, dimGrid);

  cudaDeviceSynchronize();

  Matrix* h_matriz_Res_v2;

  h_matriz_Res_v2 = moveMatrix_2_host(d_matrix_Res,h_matrizRes.size.i,h_matrizRes.size.j);

	printMatrix(*h_matriz_Res_v2);

  escribeFichero(fileRes, *h_matriz_Res_v2);

	cudaFree(d_matrix_A);
	cudaFree(d_matrix_B);
	cudaFree(d_matrix_Res);
	//Finalizamos.

	liberaMemoriaMatriz(h_matrizA);
	liberaMemoriaMatriz(h_matrizB);
	liberaMemoriaMatriz(h_matrizRes);
  liberaMemoriaMatriz(*h_matriz_Res_v2);

  free (h_matriz_Res_v2);

	return RETURN_OK;
}
