; Struttura dati per i livelli

; - Indirizzo bob
; - Indirizzo bobmask
; - larghezza in word
; - velocità (con segno)
; - x attuale
; - x (iniziale)
; - y
; - contatore fotogramma
; - fotogramma attuale
; - fotogrammi totali

; Riga 1

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	0				; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

    dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	160				; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Tronco2			; Indirizzo bob
	dc.l	Tronco2_mask	; Indirizzo bobmask
	dc.w	(96/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	270				; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


; Riga 2

    dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	10		; x
	dc.w	70				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

    dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	50		; x
	dc.w	70				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


; Riga 3

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	30				; x
	dc.w	90				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Tronco2			; Indirizzo bob
	dc.l	Tronco2_mask	; Indirizzo bobmask
	dc.w	(96/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	160				; x
	dc.w	90				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


; Riga 4

    dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-2				; Velocità
	dc.w	30		; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

    dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-2				; Velocità
	dc.w	30+36		; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

    dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-2				; Velocità
	dc.w	30+36+36		; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

; Riga 1 automobili

	dc.l	FurgoneDx			; Indirizzo bob
	dc.l	FurgoneDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	320				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoBluDx			; Indirizzo bob
	dc.l	AutoBluDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	160				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoArancioneDx			; Indirizzo bob
	dc.l	AutoArancioneDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	40				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale



; Riga 2 autobili

	dc.l	Buggy			; Indirizzo bob
	dc.l	Buggy_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-4				; Velocità
	dc.w	50				; x
	dc.w	190				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

; Riga 3 autobili

	dc.l	FurgoneDx			; Indirizzo bob
	dc.l	FurgoneDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	40				; x
	dc.w	220				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoBluDx			; Indirizzo bob
	dc.l	AutoBluDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	140				; x
	dc.w	220				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoArancioneDx			; Indirizzo bob
	dc.l	AutoArancioneDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	240				; x
	dc.w	220				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


    dc.l    0