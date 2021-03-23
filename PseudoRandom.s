

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

	lea		TouchdownAreas,a2

	lsl.w	#1,d7			; Moltiplico per due il numero casuale
	add.w	d7,a2			; E lo uso come offset per prendere la X dell'area touchdown

	move.w	(a2),d1			; X in d1

	addq.w	#3,d1			; lo centro

	rts
	

TouchdownAreas:
	dc.w	11
	dc.w	81
	dc.w	151
	dc.w	221
	dc.w	291
