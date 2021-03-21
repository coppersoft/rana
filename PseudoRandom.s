

; Banalissimo generatore di numeri casuali, semplicemente prendo la posizione verticale del
; pennello in quel momento da VHPOSR http://amiga-dev.wikidot.com/hardware:vhposr
PseudoRandom:
	move.w	$dff006,d0
	and.w	#%0000011100000000,d0
	lsr.w	#8,d0
	bra.s	PseudoRandom
	

