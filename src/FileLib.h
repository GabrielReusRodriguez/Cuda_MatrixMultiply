#ifndef FILE_LIB
#define FILE_LIB

	float**  leeFichero(const char* fileName,int& size_i,int& size_j);
	int escribeFichero(const char* fileName, const float** matriz);
	char* creaFormatoLinea(int tamano_fila);


#endif
