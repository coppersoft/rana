

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
	
.checkloop
	move.w	d7,d6
	lea	TouchdownAreas,a2
	addi.w	#2,a2
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

	lea		TouchdownAreas,a2

	lsl.w	#2,d7			; Moltiplico per due il numero casuale
	add.w	d7,a2			; E lo uso come offset per prendere la X dell'area touchdown

	move.w	(a2),d1			; X in d1

	addq.w	#3,d1			; lo centro

	rts
	

TouchdownAreas:
	dc.w	11,1	; $0B
	dc.w	81,1	; $51
	dc.w	151,1	; $97
	dc.w	221,0	; $DD
	dc.w	291,1	; $123
