#ifndef STRUCTURES_H
#define STRUCTURES_H

  typedef float MatrixType;
  #define MATRIX_CELL_INIT_VALUE 0.0f

  struct matrixSize{
    size_t i = 0;
    size_t j = 0;
  };

  typedef struct matrixSize MatrixSize;

  struct matrix{
    MatrixType* matrixValues = NULL;
    MatrixSize size;
  };

  typedef struct matrix Matrix;

  typedef const char* ConstString;

#endif
