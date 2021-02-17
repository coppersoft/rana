FindAttachedDirection:
	move.l	LivelloAttuale,a0

	move.w	RanaY,d1
	addq.w	#6,d1			; Y target (YT) in d1, più o meno al centro Y della rana in qualsiasi fotogramma
.levelLoop
	move.l	(a0)+,d0
	tst.l	d0	; Fine lista?
	beq.s	.exit	; questo in teoria non dovrebbe mai succedere...
	add.l	#6,a0	; Salto maschera e larghezza in word
	move.w	(a0)+,d2	; Mi segno la velocità in d2
	add.l	#2,a0	; Salto la x
	move.w	(a0)+,d3	; Y del tronco/tartaruga in d3

; d1 y centrale rana e d3 y iniziale tronco/tartaruga

	cmp.w	d3,d1	; d1 (rana) >= d3 (tronco)???
	bge.s	.sotto	; rana è sotto l'inizio del tronco? (bge great or equal)
	bra.s	.levelLoop
.sotto
	addi.w	#16,d3	; Andiamo alla fine del tronco/tartaruga
	cmp.w	d3,d1	; d3 (rana) <= d1 (tronco)???
	ble.s	.trovato	; se sì ho beccato la riga di bob che mi interessa
	bra.s	.levelLoop

.trovato

; Controllo se la velocità è un numero positivo o negativo
	cmpi.w	#0,d2
	bgt.s	.positivo
	move.w	#$ffff,$dff180	
	rts
.positivo
	move.w	#$4444,$dff180
	rts


.exit
	rts

RanaY:
    dc.w    50+7

Livello1:
	dc.l	$aaaaaaaa
	dc.l	$ffffffff
	dc.w	(64/16)
	dc.w	1				; Velocità
	dc.w	100				; x
	dc.w	50				; y

	dc.l	$bbbbbbbb
	dc.l	123
	dc.w	(64/16)
	dc.w	1				; Velocità
	dc.w	160				; x
	dc.w	50				; y

	dc.l	0

LivelloAttuale:
	dc.l	Livello1
