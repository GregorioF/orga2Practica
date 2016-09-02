#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define W 8
#define X 20
#define Y 20

extern void SumaVectores(char * vectorA, char* vectorB, char* vectorRes, int n);
extern void ComparacionGT(char *vectorA, char *vectorB, int dimension );
extern void ComparacionEQ(char *vectorA, char *vectorB, int dimension );
extern void ShiftWordRight (uint16_t* vectorA, int dimension);
extern void MultiplicarVectorPorPotenciaDeDos(int *vectorA, int potencia, int dimension);
extern void FiltrarMayoresA(short *vectorA, short umbral, int dimension);

void SumaVectoresC(uint8_t* a , uint8_t* b , uint8_t* res , int n){
	int i =0;
	while(i< n){
		res[i]= a[i]+b[i];
		i+=1;
	}
}

void imprimir(uint8_t* a, int n){
	int i =0;
	while( i < n){
		printf("%d, ", a[i] );
		i+=1;
	}
	printf("\n");
}

void imprimir16(uint16_t* a, int n){
	int i =0;
	while( i < n){
		printf("%d, ", a[i] );
		i+=1;
	}
	printf("\n");
}

void imprimir32(int* a, int n){
	int i =0;
	while( i < n){
		printf("%d, ", a[i] );
		i+=1;
	}
	printf("\n");
}


int main(){
	uint8_t a [W];
	uint8_t b [W];
	uint8_t res [W];
	int i =0;
	while(i < W){
		a[i]=i;
		b[i]=i;
		i+=1;
	}
	uint16_t c[X];
	i = 0;
	while(i<X){
		c[i]= 3;
		i+=1;
	}
	int d [Y];
	i =0;
	while(i < Y){
		d[i] = i;
		i+=1;
	}
	//SumaVectores(a,b,res,W);					//ANDA
	//imprimir(a,W);
	//ComparacionGT(a,b,W); 					//ANDA
	//ComparacionEQ(a, b,W);  					//ANDA
	//imprimir(a, W);

	//imprimir16(c,X);
	//ShiftWordRight(c,X);						//ANDA	
	//imprimir16(c,X);

	//imprimir32(d,Y);
	//MultiplicarVectorPorPotenciaDeDos(d,2,Y);	//ANDA
	//imprimir32(d,Y);

	imprimir16(c,X);
	FiltrarMayoresA(c,3,X);
	imprimir16(c,X);
	
	return 0;
}
