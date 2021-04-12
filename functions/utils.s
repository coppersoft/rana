; ATTENZIONE: Sovrascrive d0!
; d0 : srcX
; d1 : srcY
; d2 : dstX
; d3 : dstY
; d4 : src box width/2 + dst box width/2
; d5 : src box height/2 + dst box height/2
; d0 : 1 se collide, 0 se non collide

BoundaryCheck:

    sub.w   d2,d0               ; x mostro - x proiettile = differenza orizzontale vertici sup sx
    bpl.s   .nonnegX            ; Se non è negativo salta
    neg.w   d0                  ; Se è negativo prendo il valore assoluto
.nonnegX
    cmp.w   d4,d0               ; Confronto con la larghezza boundary
    bhi.s   .nocoll             ; Se d0 > d4 non c'è collisione orizzontale, e quindi non c'è
                                ; alcuna collisione => esce.

                                ; Se invece c'è un intersecamento orizzontale, controllo che
                                ; ci sia anche quello verticale
    sub.w   d3,d1               ; y mostro - y proiettile
    bpl.s   .nonnegY            ; Se non è negativo salta
    neg.w   d1                  ; Se è negativo prendo il valore assoluto

.nonnegY
    cmp.w   d5,d1               ; Confronto con l'altezza boundary
                                ; A questo punto se il flag N (3) dello Status Register (SR)
                                ; E' 1 allora c'è stata collisione
    bpl.s	.nocoll
    move.w  #1,d0
    rts
.nocoll
    move.w  #0,d0
    rts
; --------------


; d0: valore decimale fino a 65535
; a0: Destinazione (6 byte)
DecToStr:

;	move.l	d0,d1
;	divu.l	#100000,d1          ; divu e mulu con operandi a 32 bit solo dal 68020 in su...
;	move.b	d1,(a0)+
;	mulu.l	#100000,d1
;	sub.l	d1,d0

; ---

	move.l	d0,d1
	divu.w	#10000,d1
	move.b	d1,(a0)+
	mulu.w	#10000,d1
	sub.l	d1,d0

; ----

	move.l	d0,d1
	divu.w	#1000,d1
	move.b	d1,(a0)+
	mulu.w	#1000,d1
	sub.l	d1,d0

; ----

	move.l	d0,d1
	divu.w	#100,d1
	move.b	d1,(a0)+
	mulu.w	#100,d1
	sub.l	d1,d0

; ----

	move.l	d0,d1
	divu.w	#10,d1
	move.b	d1,(a0)+
	mulu.w	#10,d1
	sub.l	d1,d0

	move.b	d0,(a0)

	rts

SwitchBuffers:

    movem.l d0-d1/a0,-(SP)

; Stessa cosa per il puntatore dei bob, dove non salto il margine
    move.l  draw_buffer_bob,d0
    move.l  view_buffer_bob,draw_buffer_bob
    move.l  d0,view_buffer_bob

    move.l  draw_buffer,d0
    move.l  view_buffer,draw_buffer
    move.l  d0,view_buffer

    ; Setto CINQUE bitplane 

    lea     Bplpointers,a0 

    moveq   #5-1,d1
PuntaBP:
    move.w  d0,6(a0)
    swap    d0 
    move.w  d0,2(a0) 
    swap    d0
    addq.l  #8,a0
    
    addi.l  #40+(background_margin*2),d0
    dbra    d1,PuntaBP

    movem.l (SP)+,d0-d1/a0

    rts

ShowLifes:
    ; Visualizzo il numero di vite, in entrambi i buffer
    move.l  draw_buffer,a0
    bsr.w   DrawLifes

    move.l  view_buffer,a0
    bsr.w   DrawLifes

    rts

; Routine per la stampa del punteggio
; CPU based, non blitter
ScoreStart = ((((background_margin*2)+40)*5)*6)+7

DrawScore:

    move.w  Score,d0
    lea     ScoreStr,a0

    bsr.w   DecToStr            ; Converto il valore decimale in stringa

    lea     ScoreStr,a0

    move.l  draw_buffer,a4      ; Me li salvo per i successivi loop
    move.l  view_buffer,a5

    move.l  #0,d2               ; Contatore cifra da stampare

    move.l  #5-1,d3             ; numero di cifre

.drawscoreloop:

    move.l  a4,a1               
    move.l  a5,a2

    add.l   #ScoreStart,a1
    add.l   #ScoreStart,a2

    add.l   d2,a1               ; mi sposto di un byte per ogni cifra
    add.l   d2,a2

    move.l  #0,d0

    move.b  (a0)+,d0            ; Prendo la cifra corrente in d0

    lea     Digits,a3           ; Font delle cifre in a3
    mulu.w  #7*5,d0             ; Moltiplico per l'altezza del font * 5 bitplane
    add.l   d0,a3               ; Trovo la posizione iniziale della cifra

    move.w  #(7*5)-1,d1         ; 7 byte * 5 bitplane da copiare
.drawsingledigitloop:

    move.b  (a3),(a1)
    move.b  (a3)+,(a2)
    add.l   #(background_margin*2)+40,a1              ; Equivalente del modulo del blitter
    add.l   #(background_margin*2)+40,a2
    dbra    d1,.drawsingledigitloop

    addq.l  #1,d2               ; Passo alla prossima cifra
    dbra    d3,.drawscoreloop

    rts



