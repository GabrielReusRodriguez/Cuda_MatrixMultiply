#ifndef CUDA_FUNCTIONS
#define CUDA_FUNCTIONS

#include "Structures.h"

void multiplica(Matrix* matrixA, Matrix* matrixB, Matrix* matrixRes,MyDim3 p_dimBlock, MyDim3 p_dimGrim);
Matrix* moveMatrix_2_device(Matrix *h_matrix);
Matrix* moveMatrix_2_host(Matrix *d_matrix, int size_i, int size_j);

MyDim3 newMyDim3(int x, int y, int z);


#endif
