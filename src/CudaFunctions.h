#ifndef CUDA_FUNCTIONS
#define CUDA_FUNCTIONS

#include "Structures.h"
/*
__global__
void multiplica(float** matrixA, float** matrixB, float** matrixRes );
*/
/*
__global__
void multiplica(Matrix* matrixA, Matrix* matrixB, Matrix* matrixRes,float* test );
*/
Matrix* moveMatrix_2_device(Matrix *matrix, cudaMemcpyKind sentido);


#endif
