#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random

#Definicion de las matrices.

def generaMatriz(tamanoX,tamanoY,fileName,maximo = 1.0):
    print "Funcion\n"

    f = open(fileName,'w')
    f.write(str(tamanoX))
    f.write('\t')
    f.write(str(tamanoY))
    f.write('\n')
    for j in range( 0, tamanoY ):
        for i in range ( 0,tamanoX-1 ):
            value = random.random()*maximo
            f.write(str(value))
            f.write('\t')
        value = random.random()*maximo
        f.write(str(value))
        f.write('\n')
    f.close()

generaMatriz(33,33,"./data/genMatA.txt")
generaMatriz(33,33,"./data/genMatB.txt")

print "Fin del programa\n"
