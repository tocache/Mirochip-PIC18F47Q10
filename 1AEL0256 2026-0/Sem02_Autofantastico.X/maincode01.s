    PROCESSOR 18F47Q10
    #include "cabecera.inc"

CUENTA EQU 000H  
x_var EQU 001H
y_var EQU 002H
z_var EQU 003H
MODO EQU 004H
    
    PSECT upcino, class=CODE, reloc=2, abs
upcino:
    ORG 000000H
    bra configuro
    
    ORG 000500H
tabla_auto1:  DB 01H, 02H, 04H, 08H, 10H, 20H, 40H
tabla_auto2:  DB 80H, 40H, 20H, 10H, 08H, 04H, 02H
  
    ORG 000600H
tabla_auto3: DB 03H, 06H, 0CH, 18H, 30H, 60H, 0C0H
tabla_auto4: DB 60H, 30H, 18H, 0CH, 06H
 
    ORG 000700H
tabla_auto5: DB 07H, 0EH, 1CH, 38H, 70H, 0E0H
table_auto6: DB 70H, 38H, 1CH, 0EH
 
    ORG 000800H
tabla_auto7: DB 81H, 42H, 24H, 18H, 24H, 42H
  
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
    bsf TRISB, 0, 1 ;RB0 como entrada
    bcf ANSELB, 0, 1	;RB0 como digital
    bsf WPUB, 0, 1	;RB0 cobn pullup activado
    ;conf del puntero de tabla
    movwf TBLPTRU, 1
    movlw 05H
    movwf TBLPTRH, 1
    movlw 00H
    movwf TBLPTRL, 1	;TBLPTR esta apuntando a 500H
    ;condiciones iniciales
    movlb 0H
    clrf CUENTA, 1	;valor inicial de CUENTA=0
    clrf MODO, 1	;modo inicial cero
    
inicio:
    call boton		;llamo a subrutina boton
    call visualizacion
    bra inicio
    
boton:
    movlb 0FH
    btfsc PORTB, 0, 1	;pregunto si presione boton en RB0
    return
    movlb 0H
    movlw 3
    cpfseq MODO, 1	;pregunto si modo es tres
    bra modo_no_es_tres
    bra modo_si_es_tres
modo_no_es_tres:
    incf MODO, 1, 1	;incremento valor del modo
    bra siguiente
modo_si_es_tres:
    clrf MODO, 1	;valor del modo a cero
siguiente:
    movlb 0FH
    btfss PORTB, 0, 1	;pregunto si solte boton en RB0
    bra siguiente
    movlb 0H
    clrf CUENTA, 1	;limpiamos CUENTA
    return
    
visualizacion:
    movlb 0H
    movlw 0
    cpfseq MODO, 1	;pregunto si modo es cero
    bra sera_modo1
    movlb 0H
    movf CUENTA, 0, 1	;sacamos valor de CUENTA hacia Wreg
    movlb 0FH
    movwf TBLPTRL, 1
    movlw 05H
    movwf TBLPTRH, 1
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
    return
siestrece:
    clrf CUENTA, 1	;limpia CUENTA
    return

sera_modo1:
    movlw 1
    cpfseq MODO, 1	;pregunto si modo es uno
    bra sera_modo2
    movlb 0H
    movf CUENTA, 0, 1	;sacamos valor de CUENTA hacia Wreg
    movlb 0FH
    movwf TBLPTRL, 1
    movlw 06H
    movwf TBLPTRH, 1
    TBLRD*		;accion de lectura
    movff TABLAT, LATD	;muevo TABLAT hacia RD
    call retardo
    movlb 0H
    movlw 11
    cpfseq CUENTA, 1	;pregunta si CUENTA=11
    bra noesonce
    bra siesonce
noesonce:
    incf CUENTA, 1, 1	;incrementa CUENTA
    return
siesonce:
    clrf CUENTA, 1	;limpia CUENTA
    return  
    
sera_modo2:
    movlw 2
    cpfseq MODO, 1	;pregunto si modo es dos
    bra sera_modo3
    movlb 0H
    movf CUENTA, 0, 1	;sacamos valor de CUENTA hacia Wreg
    movlb 0FH
    movwf TBLPTRL, 1
    movlw 07H
    movwf TBLPTRH, 1
    TBLRD*		;accion de lectura
    movff TABLAT, LATD	;muevo TABLAT hacia RD
    call retardo
    movlb 0H
    movlw 9
    cpfseq CUENTA, 1	;pregunta si CUENTA=9
    bra noesnueve
    bra siesnueve
noesnueve:
    incf CUENTA, 1, 1	;incrementa CUENTA
    return
siesnueve:
    clrf CUENTA, 1	;limpia CUENTA
    return
    
sera_modo3:
    movlb 0H
    movf CUENTA, 0, 1	;sacamos valor de CUENTA hacia Wreg
    movlb 0FH
    movwf TBLPTRL, 1
    movlw 08H
    movwf TBLPTRH, 1
    TBLRD*		;accion de lectura
    movff TABLAT, LATD	;muevo TABLAT hacia RD
    call retardo
    movlb 0H
    movlw 5
    cpfseq CUENTA, 1	;pregunta si CUENTA=5
    bra noescinco
    bra siescinco
noescinco:
    incf CUENTA, 1, 1	;incrementa CUENTA
    return
siescinco:
    clrf CUENTA, 1	;limpia CUENTA
    return     
    
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
    





