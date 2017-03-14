#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "MemoryLib.h"
#include "FileLib.h"
#include "MatrixLib.h"
#include "Constantes.h"



/*
int escribeFichero(ConstString fileName, const Matrix matriz);
char* creaFormatoLinea(int tamano_fila);
*/
//float**  leeFichero(const char* fileName,int& size_i,int& size_j){
Matrix  leeFichero(ConstString fileName){

  Matrix matriz;
  FILE *fp        =NULL;

  size_t len      = 0;
  ssize_t  read;
  char *line      =NULL;

  fp = fopen(fileName,"r");
  if (fp == NULL)
  {
    return matriz;
  }

  read = getline(&line,&len,fp);
  if (read > 0)
  {
      //Primero leo los tamaños de la matriz
      read = sscanf(line,"%zd\t%zd\n",&matriz.size.i,&matriz.size.j);
      if (read > 0)
      {
        //printf("Tamano: %zd %zd\n",matriz.size.i,matriz.size.j);
        matriz=reservaMemoriaMatriz(matriz.size);
      }
      //Si la matriz NO es null, le asigno los valores.
      if (matriz.matrixValues != NULL)
      {
          char* lineaProc = NULL;
          for(int j=0;j< matriz.size.j;j++)
          {
            read = getline(&line,&len,fp);
            //printf ("Linea: %s\n",line);
            if (read > 0)
            {
              lineaProc = line;
              float value = 0.0f;
              lineaProc = strtok(line,"\t\n ");
              sscanf(lineaProc,"%f",&value);
              int index = j*matriz.size.i;
              matriz.matrixValues[index] = value;
              //printf("Linea: %s index: %d \n",lineaProc,index);
              for(int i = 0;i<matriz.size.i-1;i++)
              {

                lineaProc = strtok(NULL,"\t\n ");
                if(lineaProc != NULL)
                {
                  sscanf(lineaProc,"%f",&value);
                  int index_2 = j*matriz.size.i+i+1;
                  matriz.matrixValues[index_2] = value;
                //  printf("Linea: %s index 2:%d \n",lineaProc,index_2);
                }
              }

            }
            else
            {
              //Error en la lectura, cierro el fichero y devuelvo null
              //TODO en caso de error, seria conveniente liberar memoria y devolver NULL para no continuar procesando una matriz erronea.
              fclose(fp);
              return matriz;
            }
          }


          printMatrix(matriz);

      }
  }
  else
  {
      return matriz;
  }

  fclose(fp);
  return matriz;
}

int escribeFichero(ConstString fileName, const Matrix matriz){
  FILE *fp=NULL;
  fp = fopen(fileName,"w");
  if (fp == NULL)
  {
    return 1;
  }
  fprintf(fp,"%zd\t%zd\n",matriz.size.i,matriz.size.j);
  for(int j=0;j<matriz.size.j;j++)
  {
    for(int i=0;i< matriz.size.i-1;i++)
    {
        int index = j*matriz.size.i+i;
        fprintf(fp,"%f\t",matriz.matrixValues[index]);
    }
    int index = j*matriz.size.i+matriz.size.i-1;
    fprintf(fp,"%f\n",matriz.matrixValues[index]);
  }

  fclose(fp);
  return RETURN_OK;

}
