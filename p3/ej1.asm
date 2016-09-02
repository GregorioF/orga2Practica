global SumaVectores
global ComparacionGT
global ComparacionEQ
global ShiftWordRight
global MultiplicarVectorPorPotenciaDeDos
global FiltrarMayoresA

%define sizeB_mmx 16
%define short_size 16

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

;=============TENER EN CUENTA QUE MIS TEST EN ASEEMBLER DE ESTA FUNCION SON JUSTAMENTE CON LOS TAMAÑOS ADECUADOS
;=============SIMPLEMENTE SON PARA VER COMO ANDAN ESTAS INSTRUCCIONES

	movq xmm0, [rdi]		;pongo el vectorA en xmm0
	movq xmm1, [rsi]		;pongo el vectorB en xmm0
	pcmpgtb xmm0, xmm1		; ejecuto la comparacion "greater than"
	movq [rdi], xmm0		;sobre escribo el vector a con el resultado y vulvo
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
	
;void ShiftWordRight (uint16_t* vectorA, uint16_t* vectorB, int dimension)
ShiftWordRight:
;rdi = puntero a vectorA
;rsi = dimension del arreglo
	movdqu xmm0, [rdi]			; muevo el vectorA a xmm0, 
	psrlw xmm0, 1				; le digo que corra los bites de cada packete un bite a la derecha
	movdqu [rdi], xmm0			; devuelvo el shifeto
	ret

;void MultiplicarVectorPorPotenciaDeDos(int *vectorA, int potencia, int dimension)

MultiplicarVectorPorPotenciaDeDos:
;rdi = puntero a vectorA
;rsi = potencia de dos a la que elevo
;rdx = cantidad de enteros del vector
	
	movq xmm2, rsi				; guardo en xmm2 la potencia a la que elevo 2
	mov r8, 0				; va a ser mi current
		
	.ciclo:
		cmp rdx, 4				; comparo la cantidad que me qda por shiftear con el tamaño del xmm0
		jl .shiftManual			; si es menor a 4 me salto al modo manual
		
		.shiftEmpaquetado:
			movdqu xmm0, [rdi+r8]	; muevo 4 numero int al xmm0
			pslld xmm0, xmm2		; shifteo
			movdqu [rdi+r8], xmm0	; los reescribo
			sub rdx, 4				; actualizo la cantidad que me falta
			add r8, 16		;actualizo mi current	 4 numeros * 4 bytes cada uyno
			jmp .ciclo				; vuelvo al ciclo
		
	.shiftManual:					; si entre aca es porque la cantidad que me falta es < 4
		cmp rdx, 0					; si termine de recorrer me voy
		je .fin
		
		movd xmm0, [rdi]			; si no termine meuvo un solo numero a xmm0
		pslld xmm0, xmm2			; lo shifteo
		movd [rdi], xmm0
		sub rdx, 1					; actualizo los que me faltan
		add r8, 1
		jmp .shiftManual			; vuelvo a fijarme
	
	.fin:
		ret
		
;extern void FiltrarMayoresA(short *vectorA, short umbral, int dimension);
FiltrarMayoresA:
; rdi = puntero a vectorA de shorts
; si = numero cota
; edx = dimension del arreglo
	mov r8, 0				; va a ser mi current	
	mov rcx, 2				; lo seteo para crea la mascara es el numero de dwors que entra en un xmm
	mov ax, si				; guardo en ax si
	shl esi, short_size		; muevo si a la parte alta de esi
	mov	si, ax				; pongo en la parte baja de esi denuevo si
	
	.CreoMascara:
		cmp rcx, 0			; si termine de hacer la mascara me voy
		je .ciclo
					
		movd xmm1, esi		; meto en los primeros 32 bit de xmm1 si, si
		psllq xmm1, 32		; los corro 32 bits a  la izquierda
		sub rcx, 1			; actualizo rcx
		jmp .CreoMascara	; y vuelvo
	
	
	.ciclo:
		cmp rdx, 8			; me fjio si tengo  suficientes numeros para hacer la mascara simultanea
		jl .filtrarManual
		
		.filtrarEmpaquetado:
			movdqu xmm0, [rdi+r8]	; muevo  8 shorts a xmm0
			pcmpgtw xmm0, xmm1	; hago la mascara inversa, si un numero de xmm0 es mayor a mi xmm1 se pone en ff 
			movdqu [rdi+r8], xmm0	; lo vuevo a escribir en el vector
			sub rdx, 8
			lea r8, [r8+8*16]		;actualizo mi current
			jmp .filtrarEmpaquetado
			
			
		.filtrarManual:
			ret
			
			

;productoInternoFloats(float* a, float* b, short n)
productoInternoFloats:
;rdi puntero a vector A
;rsi puntero a ector B
;dx  = n

	xor xmm0, xmm0
	.ciclo:
		cmp dx, 0 
		je .segundaParte
		movups xmm3, [rdi] 	; levanto algunos
		movups xmm4, [rsi]	; levanto vector b
		mulps xmm3, xmm4
		addps xmm0, xmm3	; sumo las coas a xmm0
		sub dx, 4
		add rdi, 16
		add rsi, 16
		jmp .ciclo
		
	.segundaParte:
		movups xmm1, xmm0	
		psrldq xmm1, 8 ; esta en bytes porque shifteo todo el registro
		addps xmm0, xmm1
		movups xmm1, xmm0
		
		psrldq xmm1, 4
		addss xmm0, xmm1
			
			
		ret	;............... terminar
		
		
		

			
			
			
