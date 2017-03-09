#include <stdio.h>
#include "MatrixLib.h"


  void calculaTamanos(int size_i_A, int size_j_A, int size_i_B,int size_j_B)
  {
      //comprobamos si el valor es correcto.
  }
  void printMatrix(float** Matrix,int size_i,int size_j)
  {
      if (size_i > 0 && size_j > 0)
      {
        printf("Matrix %dx%d:\n",size_i,size_j);
        for(int i = 0; i < size_i; i++)
        {
          for ( int j=0;j< size_j - 1; j++)
          {
            printf("%f\t",Matrix[i][j]);
          }
            printf("%f\n",Matrix[i][size_j-1]);
        }
    }
    else
    {
      printf("Tamanos de matriz = 0 o negativos");
    }
  }
