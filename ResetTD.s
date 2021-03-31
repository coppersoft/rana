ResetTouchDowns:
	lea		TouchdownAreas,a0
	
	move.w	#0,2(a0)
	move.w	#0,6(a0)
	move.w	#0,10(a0)
	move.w	#0,14(a0)
	move.w	#0,18(a0)
	rts

TouchdownAreas:
	dc.w	11,1
	dc.w	81,1
	dc.w	151,1
	dc.w	221,1
	dc.w	291,1
	dc.w	$ffff
