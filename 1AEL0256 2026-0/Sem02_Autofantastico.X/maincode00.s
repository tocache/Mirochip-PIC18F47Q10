    PROCESSOR 18F47Q10
    #include "cabecera.inc"

CUENTA EQU 000H  
x_var EQU 001H
y_var EQU 002H
z_var EQU 003H  
    
    PSECT upcino, class=CODE, reloc=2, abs
upcino:
    ORG 000000H
    bra configuro
    
    ORG 000500H
tabla_auto1:  DB 01H, 02H, 04H, 08H, 10H, 20H, 40H
tabla_auto2:  DB 80H, 40H, 20H, 10H, 08H, 04H, 02H
  
    ORG 000100H
configuro:
    movlb 0EH	    ;Bank 14
    ;conf del modulo de oscilador
    movlw 60H
    movwf OSCCON1, 1
    movlw 02H
    movwf OSCFRQ, 1
    movlw 40H
    movwf OSCEN, 1
    ;cond de las E/S
    movlb 0FH	    ;Bank 15
    clrf TRISD, 1   ;Todo RD como salida
    clrf ANSELD, 1  ;Todo RD como digital
    ;conf del puntero de tabla
    movwf TBLPTRU, 1
    movlw 05H
    movwf TBLPTRH, 1
    movlw 00H
    movwf TBLPTRL, 1	;TBLPTR esta apuntando a 500H
    ;condiciones iniciales
    movlb 0H
    clrf CUENTA, 1	;valor inicial de CUENTA=0
    
inicio:
    movlb 0H
    movf CUENTA, 0, 1	;sacamos valor de CUENTA hacia Wreg
    movlb 0FH
    movwf TBLPTRL, 1
    TBLRD*		;accion de lectura
    movff TABLAT, LATD	;muevo TABLAT hacia RD
    call retardo
    movlb 0H
    movlw 13
    cpfseq CUENTA, 1	;pregunta si CUENTA=13
    bra noestrece
    bra siestrece
noestrece:
    incf CUENTA, 1, 1	;incrementa CUENTA
    bra inicio
siestrece:
    clrf CUENTA, 1	;limpia CUENTA
    bra inicio
    
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
    


