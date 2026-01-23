    PROCESSOR 18F47Q10
    #include "cabecera.inc"
    
    PSECT upcino, class=CODE, reloc=2, abs
x_var EQU 000H
y_var EQU 001H
z_var EQU 002H 
    
upcino:
    ORG 000000H
    bra configuro
    
    ORG 000100H
configuro:
    ;configuracion del modulo de oscilador
    movlb 0EH	;Al Bank14, para el Q43 es Bank0 (0H)
    movlw 60H
    movwf OSCCON1, 1	;NOSC=HFINTOSC NDIV 1:1
    movlw 02H
    movwf OSCFRQ, 1	;HFINTOSC a 4MHz
    movlw 40H
    movwf OSCEN, 1	;HFINTOSC enabled
    ;configuramos las E/S
    movlb 0FH	;Al Bank15, para que Q43 es Bank4 (4H)
    bcf TRISC, 0, 1	;RC0 como salida
    bcf ANSELC, 0, 1	;RC0 como digital
    
inicio:
    bsf LATC, 0, 1	;RC0 = 1 prendemos el LED
    call retardo	;subrutina de retardo
    bcf LATC, 0, 1	;RC0 = 0 apagamos el LED
    call retardo	;subrutina de retardo
    bra inicio		;salta a inicio
    
retardo:
    movlb 0H		;Al Bank0
    movlw 100
    movwf x_var, 1	;x_var = 100
salto3:
    movlw 10
    movwf y_var, 1	;y_var = 100
salto2:
    movlw 30
    movwf z_var , 1	;z_var = 25
salto1:
    movlw 0
    cpfseq z_var, 1	;Pregunto si z_var es cero
    bra z_var_nocero	;falto
    movlw 0		;verdad
    cpfseq y_var, 1	;Pregunto si y_var es cero
    bra y_var_nocero	;falso
    movlw 0		;verdad
    cpfseq x_var, 1	;Pregunto si x_var es cero
    bra x_var_nocero	;falso
    movlb 0FH		;Al Bank15
    return		;verdad
z_var_nocero:
    decf z_var, 1, 1	;Decremento z_var
    nop
    bra salto1		;Salto a salto1
y_var_nocero:
    decf y_var, 1, 1	;Decremento y_var
    bra salto2		;Salto a salto2
x_var_nocero:
    decf x_var, 1, 1	;Decremento x_var
    bra salto3
    
    end upcino

