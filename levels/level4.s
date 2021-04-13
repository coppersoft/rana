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

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	0				; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


	dc.l	Tronco2			; Indirizzo bob
	dc.l	Tronco2_mask	; Indirizzo bobmask
	dc.w	(96/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	80				; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale



; Riga 2

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-2				; Velocità
	dc.w	30				; x
	dc.w	70				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-2				; Velocità
	dc.w	30+36	; x
	dc.w	70				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-2				; Velocità
	dc.w	30+36+36	; x
	dc.w	70				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

; Riga 3

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	50				; x
	dc.w	90				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


	dc.l	Tronco2			; Indirizzo bob
	dc.l	Tronco2_mask	; Indirizzo bobmask
	dc.w	(96/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	50+64+96		; x
	dc.w	90				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	50+64+96+96		; x
	dc.w	90				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

; Riga 4


; tartarughe

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	60		; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	60+36	; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	60+36+36	; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


; Riga 1 automobili

	dc.l	FurgoneSx			; Indirizzo bob
	dc.l	FurgoneSx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-4				; Velocità
	dc.w	320				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale



	dc.l	AutoArancioneSx			; Indirizzo bob
	dc.l	AutoArancioneSx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-4				; Velocità
	dc.w	50				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

; Riga 2 autobili

	dc.l	Buggy			; Indirizzo bob
	dc.l	Buggy_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-2				; Velocità
	dc.w	60				; x
	dc.w	190				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	RoverSx
	dc.l	RoverSx_mask
	dc.w	(48/16)
	dc.w	-2
	dc.w	150
	dc.w	190
	dc.l	SingleFrameList
	dc.w	0

	

; Riga 3 autobili

	dc.l	FurgoneDx			; Indirizzo bob
	dc.l	FurgoneDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	40				; x
	dc.w	220				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	FurgoneDx			; Indirizzo bob
	dc.l	FurgoneDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	180				; x
	dc.w	220				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoArancioneDx			; Indirizzo bob
	dc.l	AutoArancioneDx_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	250				; x
	dc.w	220				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	0