; a0:  Palette grezza
; a1:  Palette copperlist +2
; d0:  Fotogramma del fade
; d1:  Numero di colori
Fade:
	moveq	#0,d2
	moveq	#0,d3

	move.w	(a0),d2
	andi.w	#$000f,d2
	mulu.w	d0,d2
	lsr.w	#4,d2
	andi.w	#$000f,d2
	move.w	d2,d3
	
	move.w	(a0),d2
	andi.w	#$00f0,d2
	mulu.w	d0,d2
	lsr.w	#4,d2
	andi.w	#$00f0,d2
	or.w	d2,d3
	
	move.w	(a0)+,d2
	andi.w	#$0f00,d2
	mulu.w	d0,d2
	lsr.w	#4,d2
	andi.w	#$0f00,d2
	or.w	d2,d3
	
	move.w	d3,(a1)
	addq.w	#4,a1
	dbra	d1,Fade
	rts

; -------

;framesPerStripPixel=50
framesPerStripPixel=500
maxStrip=32

HandleTimeStrip:

    cmpi.w  #maxStrip,TimeStripCounter
    bne.s   .nonmuore

    bsr.w   KillRana
    rts

.nonmuore

	move.l	draw_buffer,a0
	add.l	#time_strip_start,a0

    lea     TimeStrip,a1

    move.l  #0,d0

    move.w  TimeStripCounter,d0
    lsl.w   #2,d0
    add.w   d0,a1

; Prima riga
	move.l	(a1),(a0)
	add.l	#(20+40),a0
	move.l	#$00000000,(a0)
	add.l	#(20+40),a0
	move.l	#$00000000,(a0)
	add.l	#(20+40),a0
	move.l	(a1),(a0)
	add.l	#(20+40),a0
	move.l	(a1),(a0)

; Seconda riga
	add.l	#(20+40),a0
	move.l	(a1),(a0)
	add.l	#(20+40),a0
	move.l	#$00000000,(a0)
	add.l	#(20+40),a0
	move.l	#$00000000,(a0)
	add.l	#(20+40),a0
	move.l	(a1),(a0)
	add.l	#(20+40),a0
	move.l	(a1),(a0)

    tst.w   TimeFrameCounter            ; Il contatore dei frame per la singole lunghezza della barra è a 0?
    bne.s   .nonscende                  ; Se no, non scende

    addq.w  #1,TimeStripCounter
    move.w  #framesPerStripPixel,TimeFrameCounter


.nonscende
    subq.w  #1,TimeFrameCounter

    rts

; ------------

; Banalissimo generatore di numeri casuali, semplicemente prendo la posizione verticale del
; pennello in quel momento da VHPOSR http://amiga-dev.wikidot.com/hardware:vhposr
PseudoRandom:
	move.w	$dff006,d7
	and.w	#%0000011100000000,d7
	lsr.w	#8,d7

; Mi serve da 0 a 4
	cmpi.w	#4,d7
	ble.s	.ok

	subq.w	#4,d7

.ok

; Controllo che il posto non sia già occupato da una rana

.checkloop
	move.w	d7,d6
	lea	TouchdownAreas,a2
	addq.w	#2,a2
	lsl.w	#2,d6
	add.w	d6,a2

	tst.w	(a2)
	beq.s	.ok2

	cmpi.w	#4,d7
	bne.s	.nonricomincia
	move.w	#0,d7
	bra.s	.checkloop
.nonricomincia
	addq.w	#1,d7
	bra.s	.checkloop

.ok2

	rts

SetLevel:
	move.w	GameLevel,d0
	lea		LevelsList,a0
	lsl.w	#2,d0
	add.l	d0,a0
	move.l	(a0),ActualLevelPtr
	rts

; --- DATI 

TimeStrip:

	dc.l	$ffffffff
	dc.l	$fffffffe
	dc.l	$fffffffc
	dc.l	$fffffff8
	dc.l	$fffffff0
	dc.l	$ffffffe0
	dc.l	$ffffffc0
	dc.l	$ffffff80
	dc.l	$ffffff00
	
	dc.l	$fffffe00
	dc.l	$fffffc00
	dc.l	$fffff800
	dc.l	$fffff000
	dc.l	$ffffe000
	dc.l	$ffffc000
	dc.l	$ffff8000
	dc.l	$ffff0000
	
	dc.l	$fffe0000
	dc.l	$fffc0000
	dc.l	$fff80000
	dc.l	$fff00000
	dc.l	$ffe00000
	dc.l	$ffc00000
	dc.l	$ff800000
	dc.l	$ff000000
	
	dc.l	$fe000000
	dc.l	$fc000000
	dc.l	$f8000000
	dc.l	$f0000000
	dc.l	$e0000000
	dc.l	$c0000000
	dc.l	$80000000
	dc.l	$00000000

; Conta il numero dei frame prima che la barra del tempo scenda di un pixel
TimeFrameCounter:
	dc.w	framesPerStripPixel

; Lunghezza della barra del tempo (al contrario)
TimeStripCounter:
	dc.w	0