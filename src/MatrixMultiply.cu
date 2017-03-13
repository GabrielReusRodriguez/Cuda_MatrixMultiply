#include<stdio.h>
#include "Structures.h"
#include "Constantes.h"
#include "MemoryLib.h"
#include "FileLib.h"
#include "MatrixLib.h"
#include "CudaFunctions.h"



__global__
void multiplica(Matrix* matrixA, Matrix* matrixB, Matrix* matrixRes,float *test )
{
  int i;
  int j;

  MatrixType value;

  //Determino la posición de la matriz según bloque y thread

  //printf("Valor size i %zd %zd\n",matrixRes->size.i,matrixRes->size.j);

  i =  threadIdx.x;
  j =  threadIdx.y;
/*
  i=0;
  j=0;
  */

  value = 0.0f;

  int index = j*matrixRes->size.i+i;

  for(int desp = 0;desp < matrixA->size.i;desp++ )
  {
    int ii_A=desp;
    int jj_A=j;
    int ii_B=i;
    int jj_B=desp;

    int index_A = jj_A*matrixA->size.i+ii_A;
    int index_B = jj_B*matrixB->size.i+ii_B;


    value+= matrixA->matrixValues[index_A]*matrixB->matrixValues[index_B];

    //value+= matrixA->matrixValues[index_A];
  }

  //value  = matrixA->matrixValues[index]+matrixB->matrixValues[index];

  matrixRes->matrixValues[index] = value;


//*test = (*matrixRes).matrixValues[1];
*test = matrixRes->matrixValues[index];

//*test = matrixRes->matrixValues[0];
//*test = value;
*test = matrixA->size.i;



  /*
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i];
  */
}


Matrix* moveMatrix_2_device(Matrix *h_matrix)
{
  Matrix* localMatrix;
  Matrix* p_return = NULL;
  MatrixType* d_data;

  localMatrix = (Matrix*)malloc(sizeof(Matrix));
  if (localMatrix == NULL){
    return p_return;
  }
  /*
  printf("pre memcpy\n");
  h_data = (MatrixType *)malloc(matrix->size.i*matrix->size.j*sizeof(MatrixType));
  memcpy(h_data,(*matrix).matrixValues,matrix->size.i*matrix->size.j*sizeof(MatrixType));
  printf("post memcpy\n");
*/

  cudaMalloc((void **)&d_data,h_matrix->size.i*h_matrix->size.j*sizeof(MatrixType));
  cudaMemcpy((void *)d_data,(void *)h_matrix->matrixValues,h_matrix->size.i*h_matrix->size.j*sizeof(MatrixType),cudaMemcpyHostToDevice);
  //cudaMemcpy((void *)d_data,h_data,matrix->size.i*matrix->size.j*sizeof(MatrixType),cudaMemcpyHostToDevice);

  localMatrix->matrixValues = d_data;
  localMatrix->size.i = h_matrix->size.i;
  localMatrix->size.j = h_matrix->size.j;

  cudaMalloc((void **)&p_return,sizeof(Matrix));
  cudaMemcpy(p_return,localMatrix,sizeof(Matrix),cudaMemcpyHostToDevice);

  return p_return;

}


Matrix* moveMatrix_2_host(Matrix *d_matrix, int size_i, int size_j)
{
  Matrix* localMatrix;
  Matrix* p_return = NULL;


  localMatrix = (Matrix*)malloc(sizeof(Matrix));
  if (localMatrix == NULL){
    printf("NULLACO \n");
    return p_return;
  }

  localMatrix->matrixValues = (MatrixType*)malloc(size_i*size_j*sizeof(MatrixType));

  MatrixType* d_data;
  MatrixType* h_data;

  cudaMemcpy((void *)localMatrix,(void *)d_matrix,sizeof(Matrix),cudaMemcpyDeviceToHost);

  d_data = localMatrix->matrixValues;
  h_data = (MatrixType *)malloc(size_i*size_j*sizeof(MatrixType));
  cudaMemcpy((void *)h_data,(void *)d_data,size_i*size_j*sizeof(MatrixType),cudaMemcpyDeviceToHost);
  localMatrix->matrixValues = h_data;

  return localMatrix;

}



