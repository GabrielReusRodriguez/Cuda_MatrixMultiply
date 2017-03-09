#include <stdio.h>
#include <stdlib.h>
#include "MemoryLib.h"
#include "Constantes.h"


float** reservaMemoriaMatriz(int size_i, int size_j)
{
    float** matriz=NULL;
    if (size_i > 0 && size_j > 0)
    {
      matriz = (float**)malloc(size_i*sizeof(float*));
      if (matriz == NULL)
      {
        return NULL;
      }
      for(int i=0;i<size_i;i++)
      {
          matriz[i] = (float*)malloc(size_j*sizeof(float));
          if (matriz[i] == NULL)
          {
            return NULL;
          }
          for(int j=0;j<size_j;j++)
          {
            matriz[i][j] = 0.0f;
          }
      }
      return matriz;
    }else{
      return NULL;
    }

}

int liberaMemoriaMatriz(float** matriz,int size_i)
{
  if (matriz == NULL)
  {
    return 1;
  }

  for(int i=0;i<size_i;i++)
  {
    free (matriz[i]);
  }
  free (matriz);
  return RETURN_OK;
}
