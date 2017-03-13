#include <stdio.h>
#include "Structures.h"
#include "Constantes.h"
#include "CudaFunctions.h"

/*
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

  i=0;
  j=0;

  value = -4.0f;

  int index = i*matrixRes->size.j+j;
  matrixRes->matrixValues[index] = value;

  *test = value;

}
*/

/*
Matrix* moveMatrix_2_device(Matrix *matrix)
{
  Matrix* localMatrix;
  Matrix* p_return = NULL;
  MatrixType* data;


  localMatrix = (Matrix*)malloc(sizeof(Matrix));
  if (localMatrix == NULL){
    return p_return;
  }


  cudaMalloc((void **)data,matrix->size.i*matrix->size.j*sizeof(MatrixType));
  cudaMemcpy((void *)data,(void *)matrix->matrixValues,matrix->size.i*matrix->size.j*sizeof(MatrixType),cudaMemcpyHostToDevice);

  localMatrix->matrixValues = data;
  localMatrix->size.i = matrix->size.i;
  localMatrix->size.j = matrix->size.j;

  cudaMalloc((void **)&p_return,sizeof(Matrix));
  cudaMemcpy(p_return,localMatrix,sizeof(Matrix),cudaMemcpyHostToDevice);

  return p_return;

}
*/
