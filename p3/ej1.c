#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

extern void SumaVectores(char * vectorA, char* vectorB, char* vectorRes, int n);


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
	uint8_t a [30];
	uint8_t b [30];
	uint8_t res [30];
	int i =0;
	while(i < 30){
		a[i]=i;
		b[i]=i;
		i+=1;
	}
	SumaVectores(a,b,res,30);

	imprimir(res, 30);

	return 0;
}