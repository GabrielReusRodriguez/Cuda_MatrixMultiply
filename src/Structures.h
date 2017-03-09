#ifndef STRUCTURES_H
#define STRUCTURES_H

  struct matrixSize{
    size_t i;
    size_t j;
  };

  typedef struct matrixSize MatrixSize;

  struct matrix{
    float** matrixValues;
  };

  typedef struct matrix Matrix;

#endif
