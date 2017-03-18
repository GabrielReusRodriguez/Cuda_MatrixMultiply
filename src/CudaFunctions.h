#ifndef CUDA_FUNCTIONS
#define CUDA_FUNCTIONS

#include "Structures.h"

void multiplica(Matrix* matrixA, Matrix* matrixB, Matrix* matrixRes,MyDim3 p_dimBlock, MyDim3 p_dimGrim);
Matrix* moveMatrix_2_device(Matrix *h_matrix);
Matrix* moveMatrix_2_host(Matrix *d_matrix, int size_i, int size_j);
cudaDeviceProp  getCudaProperties();
__device__
void calculaCoordenadasMatriz(MyDim3 blockGrid, MyDim3 threadId, int &x, int &y, int &z);
__host__ __device__
MyDim3 newMyDim3(int x, int y, int z);


#endif
