#include <stdio.h>
#include "Structures.h"
#include "Constantes.h"
#include "CudaFunctions.h"



MyDim3 newMyDim3(int x, int y, int z)
{
  MyDim3 dim;
    dim.x = x;
    dim.y = y;
    dim.z = z;
  return dim;

}

__global__
void cuda_multiplica(Matrix* matrixA, Matrix* matrixB, Matrix* matrixRes)
{
  int i;
  int j;

  MatrixType value;

  //Determino la posición de la matriz según bloque y thread
  i =  threadIdx.x;
  j =  threadIdx.y;

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
  }

  matrixRes->matrixValues[index] = value;

}


void multiplica(Matrix* d_matrix_A, Matrix* d_matrix_B, Matrix* d_matrix_Res,MyDim3 p_dimBlock, MyDim3 p_dimGrid)
{

  int x,y,z;

  x =  p_dimBlock.x;
  y =  p_dimBlock.y;

  if(p_dimBlock.z == 0){
      z = 1;
  }else{
      z =  p_dimBlock.z;
  }

  dim3 dimBlock(x,y,z);

  x =  p_dimGrid.x;
  y =  p_dimGrid.y;

  if(p_dimGrid.z == 0){
      z = 1;
  }else{
      z =  p_dimGrid.z;
  }

  dim3 dimGrid(x,y,z);

  cuda_multiplica<<<dimGrid, dimBlock>>>(d_matrix_A, d_matrix_B, d_matrix_Res);

}

Matrix* moveMatrix_2_device(Matrix *h_matrix)
{
  Matrix* localMatrix;
  Matrix* p_return = NULL;
  MatrixType* d_data;

  localMatrix = (Matrix*)malloc(sizeof(Matrix));
  if (localMatrix == NULL){
    return NULL;
  }

  const size_t data_size = sizeof(MatrixType) * size_t(h_matrix->size.i*h_matrix->size.j);

  cudaMalloc((void **)&d_data,data_size);
  cudaMemcpy((void *)d_data,(void *)h_matrix->matrixValues,data_size,cudaMemcpyHostToDevice);

  localMatrix->matrixValues = d_data;
  localMatrix->size.i = h_matrix->size.i;
  localMatrix->size.j = h_matrix->size.j;

  cudaMalloc((void **)&p_return,sizeof(Matrix));
  cudaMemcpy(p_return,localMatrix,sizeof(Matrix),cudaMemcpyHostToDevice);

  //Liberamos la memoria de la estructura Matrix.
  free(localMatrix);

  return p_return;

}


Matrix* moveMatrix_2_host(Matrix *d_matrix, int size_i, int size_j)
{
  Matrix* localMatrix;

  localMatrix = (Matrix*)malloc(sizeof(Matrix));
  if (localMatrix == NULL){
    return NULL;
  }

  const size_t data_size = sizeof(MatrixType) * size_t(size_i*size_j);

  localMatrix->matrixValues = (MatrixType*)malloc(data_size);

  MatrixType* d_data;
  MatrixType* h_data;

  cudaMemcpy((void *)localMatrix,(void *)d_matrix,sizeof(Matrix),cudaMemcpyDeviceToHost);

  d_data = localMatrix->matrixValues;
  h_data = (MatrixType *)malloc(data_size);
  cudaMemcpy((void *)h_data,(void *)d_data,data_size,cudaMemcpyDeviceToHost);
  localMatrix->matrixValues = h_data;

  return localMatrix;

}
