#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define W 8

extern void SumaVectores(char * vectorA, char* vectorB, char* vectorRes, int n);
extern void ComparacionGT(char *vectorA, char *vectorB, int dimension );
extern void ComparacionEQ(char *vectorA, char *vectorB, int dimension );

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
	//SumaVectores(a,b,res,W);
	imprimir(a,W);
	//ComparacionGT(a,b,W); 					//ANDA
	//ComparacionEQ(a, b,W);  					//ANDA

	imprimir(a, W);

	return 0;
}