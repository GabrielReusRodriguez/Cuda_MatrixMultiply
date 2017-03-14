#include <stdio.h>
#include "Constantes.h"
#include "MatrixLib.h"

  int calculaTamanosMult(MatrixSize size_matrix_A, MatrixSize size_matrix_B,MatrixSize& size_matrix_Res)
  {
      //comprobamos si el valor es correcto.
      if (size_matrix_A.i <= 0 || size_matrix_A.j <= 0)
      {
          return 1;
      }

      if (size_matrix_B.i <= 0 || size_matrix_B.j <= 0)
      {
          return 2;
      }

      if (size_matrix_A.j != size_matrix_B.i )
      {
        return 3;
      }

      size_matrix_Res.i = size_matrix_A.j;
      size_matrix_Res.j = size_matrix_B.i;

      return RETURN_OK;
  }

  void printMatrix(Matrix matriz)
  {

    if (matriz.size.i > 0 && matriz.size.j > 0)
    {
      printf("Matrix %zdx%zd:\n",matriz.size.i,matriz.size.j);
      for(int j = 0; j < matriz.size.j; j++)
      {
        for ( int i=0;i< matriz.size.i - 1; i++)
        {
          int index = j*matriz.size.i+i;
          printf("%f\t",matriz.matrixValues[index]);
        }
          int index = j*matriz.size.i+ matriz.size.i-1;
          printf("%f\n",matriz.matrixValues[index]);
      }
  }
  else
  {
    printf("Tamanos de matriz = 0 o negativos");
  }
}
