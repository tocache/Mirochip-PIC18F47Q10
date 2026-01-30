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
    
    ORG 000200H	;valores desde el 200H al 209H
tabla_disp7s:	DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 67H
    
    ORG 000100H
configuro:
    ;conf del modulo de oscilador
    movlb 0EH		;Bank14
    movlw 60H
    movwf OSCCON1, 1
    movlw 02H
    movwf OSCFRQ, 1
    movlw 40H
    movwf OSCEN, 1
    ;conf de las E/S
    movlb 0FH		;Bank15
    movlw 0F0H
    movwf TRISB, 1	;RB0 al RB3 como salidas
    movwf ANSELB, 1	;RB0 al RB3 como digitales
    movlw 80H
    movwf TRISC, 1	;RC6 al RC0 como salidas
    movwf ANSELC, 1	;RC6 al RC0 como digitales
    ;conf del puntero de tabla TBLPTR
    movlw 00H
    movwf TBLPTRU, 1
    movlw 02H
    movwf TBLPTRH, 1
    movlw 00H
    movwf TBLPTRL, 1	;TBLPTR esta apuntando a 000200H de la mem prog
    
    ;condiciones iniciales de operacion
    movlb 0H		;Bank0
    clrf CUENTA, 1	;la cuenta inicia en cero
    
inicio:
    call visualizar_7seg
    call retardo
    movlb 0H		;Bank0
    movlw 9
    cpfseq CUENTA, 1	;Pregunto su cuenta=9
    bra cuenta_noes_9
    bra cuenta_sies_9
cuenta_noes_9:
    incf CUENTA, 1, 1	;Incremento cuenta
    bra inicio		;Regresa a inicio
cuenta_sies_9:
    clrf CUENTA, 1	;limpiamos cuenta
    bra inicio

;subrutina de visualiazacion
visualizar_7seg:
    movlb 0H		;Bank0
    movf CUENTA, 0, 1	;Obtengo el valor de cuenta
    movlb 0FH
    movwf LATB, 1	;Escribo dato de Wreg a RB
    movwf TBLPTRL, 1	;Actualizo el valor de TBLPTR con CUENTA
    TBLRD*		;Acción de lectura del dato que apunta TBLPTR
    movff TABLAT, LATC	;envio de lo leido por TBLPTR hacia RD
    return
    
;subrutina de retardo    
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
    


