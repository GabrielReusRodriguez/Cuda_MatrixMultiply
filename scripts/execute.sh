#!/usr/bin/env bash

ROOT_PATH=/home/gabriel/Proyectos/Cuda/Cuda_MatrixMultiply
DATA_PATH=$ROOT_PATH/data
BIN_PATH=$ROOT_PATH/bin

$BIN_PATH/MatrixMultiply.out $DATA_PATH/genMatA.txt $DATA_PATH/genMatB.txt
