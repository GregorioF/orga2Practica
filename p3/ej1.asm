global SumaVectores
global ComparacionGT
global ComparacionEQ

%define sizeB_mmx, 16

section .text


;void SumarVectores(char *vectorA, char *vectorB, char *vectorResultado, int dimension)
SumaVectores:
;rdi = puntero a vectorA
;rsi = puntero a vectorB
;rdx = puntero a vectorResultado
;rcx = dimension

;supongamos que ninguna puntero es nullo...
	mov r8, 0					; lo voy a usar como mi current en vectorResultado
	.ciclo:
		cmp rcx, 8		;me fijo que me falten mas de 16 o menos de 16
		jl .SumaManual
	
		.SumaEmpaquetada:
			movq xmm0, [rdi+r8]  	;pongo los primeros 16 caracteres de A en xmm0
			movq xmm1, [rsi+r8]	 	;pongo los primeros 16 caracteres de B en xmm1
			paddb xmm0, xmm1	;hago la suma empaquetada de a bytes sin saturacion
			movq [rdx+r8], xmm0	;lo paso a mi vector resultado
			add r8, 8			;actualizo mi current 
			sub rcx, 8			;actualizo la cantidad que me falta
			jmp .ciclo
		
	.SumaManual:
		cmp rcx, 0			; me fijo si ya termina de pasar todas las sumas
		je .fin
		mov r9b, [rdi+r8]	; meto en r9 mi valor current de A
		mov r10b, [rsi+r8]	; meto en r10 mi valor curren de B
		add r9b, r10b		; en r9 tengo la suma que quier
		mov [rdx+r8], r9b	; lo meto en mi valor current del vector resultado
		inc	r8				; incremento mi current
		sub rcx, 1			; actualizo los que me faltan
		jmp .SumaManual
	
	.fin:
		ret
			
			
;void ComparacionGT(char *vectorA, char *vectorB, int dimension )
ComparacionGT:
;rdi = puntero a vectorA
;rsi = puntero a vectorB
;rdx = cantidad de elementos de los vectores
	movq xmm0, [rdi]
	movq xmm1, [rsi]
	pcmpgtb xmm0, xmm1
	movq [rdi], xmm0
	ret
	
;void ComparacionGT(char *vectorA, char *vectorB, int dimension )
ComparacionEQ:
;rdi = puntero a vectorA
;rsi = puntero a vectorB
;rdx = cantidad de elementos de los vectores
	movq xmm0, [rdi]
	movq xmm1, [rsi]
	pcmpeqb xmm0, xmm1
	movq [rdi], xmm0
	ret
	

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
