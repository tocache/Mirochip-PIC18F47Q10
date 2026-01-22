    PROCESSOR 18F47Q10
    #include "cabecera.inc"
    
    PSECT upcino, class=CODE, reloc=2, abs
upcino:
    ORG 000000H	    ;Lo primero que el CPU ejecuta cuando se energiza, el vector de reset
    bra configuro   ;salta a etiqueta configuro
    
    ORG 000100H	    ;Zona de programa de usuario
configuro:
    ;Conf del módulo de oscilador
    movlb 0EH	    ;Al Bank14
    movlw 60H
    movwf OSCCON1, 1	;NOSC=HFINTOSC, NDIV 1:1
    movlw 02H
    movwf OSCFRQ, 1	;HFINTOSC a 4MHz
    movlw 40H
    movwf OSCEN, 1	;HFINTOSC enabled
    ;Conf las E/S
    movlb 0FH		;Al Bank 15
    bsf TRISB, 0, 1	;RB0 entrada
    bcf ANSELB, 0, 1	;RB0 digital
    bcf TRISD, 0, 1	;RD0 salida
    bcf ANSELD, 0, 1	;RD0 digital
    
inicio:
    btfss PORTB, 0, 1	;Pregunto si RB0 es uno
    bra noescierto	;Falso a si RB0=1
    bra escierto	;Verdad a si RB0=1
    
noescierto:
    bsf LATD, 0, 1	;RD0 = 1
    bra inicio		;salto a inicio
    
escierto:
    bcf LATD, 0, 1	;RD0 = 0
    bra inicio		;salto a inicio
    
    end upcino


