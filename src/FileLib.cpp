#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "MemoryLib.h"
#include "FileLib.h"
#include "MatrixLib.h"
#include "Constantes.h"


float**  leeFichero(const char* fileName,int& size_i,int& size_j){

  float** matriz = NULL;
  FILE *fp        =NULL;

  size_t len      = 0;
  ssize_t  read;
  char *line      =NULL;

  fp = fopen(fileName,"r");
  if (fp == NULL)
  {
    return NULL;
  }

  read = getline(&line,&len,fp);
  if (read > 0)
  {
      //Primero leo los tamaños de la matriz
      read = sscanf(line,"%d\t%d\n",&size_i,&size_j);
      if (read > 0)
      {
        matriz=reservaMemoriaMatriz(size_i,size_j);
      }
      //Si la matriz NO es null, le asigno los valores.
      if (matriz != NULL)
      {
          char* lineaProc = NULL;
          for(int i=0;i< size_i;i++)
          {
            read = getline(&line,&len,fp);
            if (read > 0)
            {
              lineaProc = line;
              float value = 0.0f;
              lineaProc = strtok(line,"\t\n ");
              sscanf(lineaProc,"%f",&value);
              matriz[i][0] = value;
              printf("Linea: %s \n",lineaProc);
              for(int j = 0;j<size_j-1;j++)
              {

                lineaProc = strtok(NULL,"\t\n ");
                if(lineaProc != NULL)
                {
                  sscanf(lineaProc,"%f",&value);
                  matriz[i][j+1] = value;
                  printf("Linea: %s \n",lineaProc);
                }
              }

            }
            else
            {
              //Error en la lectura, cierro el fichero y devuelvo null
              fclose(fp);
              return NULL;
            }
          }
          printMatrix(matriz,size_i,size_j);

      }
  }
  else
  {
      return NULL;
  }

  fclose(fp);
  return matriz;
}

int escribeFichero(const char* fileName,const float** matriz){

  return RETURN_OK;

}

//Genera el string con el formato que ha de enviarse al sscanf para que lea cada fila de la matriz
char* creaFormatoLinea(int tamano_fila){

  char * formato = NULL;


  //Cada número se define como %f\t o %f\n por lo que son 3 carácteres
  int tamanoString = 3*tamano_fila;
  formato = (char*)malloc(tamanoString*sizeof(char));
  if (formato == NULL)
  {
      return NULL;
  }
  for(int i = 0;i< tamano_fila-1;i++)
  {
    formato = strcat(formato,"%f\t");
  }
  formato = strcat(formato,"%f\n");
  return formato;
}
