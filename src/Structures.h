#ifndef STRUCTURES_H
#define STRUCTURES_H

  typedef float MatrixType;
  #define MATRIX_CELL_INIT_VALUE 0.0f
  #define MATRIX_TYPE_FORMAT %f

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

  struct myDim3{
    int x = 0;
    int y = 0;
    int z = 0;
  };

  typedef struct myDim3 MyDim3;


#endif
