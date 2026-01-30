    PROCESSOR 18F47Q10
    #include "cabecera.inc"
    
CUENTA EQU 000H
x_var EQU 001H
y_var EQU 002H
z_var EQU 003H
VELOCIDAD EQU 004H
    
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
    bsf TRISB, 4, 1	;RB4 es entrada
    bcf ANSELB, 4, 1	;RB4 es digital
    bsf WPUB, 4, 1	;RB4 con pullup activada
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
    clrf CUENTA, 1	;la cuenta inicial en cero
    clrf VELOCIDAD, 1	;velocidad = 0 al inicio
    
inicio:
    call botonRB4
    call visualizar_7seg
    call pregunta_dly
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

;subrutina del boton en RB4
botonRB4:
    movlb 0FH		;Bank15
    btfsc PORTB, 4, 1	;pregunto si RB4=0 (si presionaste boton)
    return		;falso, no presionaste boton
    movlb 0H		;Bank0
    movlw 0
    cpfseq VELOCIDAD, 1	;Pregunto si VELOCIDAD=0
    bra VEL_ES_1	;falso, salta a VEL_ES_1
    bra VEL_ES_0	;verdad, salta a VEL_ES_0
VEL_ES_1:
    movlw 0
    movwf VELOCIDAD, 1	;pasamos a velocidad = 0
    bra siguiente_punto
VEL_ES_0:
    movlw 1
    movwf VELOCIDAD, 1	;pasamos a velocidad = 1
siguiente_punto:
    movlb 0FH		    ;Bank15
    btfss PORTB, 4, 1	    ;pregunta si sotaste boton
    bra siguiente_punto	    ;falso salta a volver a preguntar
    return		    ;verdad, termina la subrutina
    
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
    
;subrutina de pregunta de delay
pregunta_dly:
    movlb 0H	    ;Bank0
    movlw 0
    cpfseq VELOCIDAD, 1	;Pregunto si velocidad = 0
    bra vel_noes_cero	;falso, salta a vel_noes_cero
    call retardo_lento
    return
vel_noes_cero:   
    call retardo_rapido
    return
    
;subrutina de retardo_lento
retardo_lento:
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

;subrutina de retardo_rapido
retardo_rapido:
    movlb 0H		;Al Bank0
    movlw 100
    movwf x_var, 1	;x_var = 100
salto3r:
    movlw 10
    movwf y_var, 1	;y_var = 100
salto2r:
    movlw 10
    movwf z_var , 1	;z_var = 25
salto1r:
    movlw 0
    cpfseq z_var, 1	;Pregunto si z_var es cero
    bra z_var_noceror	;falto
    movlw 0		;verdad
    cpfseq y_var, 1	;Pregunto si y_var es cero
    bra y_var_noceror	;falso
    movlw 0		;verdad
    cpfseq x_var, 1	;Pregunto si x_var es cero
    bra x_var_noceror	;falso
    movlb 0FH		;Al Bank15
    return		;verdad
z_var_noceror:
    decf z_var, 1, 1	;Decremento z_var
    nop
    bra salto1r		;Salto a salto1
y_var_noceror:
    decf y_var, 1, 1	;Decremento y_var
    bra salto2r		;Salto a salto2
x_var_noceror:
    decf x_var, 1, 1	;Decremento x_var
    bra salto3r
    
    end upcino
    





