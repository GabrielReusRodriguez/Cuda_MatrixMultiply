#include <stdio.h>
#include <stdlib.h>
#include "MemoryLib.h"
#include "Constantes.h"
#include <cuda_runtime.h>



//#define _CUDA(x) checkCudaErrors(x)
/*
int liberaMemoriaMatriz(Matrix matriz,MatrixSize size);
Matrix reservaMemoriaMatriz(MatrixSize size);
*/

//http://codeofhonour.blogspot.com.es/2014/10/cuda-and-pointers-to-pointers.html
//float** reservaMemoriaMatriz(int size_i, int size_j)
//cudaHostAlloc((void**)&hst_ptr, 2*sizeof(float*), cudaHostAllocMapped) );
/*
Matrix reservaMemoriaMatriz(MatrixSize size)
{
    Matrix matriz;
    matriz.size = size;
    if (matriz.size.i > 0 && matriz.size.j > 0)
    {
      //matriz.matrixValues = (MatrixType**)malloc(matriz.size.i*sizeof(MatrixType*));
      cudaHostAlloc((void**)&(matriz.matrixValues), matriz.size.i*sizeof(MatrixType*), cudaHostAllocMapped);
      if (matriz.matrixValues == NULL)
      {
        return matriz;
      }
      for(int i=0;i<matriz.size.i;i++)
      {
          //matriz.matrixValues[i] = (MatrixType*)malloc(matriz.size.j*sizeof(MatrixType));
          cudaHostAlloc((void**)&(matriz.matrixValues[i]), matriz.size.j*sizeof(MatrixType), cudaHostAllocMapped);
          if (matriz.matrixValues[i] == NULL)
          {
            return matriz;
          }
          for(int j=0;j<matriz.size.j;j++)
          {
            matriz.matrixValues[i][j] = MATRIX_CELL_INIT_VALUE;
          }
      }
      return matriz;
    }else{
      return matriz;
    }

}

*/

Matrix reservaMemoriaMatriz(MatrixSize size)
{
    Matrix matriz;
    matriz.size = size;
    if (matriz.size.i > 0 && matriz.size.j > 0)
    {
      //matriz.matrixValues = (MatrixType**)malloc(matriz.size.i*sizeof(MatrixType*));
      //cudaHostAlloc((void**)&(matriz.matrixValues), matriz.size.i*sizeof(MatrixType*), cudaHostAllocMapped);
      matriz.matrixValues = (MatrixType*)malloc(matriz.size.i*matriz.size.j*sizeof(MatrixType));
      if (matriz.matrixValues == NULL)
      {
        return matriz;
      }

      for(int i=0;i<matriz.size.i;i++)
      {
          //matriz.matrixValues[i] = (MatrixType*)malloc(matriz.size.j*sizeof(MatrixType));
          //cudaHostAlloc((void**)&(matriz.matrixValues[i]), matriz.size.j*sizeof(MatrixType), cudaHostAllocMapped);
          for(int j=0;j<matriz.size.j;j++)
          {
            int index = i*matriz.size.j + j;
            matriz.matrixValues[index] = MATRIX_CELL_INIT_VALUE;
          }
      }
      return matriz;
    }else{
      return matriz;
    }

}

int liberaMemoriaMatriz(Matrix matriz)
{

  if (matriz.matrixValues == NULL)
  {
    return 1;
  }
  free(matriz.matrixValues);

  /*
  if (matriz.matrixValues == NULL)
  {
    return 1;
  }

  for(int i=0;i<matriz.size.i;i++)
  {
    //free (matriz.matrixValues[i]);
    cudaFree(matriz.matrixValues[i]);
  }
  //free (matriz.matrixValues);
  cudaFree(matriz.matrixValues);
  return RETURN_OK;
  */
}
