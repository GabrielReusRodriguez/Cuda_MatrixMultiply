#include <stdio.h>
#include <stdlib.h>
#include "MemoryLib.h"
#include "Constantes.h"
#include <cuda_runtime.h>

Matrix reservaMemoriaMatriz(MatrixSize size)
{
    Matrix matriz;
    matriz.size = size;
    if (matriz.size.i > 0 && matriz.size.j > 0)
    {
      matriz.matrixValues = (MatrixType*)malloc(matriz.size.i*matriz.size.j*sizeof(MatrixType));
      if (matriz.matrixValues == NULL)
      {
        return matriz;
      }

      for(int i=0;i<matriz.size.i;i++)
      {
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

}