int main(void){

	//ConstString fileA = "./data/A.txt";
	//ConstString fileB = "./data/B.txt";
  ConstString fileA = "./data/3x3.txt";
  ConstString fileB = "./data/Identity.txt";

	ConstString fileRes = "./data/Res.txt";

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
	Matrix* d_matrix_A;
	const size_t a_size = sizeof(MatrixType) * size_t(h_matrizA.size.i*h_matrizA.size.j);

	Matrix* d_matrix_B;
	const size_t b_size = sizeof(MatrixType) * size_t(h_matrizB.size.i*h_matrizB.size.j);

	Matrix* d_matrix_Res;
	const size_t res_size = sizeof(MatrixType) * size_t(h_matrizRes.size.i*h_matrizRes.size.j);
	//printf("Pre-malloc\n");

//http://horacio9573.no-ip.org/cuda/group__CUDART__MEMORY_g17f3a55e8c9aef5f90b67cdf22851375.html#g17f3a55e8c9aef5f90b67cdf22851375
//http://horacio9573.no-ip.org/cuda/group__CUDART__TYPES_g18fa99055ee694244a270e4d5101e95b.html#gg18fa99055ee694244a270e4d5101e95b783338534304281650c6cb1363f5a00a
	//printf("Post-FOR\n");
	h_matrizRes.matrixValues[1] = 5.0f;
 	///cudaMalloc((void**)&d_matrix_Res,res_size);
	//cudaMemcpy((void*)d_matrix_Res,(void*)&h_matrizRes,sizeof(Matrix),cudaMemcpyHostToDevice);
  d_matrix_Res = moveMatrix_2_device(&h_matrizRes);
  d_matrix_A = moveMatrix_2_device(&h_matrizA);
  d_matrix_B = moveMatrix_2_device(&h_matrizB);

  if(d_matrix_Res == NULL){
    printf("NULLACO \n");
  }

	float *p_test;
	float test = -1.0f;
	cudaMalloc((void**)&p_test,sizeof(float));
	cudaMemcpy((void*)p_test,(void*)&test,sizeof(float),cudaMemcpyHostToDevice);

		dim3 dimBlock( matrixSize_Res.i, matrixSize_Res.j );
		dim3 dimGrid( 1, 1 );

	multiplica<<<dimGrid, dimBlock>>>(d_matrix_A, d_matrix_B, d_matrix_Res,p_test);

	cudaMemcpy((void*)&test,(void*)p_test,sizeof(float),cudaMemcpyDeviceToHost);

	//printf("TEST: %f\n",test);

  Matrix* h_matriz_Res_v2;

  h_matriz_Res_v2 = moveMatrix_2_host(d_matrix_Res,h_matrizRes.size.i,h_matrizRes.size.j);
  //printf("Salida: \n");

	//cudaMemcpy((void *)h_matrizRes.matrixValues, (void *)&(d_matrix_Res->matrixValues), res_size, cudaMemcpyDeviceToHost);
	//cudaMemcpy((void *)&h_matrizRes, (void *)d_matrix_Res, sizeof(Matrix), cudaMemcpyDeviceToHost);

/*
	cudaMemcpy((void *)&h_matrizRes, (void *)d_matrix_Res, sizeof(Matrix), cudaMemcpyDeviceToHost);
	cudaMemcpy((void *)&(h_matrizRes->matrixValues), (void *)d_matrix_Res.matrixValues, res_size, cudaMemcpyHostToDevice);
	*/
	/*
	for (int i=0;i<h_matrizRes.size.i;i++)
	{
			//cudaMalloc((void **)&(d_matrix_Res->matrixValues[i]),h_matrizRes.size.j*sizeof(MatrixType*));
			cudaMemcpy(&(h_matrizRes.matrixValues[i]),d_matrix_Res->matrixValues[i], h_matrizRes.size.j*sizeof(MatrixType) , cudaMemcpyHostToDevice);
	}
*/

	//printf("My Tamano: %zd %zd \n",h_matriz_Res_v2->size.i,h_matriz_Res_v2->size.j);
	printMatrix(*h_matriz_Res_v2);

	cudaFree(d_matrix_A);
	cudaFree(d_matrix_B);
	cudaFree(d_matrix_Res);
	//Finalizamos.

	liberaMemoriaMatriz(h_matrizA);
	liberaMemoriaMatriz(h_matrizB);
	liberaMemoriaMatriz(h_matrizRes);
  liberaMemoriaMatriz(*h_matriz_Res_v2);

  free (h_matriz_Res_v2);

	//printf("Hola mundo!\n");
	return RETURN_OK;
}
