;    Rana

;    a Frogger game for Commodore Amiga OCS/ECS, written in 68000 assembly
;    for the Retro Programmers Inside (RPI) gamedev competition.

;    AMIGA WILL NEVER DIE!!!!!

;    Copyright (C) 2020 - Lorenzo Di Gaetano <lorenzodigaetano@yahoo.it>

;    Uses P61 mod play routine by Jarno Paananen

;    Compile with
;    vasmm68k_mot -Fhunkexe -kick1hunks rana.s

;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.

;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.

;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <https://www.gnu.org/licenses/>.

; Costanti


    SECTION Rana,CODE_C

    include "music/P61.conf"
    include "functions/init.s"

background_margin = 10       ; Margine in byte, sia sinistro che destro

ranaX_start = jump_length_horiz*6
ranaY_start	= 240
jump_length_vert = 21
jump_length_horiz = 16

car_zone_y_margin=240-(7*16)

; ===== INIZIO CODICE 

START:

; E' meglio aspettare l'end of frame prima di smaneggiare con questi registri

    move.w  #$138,d0
    bsr.w   WaitRaster
    
    move.w  #$7fff,$dff09a           ; Disabilito tutti i bit in INTENA (interrupt enable)

;   Tolto perché ora mi servono gli interrupt!
;    move.w  #$7fff,$dff09c          ; (Buona pratica:) Disabilito tutti i bit in INTREQ
;    move.w  #$7fff,$dff09c          ; (Buona pratica:) Disabilito tutti i bit in INTREQ, faccio due volte per renderlo compatibile con A4000 che ha un bug

; Per disabilitare tutti i DMA completamente, facciamo qualcosa di simile a quanto fatto qui sopra con gli interrupt

    move.w  #$7fff,$dff096          ; Disabilito tutti i bit in DMACON

; Abilito copper, bitplanes, sprite ecc...

; DMACON dff096 DMA Control write (clear or set) http://amiga-dev.wikidot.com/hardware:dmaconr

    move.w  #$87e0,$dff096      ; DMACON (write) 1000011111100000
                                ; 15 - Set Clear bit a 1 => i bit a 1 settano
                                ; 10 - BlitPRI a 1
                                ; 9  - DMAEN  (Abilita tutti i DMA successivi)
                                ; 8  - BPLEN  (Bit plane DMA Enable)
                                ; 7  - COPEN  (Coprocessor DMA Enable)
                                ; 6  - BLTEN  (Blitter DMA enable)
                                ; 5  - SPREN  (Sprite DMA enable)

; Inizializzo la routine P61 per la musica

;	movem.l	d0-d7/a0-a6,-(SP)
;	moveq	#0,d0		; Timer Detection: Autodetect
;	lea	    Music,a0	; Indirizzo del modulo in a0
;	lea	    $dff000,a6	; Ricordiamoci il $dff000 in a6!
;	sub.l	a1,a1		; I samples non sono a parte, mettiamo zero
;	sub.l	a2,a2		; no samples -> modulo non compattato
;	bsr.w	P61_Init
;	movem.l	(SP)+,d0-d7/a0-a6

    lea     $dff000,a5
    move.w	#0,$1fc(a5)		    ; Disattiva l'AGA
	move.w	#$c00,$106(a5)		; Disattiva l'AGA
	move.w	#$11,$10c(a5)		; Disattiva l'AGA
    move.w	#%1110000000100000,$09a(a5)	; Setto INTENA, interrupt enable bits.
                                        ; 15: Bit set/clr, come per DMACON
                                        ; 14: Master interrupt
                                        ; 13: External interrupt
                                        ; 5:  VERTB: abilito l'interrupt all'inizio del vblank, per il player musicale

    move.l	BaseVBR,a4          ; BaseVBR recuperato, se necessario, in init.s
	move.l	#INTERRUPT,$6c(a4)	; Punto il mio interrupt


 




    ; Setto la copperlist

    move.l  #Copper,$dff080     ; http://amiga-dev.wikidot.com/hardware:cop1lch  (Copper pointer register) E' un long word move perché il registro è una long word

    ; Configurazione collisioni sprite
    ; CLXCON: http://amiga-dev.wikidot.com/hardware:clxcon

;    move.w  #%0000010000011111,$dff098     ; OK
    move.w  #%0000010000010000,$dff098



; PRESENTAZIONE INIZIALE

;    lea     Presentazione,a0
;    move.l  draw_buffer,a1
;    move.w  #200,d0
;    move.w  #5,d1
;    bsr.w   SimpleBlit

;    lea     Presentazione+(200*44*5),a0
;    move.l  draw_buffer,a1
;    add.l   #200*44*5,a1
;    move.w  #55,d0
;    move.w  #5,d1
;    bsr.w   SimpleBlit

;    bsr.w   SwitchBuffers

;    move.l  #0,d0
;.fadein_pres:
;    lea     PaletteRaw,a0
;    lea     Palette+2,a1
;    moveq   #32-1,d1
;    addi.b  #1,d0
;    bsr.w   Fade
;    bsr.w   wframe
;    bsr.w   wframe
;    cmpi.b  #16,d0
;    bne.s   .fadein_pres
    
;.pr_loop:
;    btst    #7,$bfe001
;    bne.s   .pr_loop

;	moveq	#16,d0
;.fadeout_pres:
;	lea	    PaletteRaw,a0
;	lea	    Palette+2,a1
;	moveq	#32-1,d1
;	subi.b	#1,d0
;	bsr.w	Fade
;   bsr.w   wframe
;   bsr.w   wframe
;	tst.b	d0
;	bne.s	.fadeout_pres


; FINE PRESENTAZIONE INIZIALE

RestartGame:
    move.w  #3,Lifes
    move.w  #1,GameLevel
    move.w  #0,Score

InitLevel:

	move.w	#ranaX_start,RanaX
	move.w	#ranaY_start,RanaY

; Stabilisco il livello di difficoltà

; TODO

.iniziogioco

    bsr.w   CopiaSfondo
;    bsr.w   ShowLifes

;    bsr.w   DrawScore

; Prova blitting

;	lea		Tronco1,a0
;	lea		Tronco1_mask,a1
;	move.l	draw_buffer_bob,a2

;	move.w	#32,d0
;	move.w	#0,d1
;	move.w	#(64/16),d2
;	move.w	#16,d3
;	move.w	#5,d4

;	bsr.w	BlitBob


; fine prova blitting



;	move.w	#50,d0
;	move.w	#50,d1
;	move.w	#5,d5
;	bsr.w	ShowExplosionFrame




; GAME LOOP

    move.l  #0,d0



mainloop:

; Fade in ingame
    cmpi.w  #16,FadeInFrame
    beq.s   .nofadein

    addi.w  #1,FadeInFrame
    move.w  FadeInFrame,d0
    lea     PaletteRaw,a0
    lea     Palette+2,a1
    moveq   #32-1,d1
    
    bsr.w   Fade

.nofadein:

	bsr.w	DrawScore

    bsr.w   CheckSoundStop

    bsr.w   SwitchBuffers
	bsr.w   wframe



; Inizio prova movimento

    bsr.w   CheckInput
	bsr.w	UpdateRanaPosition
    bsr.w	DrawRana


; Fine prova movimento

; Inizio test collisioni
  
	bsr.w	CheckCollisions

; Fine test collisioni

	bsr.w	HandleExplosionAnimation

; Disegno bob
	

	bsr.w	DrawBobs
	bsr.w	UpdateBobPositions
    
    btst    #6,$bfe001
    bne     mainloop


;    bsr.w   P61_End

    rts
; ===== FINE LOOP PRINCIPALE




; Includo funzioni utility per blitter, sprite, collisioni, conversioni e player musicale
    include "functions/blitter.s"
    include "functions/sprite.s"
    include "functions/utils.s"
    include "functions/audio.s"
    include "music/P6112-Play.s"
	

; *************** INIZIO ROUTINE UTILITY


CheckCollisions:
; Prima di tutto controllo in che "zona" si trova la rana, se è nella zona inferiore, quella con le auto,
; qualsiasi collisione è mortale
	cmpi.w	#car_zone_y_margin,RanaY
	bge.s	.carzone
	bsr.w	WaterZoneCollision
	rts

.carzone:
	bsr.w	CarZoneCollision
	rts



CarZoneCollision:
    move.w  $dff00e,d3
    btst.l  #4,d3
    beq.s   .nocoll

    bsr.w	KillRana
.nocoll
	rts

; Nel caso dell'acqua, la collisione la devo controllare solo se la rana ha finito di saltare, ovvero è in stato idle (0)
; in quel caso si verificano due scenari
; 1: Non c'è collisione con nulla => E' finita in acqua e muore
; 2: Si è aggrappata a qualche cosa
WaterZoneCollision:

	cmpi.w	#0,RanaState
	bne.s	.exit

	move.w	$dff00e,d3
	btst.l	#4,d3
	beq.s	.nocoll
	bra.s	.coll
.nocoll
	bsr.w	KillRana
	rts

.coll

	bsr.w	FindAttachedDirection

	cmpi.w	#3,d2
	bne.s	.destra
	move.w	#$0fff,$dff180
	rts
.destra
	move.w	#$0f00,$dff180
.exit
	rts

; Routine ultra semplificata per stabilire a cosa la rana si è attaccata, trova il primo oggetto
; (tronco o tartaruga) che abbia una posizione Y iniziale e finale che comprende la Y centrale della rana
; e ne recupera la direzione

; Restituisce in d2 stato 3 se è attaccato direzione sinistra, 4 se è attaccato direzione destra
FindAttachedDirection:
    lea     Directions,a0
    move.w  RanaY,d0

.loopdir
    move.w  (a0)+,d1    ; Y di controllo in d1
    cmpi.w  #$ffff,d1   ; non dovrebbe mai succedere...
    beq.s   .exit

    move.w  (a0)+,d2    ; Direzione in d2

    cmp.w   d1,d0
    bne.s   .loopdir
    
.exit
    rts

	


KillRana:
	move.w	#2,RanaState
	move.w	#0,RanaSpritePointer+2
	move.w	#0,RanaSpritePointer+6
	bsr.w	PlayBoom
	rts

; -------------

HandleExplosionAnimation:

	cmpi.w	#2,RanaState
	bne.w	.exit

	move.w	ExplosionActualFrame,d0
	lea		ExplosionFrameList,a1
	lsl.w	#1,d0
	add.l	d0,a1
	move.w	(a1),d5

	cmpi.w	#$ffff,d5		; E' alla fine dell'animazione?
	bne.s	.goanim

	move.w	#0,ExplosionSxSpritePointer+2	; Se si disattivo lo sprite...
	move.w	#0,ExplosionSxSpritePointer+6
	move.w	#0,ExplosionDxSpritePointer+2
	move.w	#0,ExplosionDxSpritePointer+6

	move.w	#0,ExplosionActualFrame			; Resetto il contatore del frame

	move.w	#0,RanaState					; Riattivo la rana in idle
	move.w	#ranaX_start,RanaX
	move.w	#ranaY_start,RanaY
	move.w	#0,RanaOrientation
	move.w	#0,JumpFrame
	bra.s	.exit

.goanim:

	move.w	RanaX,d1
	subq.w	#8,d1
	move.w	RanaY,d0
	subq.w	#8,d0
	bsr.w	ShowExplosionFrame
	addq.w	#1,ExplosionActualFrame

.exit
	rts



; -------------

; d0: y
; d1: x
; d5: frame
ShowExplosionFrame:

; inizio prova sprite esplosione
   	lea     ExplosionSxSpritePointer,a0
	lea		ExplosionSpriteFrames,a1

	mulu.w	#((32*4)+8)*2,d5	; salto al frame n
	add.l	d5,a1

    move.l  a1,d3

    move.w  d3,6(a0)
    swap    d3
    move.w  d3,2(a0)		; Punto lo sprite nella copperlist
	
	
	move.w	#32,d2			; Altezza in d2
	bsr.w	PointSprite

; Sprite destra

	lea		ExplosionDxSpritePointer,a0
	add.l	#(32*4)+8,a1

	move.l	a1,d3

    move.w  d3,6(a0)
    swap    d3
    move.w  d3,2(a0)		; Punto lo sprite nella copperlist
	
	add.w	#16,d1
	move.w	#32,d2
	bsr.w	PointSprite

	rts


	
DrawBobs:

;	TODO: Sostituire con puntatore al buffer dei livelli
;	lea		Livello1,a4
	move.l	LivelloAttuale,a4


	clr.l	d5

.levelLoop

	move.l	(a4)+,d0
	tst.l	d0					; Siamo alla fine della lista?
	beq.s	.exit

	move.l	d0,a0				; Indirizzo bob in a0
	move.l	#0,d0

	move.l	(a4)+,a1			; Indirizzo maschera in a1
	move.l	draw_buffer_bob,a2	; indirizzo bitplane di disegno, senza margini in a2
	lea		Background,a3		; indirizzo background


	move.w	(a4)+,d2			; larghezza in word
	addq.l	#2,a4				; Qui salto la velocità
	move.w	(a4)+,d0			; x
	move.w	(a4)+,d1			; y

; Inizio gestione fotogrammi

	move.l	(a4)+,a5			; indirizzo lista fotogrammi in a5
	move.w	(a4),d5				; indice fotogramma attuale in d5

	lsl.w	#1,d5				; moltiplico per 2
	add.l	d5,a5				; Trovo l'indirizzo dell'indice del fotogramma attuale

	move.w	(a5)+,d5			; in d5 il fotogramma attuale, puntando al successivo
								; per il controllo fine lista

	mulu.w	d2,d5				; Moltiplico il fotogramma attuale per la larghezza in word
	lsl.w	#1,d5				; in byte
	lsl.w	#4,d5				; Per 16 righe
	mulu.w	#5,d5 				; Per il numero di bitplane
	

	add.w	d5,a0				; Sommo l'offset all'indirizzo bob
	add.w	d5,a1				; E alla maschera

; Controllo che non siamo a fine lista
	move.w	(a5),d5				; Indice del fotogramma successivo

	cmpi.w	#$ffff,d5			; fine lista?
	bne.s	.nofine
	move.w	#-1,(a4)
.nofine
	add.w	#1,(a4)				; Avanzo al prossimo fotogramma per il prossimo draw

	add.w	#2,a4				; Prossimo bob

; fine gestione fotogrammi

	move.w	#16,d3
	move.w	#5,d4
	bsr.w	BlitBob

	bra.s	.levelLoop
.exit
	rts

; -----------------------------------------

UpdateBobPositions:

;	TODO: Sostituire con puntatore al buffer dei livelli
;	lea		Livello1,a0
	move.l	LivelloAttuale,a0

.levelLoop
	move.l	(a0)+,d0		; Fine lista?
	tst.l	d0
	beq.s	.exit
	add.l	#6,a0			; Salto subito alla velocità
	move.w	(a0)+,d0		; velocità in d0
	move.w	(a0),d1			; Posizione attuale in d1



	add.w	d0,d1		; sommo la velocità alla posizione attuale

	cmp.w	#0,d1		; E' un numero negativo?
	bgt.s	.nosx_marg	; Se è positivo salto
	move.w	#320+(background_margin*8),d1		; Se è negativo lo riporto dall'altro lato, a destra
	bra.s	.done
.nosx_marg
	cmpi.w	#320+(background_margin*8),d1		; E' oltre il margine destro?
	blt.s	.done		; Se no salto
	move.w	#0,d1		; Se si lo riporto al margine sinistro
.done
	move.w	d1,(a0)+

; MODIFICARE QUI

	add.w	#8,a0			; Salto la y e i dati sui fotogrammi, passando al prossimo bob

	bra.s	.levelLoop

.exit
	rts




; -----------------------------------------

CheckInput:

	cmpi.w	#1,RanaState	; Se sta saltando salto il controllo
	beq.w	.exit

	cmpi.w	#2,RanaState	; Anche se sta esplodendo
	beq.w	.exit

    move.w  $dff00c,d3
    btst.l  #1,d3       ; Bit 1 (destra) è azzerato?
    beq.s   .nodestra   ; Se si salto lo spostamento a destra

	cmpi.w	#320-16,RanaX		; Se è al margine destro non salta
	bge.w	.exit

    move.w	#3,RanaOrientation	; Destra
	move.w	#1,RanaState

	bsr.w	PlayCra

    rts
.nodestra
    btst.l  #9,d3       ; Il bit 9 (sinistra) è azzerato?
    beq.s   .checkvert  ; Se si passo al controllo verticale

	cmpi.w	#0,RanaX	; Se è al margine sinistro non salta
	ble.w	.exit

	move.w	#2,RanaOrientation	; Sinistra
	move.w	#1,RanaState

	bsr.w	PlayCra

    rts                 ; Devo evitare movimenti diagonali, quindi esco subito
.checkvert
    ; Devo fare l'xor tra i bit 9 e 8 (su) e i bit 1 e 0 (giù), quindi
    move.w  d3,d2       ; Mi copio il registro in d2
    lsr.w   #1,d2       ; Sposto i bit a destra
    eor.w   d2,d3       ; Faccio l' XOR

    btst.l  #8,d3       ; Sta andando su?
    beq.s   .nosu       ; (bit azzerato)

    move.w	#0,RanaOrientation	; Su
	move.w	#1,RanaState

	bsr.w	PlayCra

    rts
.nosu
    btst.l  #0,d3       ; Sta andando giù?
    beq.s   .exit       ; Se no esce
 
	cmpi.w	#ranaY_start,RanaY		; Se è al margine inferiore non salta
	bge.w	.exit

	move.w	#1,RanaOrientation	; Su
	move.w	#1,RanaState

	bsr.w	PlayCra

.exit
    rts

; ---------------------------------------------

UpdateRanaPosition:
	tst.w	RanaState				; Se è idle esce
	beq.s	.exit

	cmpi.w	#2,RanaState			; Pure se sta esplodendo
	beq.s	.exit

	cmpi.w	#1,RanaOrientation		; In che verso sta saltando?
	bgt.s	.orizzontale
									; Verticalmente
	move.w	#jump_length_vert,d0
	bra.s	.finecontrollo
.orizzontale
	move.w	#jump_length_horiz,d0

.finecontrollo

	cmp.w	JumpFrame,d0
	bne.s	.moverana

	move.w	#0,RanaState
	move.w	#0,JumpFrame
	bra.s	.exit

.moverana
	tst.w	RanaOrientation
	bne.s	.nosu

	subq.w	#1,RanaY
	bra.s	.addjf

.nosu
	cmpi.w	#1,RanaOrientation
	bne.s	.nogiu

	addq.w	#1,RanaY
	bra.s	.addjf

.nogiu
	cmpi.w	#2,RanaOrientation
	bne.s	.nosx

	subq.w	#1,RanaX
	bra.s	.addjf

.nosx		; A questo punto è solo a destra
	addq.w	#1,RanaX

.addjf
	addq.w	#1,JumpFrame

.exit
	rts

; ---------------------------------------------


DrawRana:
	cmpi.w	#2,RanaState	; Se sta esplodendo non la visualizzo
	beq.s	.exit

	tst.w	RanaState
	beq.s	.idle						
	lea		RanaJumpingFrames,a0
	lea		RanaJumpingSpriteHeights,a2
	bra.s	.draw
.idle
	lea		RanaIdleFrames,a0
	lea		RanaIdleSpriteHeights,a2
.draw
	move.l	#0,d0
	move.w	RanaOrientation,d0
	lsl.w	#1,d0
	add.l	d0,a2			; Offset per la lista altezze
	lsl.w	#1,d0
	add.l	d0,a0			; Offset per la lista frame

	move.l	(a0),a1			; Recupero l'indirizzo dello sprite che mi interessa

    lea     RanaSpritePointer,a0
    move.l  a1,d0

    move.w  d0,6(a0)
    swap    d0
    move.w  d0,2(a0)		; Punto lo sprite nella copperlist

	move.l	#0,d0
    move.w  RanaY,d0
    move.w  RanaX,d1
    move.w  (a2),d2
    bsr.w   PointSprite		; Lo posiziono
.exit
	rts

; ---------------------------
;
; Routine per il waitraster 
; Aspetta la rasterline in d0.w , modifica d0-d2/a0

WaitRaster:
    movem.l d0-d2/a0,-(SP)

    move.l  #$1ff00,d2
    lsl.l   #8,d0
    and.l   d2,d0
    lea     $dff004,a0
.wr:
    move.l  (a0),d1
    and.l   d2,d1
    cmp.l   d1,d0
    bne.s   .wr

    movem.l (SP)+,d0-d2/a0
    rts

; -------------------------------------

wframe:
	btst #0,$dff005
	bne.b wframe
	cmp.b #$2a,$dff006      ; Spostato da 2a a c1 per dare aria al blitter
	bne.b wframe
wframe2:
	cmp.b #$2a,$dff006
	beq.b wframe2
    rts

INTERRUPT:
	btst.b	#5,$dff01f  ; Si deve testare se l'interrupt è arrivato davvero da un VERTB
                        ; Perché potrebbe essere lanciato anche da altri eventi
                        ; Controllo quindi il bit 5 di INTREQR, se è a 0 salto tutto
	beq.s	Novertb     
	
;	movem.l	d0-d7/a0-a6,-(sp)

;	lea	    $dff000,a6
;	bsr.w	P61_Music		

;	movem.l	(sp)+,d0-d7/a0-a6

Novertb:
	move.w	#%1110000,$dff09c
	rte

; *************** FINE ROUTINE UTILITY

gfxname:
    dc.b    "graphics.library",0


    SECTION Rana_data,DATA_C

    EVEN

Copper:
    dc.w    $1fc,0          ; slow fetch mode, per compatibilità con AGA
 
   ; DMA Display Window: Valori classici di Amiga, non overscan
   ; Ogni valore esadecimale corrisponde a 2 pixel, quindi ogni volta per esempio che riduciamo la finestra di 16 pixel dobbiamo togliere 8
   ; da $92 e $94

    dc.w $8e,$2c81      ; Display window start (top left) http://amiga-dev.wikidot.com/hardware:diwstrt
    dc.w $90,$2cc1      ; Display window stop (bottom right)
    dc.w $92,$38        ; Display data fetch start http://amiga-dev.wikidot.com/hardware:ddfstrt
    dc.w $94,$d0        ; Display data fetch stop

next_line_offset = background_margin*2

    dc.w    $108,next_line_offset+((40+next_line_offset)*4)          ; BPLxMOD: http://amiga-dev.wikidot.com/hardware:bplxmod  - Modulo interleaved
    dc.w    $10a,next_line_offset+((40+next_line_offset)*4)

    
; Palette
Palette:
	dc.w	$0180,$0000,$0182,$0aaa,$0184,$0e00,$0186,$0a00
	dc.w	$0188,$0d80,$018a,$0fe0,$018c,$08f0,$018e,$0080
	dc.w	$0190,$00b6,$0192,$00dd,$0194,$00af,$0196,$007c
	dc.w	$0198,$000f,$019a,$070f,$019c,$0c0e,$019e,$0c08
	dc.w	$01a0,$0620,$01a2,$0e52,$01a4,$0a52,$01a6,$0005
	dc.w	$01a8,$0038,$01aa,$007b,$01ac,$00dd,$01ae,$0333
	dc.w	$01b0,$0888,$01b2,$0ddd,$01b4,$0e52,$01b6,$0a30
	dc.w	$01b8,$0620,$01ba,$0080,$01bc,$03c0,$01be,$08f0

; dff120    SPR0PTH     Sprite 0 pointer, 5 bit alti
; dff122    SPR0PTL     Sprite 0 pointer, 15 bit bassi
; e così via per gli altri 7: http://amiga-dev.wikidot.com/hardware:sprxpth

; Sprite 0 proiettile astronave
; Sprite 4 e 5 proiettili nemici

	dc.w $120,0     ;0
	dc.w $122,0
	dc.w $124,0     ;1
	dc.w $126,0
	dc.w $128,0     ;2
	dc.w $12a,0
	dc.w $12c,0     ;3
	dc.w $12e,0
ExplosionSxSpritePointer:
	dc.w $130,0     ;4
	dc.w $132,0
ExplosionDxSpritePointer:
	dc.w $134,0     ;5
	dc.w $136,0
RanaSpritePointer:
	dc.w $138,0     ;6
	dc.w $13a,0
	dc.w $13c,0     ;7
	dc.w $13e,0



Bplpointers:
	dc.w	$e0,0,$e2,0
	dc.w	$e4,0,$e6,0
	dc.w	$e8,0,$ea,0
	dc.w	$ec,0,$ee,0
	dc.w	$f0,0,$f2,0

   dc.w    $100,$5200      ; move 5200 in dff100 (BPLCON0), le move instructions partono da 080, mettere dopo il setting del bitplane, ma a me non ha mai dato problemi
                            ; 0010100100000000


    ; Per finire la copperlist inseriamo un comando wait (fffe), se vogliamo aspettare la horizonal scanline AC e la posizione orizzontale 07
    ; dc.w    $ac07,$fffe     ; $fffe è la "maschera" che maschera l'ultimo bit meno significativo.
    ; per dire al copper che non ci sono più istruzioni in questo frame gli diamo una wait position impossibile
    dc.w    $ffff,$fffe

    EVEN


PaletteRaw:
	dc.w	$0000,$0ccc,$0999,$0666,$0222,$00e0,$00b0,$0070,$00d3,$00dd
	dc.w	$008c,$003b,$0009,$070f,$0c0e,$0c08,$0620,$0e52,$0a52,$0005
	dc.w	$0038,$007b,$00dd,$0333,$0888,$0ff0,$0e52,$0a30,$0620,$0080
	dc.w	$03c0,$08f0

FadeInFrame:
    dc.w    0

Bitplanes1:
    dcb.b   ((40+(background_margin*2))*256)*5,0

Bitplanes2:
    dcb.b   ((40+(background_margin*2))*256)*5,0

view_buffer:
	dc.l	Bitplanes1+background_margin	; buffer visualizzato
draw_buffer:
	dc.l	Bitplanes2+background_margin	; buffer di disegno

view_buffer_bob:							; Senza saltare il margine
	dc.l	Bitplanes1
draw_buffer_bob:
	dc.l	Bitplanes2						

; Background, immagine base 320x256
Background_nomargin:
    incbin "gfx/Background.raw"
;    incbin  "gfx/Colors.raw"

; Background con margini
Background:
	dcb.b   ((40+(background_margin*2))*256)*5,0





Digits:
    incbin "gfx/Digits.raw"
Life:
    incbin "gfx/Life.raw"


GameLevel:
    dc.w    1




Score:
    dc.w    0
ScoreStr:
    dcb.b   6,0

RanaX:
    dc.w    50
RanaY:
    dc.w    50

; 0: Up
; 1: Down
; 2: Left
; 3: Right
RanaOrientation:
	dc.w	0

; 0: Idle
; 1: Jumping
; 2: Exploding
; 3: Attached left
; 4: Attached Right
RanaState:
	dc.w	0
JumpFrame:
	dc.w	0


; AUDIO STUFF

Cra:
;    incbin  "sfx/cra.raw"
    incbin  "sfx/cra_11025.raw"

Boom:
	incbin	"sfx/Explosion.raw"	
Silent:
    dcb.w   100
SoundStarted:
    dc.w    0


Lifes:
    dc.w    3


; SPRITES:

; 16x12
RanaSpriteUpIdle:
	dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$e01c,$0000
	dc.w	$e79c,$0000
	dc.w	$c84c,$0780
	dc.w	$d4ac,$0fc0
	dc.w	$e01c,$1fe0
	dc.w	$6018,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$6018,$1fe0
	dc.w	$7038,$0fc0
	dc.w	$e79c,$0000
	dc.w	$e01c,$0000
	dc.w	$6018,$0000

	dc.w 0,0

; 16x15
RanaSpriteUpJumping:
    dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$e01c,$0000
	dc.w	$e01c,$0000
	dc.w	$c78c,$0000
	dc.w	$c84c,$0780
	dc.w	$d4ac,$0fc0
	dc.w	$e01c,$1fe0
	dc.w	$6018,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$7038,$0fc0
	dc.w	$77b8,$0000
	dc.w	$e01c,$0000
	dc.w	$e01c,$0000
	dc.w	$6018,$0000

    dc.w 0,0

; 16x12
RanaSpriteDownIdle:
    dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$6018,$0000
	dc.w	$e01c,$0000
	dc.w	$e79c,$0000
	dc.w	$7038,$0fc0
	dc.w	$6018,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$6018,$1fe0
	dc.w	$e01c,$1fe0
	dc.w	$d4ac,$0fc0
	dc.w	$c84c,$0780
	dc.w	$e79c,$0000
	dc.w	$e01c,$0000

    dc.w 0,0

; 16x15
RanaSpriteDownJumping:
    dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$6018,$0000
	dc.w	$e01c,$0000
	dc.w	$e01c,$0000
	dc.w	$77b8,$0000
	dc.w	$7038,$0fc0
	dc.w	$2010,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$6018,$1fe0
	dc.w	$e01c,$1fe0
	dc.w	$d4ac,$0fc0
	dc.w	$c84c,$0780
	dc.w	$c78c,$0000
	dc.w	$e01c,$0000
	dc.w	$e01c,$0000

    dc.w 0,0

; 16x14
RanaSpriteLeftIdle:
    dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$f860,$0000
	dc.w	$fdf0,$0000
	dc.w	$cff0,$0000
	dc.w	$1080,$0f00
	dc.w	$2000,$1f80
	dc.w	$5040,$3f80
	dc.w	$4040,$3f80
	dc.w	$4040,$3f80
	dc.w	$5040,$3f80
	dc.w	$2000,$1f80
	dc.w	$1080,$0f00
	dc.w	$cff0,$0000
	dc.w	$fdf0,$0000
	dc.w	$f860,$0000

    dc.w 0,0

; 16x14
RanaSpriteLeftJumping:
    dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$fc0c,$0000
	dc.w	$fe3e,$0000
	dc.w	$c7fe,$0000
	dc.w	$0830,$07c0
	dc.w	$1000,$0fe0
	dc.w	$2810,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$2010,$1fe0
	dc.w	$2810,$1fe0
	dc.w	$1000,$0fe0
	dc.w	$0830,$07c0
	dc.w	$c7fe,$0000
	dc.w	$fe3e,$0000
	dc.w	$fc0c,$0000

    dc.w 0,0

; 16x14
RanaSpriteRightIdle:
    dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$61f0,$0000
	dc.w	$fbf0,$0000
	dc.w	$ff30,$0000
	dc.w	$1080,$0f00
	dc.w	$0040,$1f80
	dc.w	$20a0,$1fc0
	dc.w	$2020,$1fc0
	dc.w	$2020,$1fc0
	dc.w	$20a0,$1fc0
	dc.w	$0040,$1f80
	dc.w	$1080,$0f00
	dc.w	$ff30,$0000
	dc.w	$fbf0,$0000
	dc.w	$61f0,$0000

    dc.w 0,0

; 16x14
RanaSpriteRightJumping:
    dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$607e,$0000
	dc.w	$f8fe,$0000
	dc.w	$ffc6,$0000
	dc.w	$1820,$07c0
	dc.w	$0010,$0fe0
	dc.w	$1028,$0ff0
	dc.w	$1008,$0ff0
	dc.w	$1008,$0ff0
	dc.w	$1028,$0ff0
	dc.w	$0010,$0fe0
	dc.w	$1820,$07c0
	dc.w	$ffc6,$0000
	dc.w	$f8fe,$0000
	dc.w	$607e,$0000

    dc.w 0,0

; Esplosione

	include	"gfx/ExplosionSprite.s"
	
ExplosionFrameList:
	dc.w	0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12,12,12,$ffff
ExplosionActualFrame:
	dc.w	0

RanaIdleFrames:
	dc.l	RanaSpriteUpIdle,RanaSpriteDownIdle,RanaSpriteLeftIdle,RanaSpriteRightIdle
RanaJumpingFrames:
	dc.l	RanaSpriteUpJumping,RanaSpriteDownJumping,RanaSpriteLeftJumping,RanaSpriteRightJumping
RanaIdleSpriteHeights:
	dc.w	12,12,14,14
RanaJumpingSpriteHeights:
	dc.w	15,15,14,14

; Bobs

Tronco1:
	incbin	"gfx/Tronco1.raw"
Tronco1_mask:
	incbin	"gfx/Tronco1_mask.raw"
Tronco2:
	incbin	"gfx/Tronco2.raw"
Tronco2_mask:
	incbin	"gfx/Tronco2_mask.raw"
AutoBlu:
	incbin	"gfx/AutoBlu.raw"
AutoBlu_mask:
	incbin	"gfx/AutoBlu_mask.raw"
Furgone:
	incbin	"gfx/Furgone.raw"
Furgone_mask:
	incbin	"gfx/Furgone_mask.raw"
Buggy:
	incbin	"gfx/Buggy.raw"
Buggy_mask:
	incbin	"gfx/Buggy_mask.raw"

; Tartaruga
Turtle:
	incbin	"gfx/Turtle1.raw"
	incbin	"gfx/Turtle2.raw"
	incbin	"gfx/Turtle3.raw"
	incbin	"gfx/Turtle4.raw"
	incbin	"gfx/Turtle5.raw"
	incbin	"gfx/Turtle6.raw"
	incbin	"gfx/Turtle_m2.raw"
	incbin	"gfx/Turtle_m3.raw

Turtle_mask:
	incbin	"gfx/Turtle1_mask.raw"
	incbin	"gfx/Turtle2_mask.raw"
	incbin	"gfx/Turtle3_mask.raw"
	incbin	"gfx/Turtle4_mask.raw"
	incbin	"gfx/Turtle5_mask.raw"
	incbin	"gfx/Turtle6_mask.raw"
	incbin	"gfx/Turtle_m2_mask.raw"
	incbin	"gfx/Turtle_m3_mask.raw

; Fotogrammi bob
SingleFrameList:
	dc.w	0,$ffff
TurtleFrameList:
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	7,7,7,7,7,7,7,7,7,7,7,7
	dc.w	7,7,7,7,7,7,7,7,7,7,7,7
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	2,2,2,2,2,2,2,2,2,2,2,2
	dc.w	3,3,3,3,3,3,3,3,3,3,3,3
	dc.w	4,4,4,4,4,4,4,4,4,4,4,4
	dc.w	5,5,5,5,5,5,5,5,5,5,5,5
	dc.w	5,5,5,5,5,5,5,5,5,5,5,5
	dc.w	5,5,5,5,5,5,5,5,5,5,5,5
	dc.w	4,4,4,4,4,4,4,4,4,4,4,4
	dc.w	3,3,3,3,3,3,3,3,3,3,3,3
	dc.w	2,2,2,2,2,2,2,2,2,2,2,2
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	$ffff


NormalTurtleFrameList:
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	7,7,7,7,7,7,7,7,7,7,7,7
	dc.w	7,7,7,7,7,7,7,7,7,7,7,7
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	6,6,6,6,6,6,6,6,6,6,6,6
	dc.w	$ffff

LivelloAttuale:
	dc.l	Livello1

	EVEN

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

; Ma se invece del contatore fotogramma ci mettessi l'indirizzo di una lista fotogrammi?

Livello1:

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	0				; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


	dc.l	Tronco2			; Indirizzo bob
	dc.l	Tronco2_mask	; Indirizzo bobmask
	dc.w	(96/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	64				; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	64+96+96		; x
	dc.w	50				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

; Riga 2

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	0				; x
	dc.w	70				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


	dc.l	Tronco2			; Indirizzo bob
	dc.l	Tronco2_mask	; Indirizzo bobmask
	dc.w	(96/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	64				; x
	dc.w	70				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	2				; Velocità
	dc.w	64+96+96		; x
	dc.w	70				; y
	dc.l	SingleFrameList	; Lista fotogrammi
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
	dc.w	30+64+96		; x
	dc.w	90				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Tronco1			; Indirizzo bob
	dc.l	Tronco1_mask	; Indirizzo bobmask
	dc.w	(64/16)			; Larghezza in word
	dc.w	1				; Velocità
	dc.w	30+64+96+96		; x
	dc.w	90				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

; Riga 4


; tartarughe

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	30		; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	30+36	; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	30+36+36	; x
	dc.w	110				; y
	dc.l	TurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale




	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	30+64+96+96		; x
	dc.w	110				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word;
	dc.w	-1				; Velocità
	dc.w	30+64+96+96+36	; x
	dc.w	110				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	Turtle			; Indirizzo bob
	dc.l	Turtle_mask		; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	30+64+96+96+36+36	; x
	dc.w	110				; y
	dc.l	NormalTurtleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale





; Riga 1 automobili

	dc.l	Furgone			; Indirizzo bob
	dc.l	Furgone_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	320				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoBlu			; Indirizzo bob
	dc.l	AutoBlu_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	160				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


	dc.l	Furgone			; Indirizzo bob
	dc.l	Furgone_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	100				; x
	dc.w	160				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoBlu			; Indirizzo bob
	dc.l	AutoBlu_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	50				; x
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

	dc.l	Furgone			; Indirizzo bob
	dc.l	Furgone_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	40				; x
	dc.w	210				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoBlu			; Indirizzo bob
	dc.l	AutoBlu_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	90				; x
	dc.w	210				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale


	dc.l	Furgone			; Indirizzo bob
	dc.l	Furgone_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	140				; x
	dc.w	210				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	AutoBlu			; Indirizzo bob
	dc.l	AutoBlu_mask	; Indirizzo bobmask
	dc.w	(48/16)			; Larghezza in word
	dc.w	-1				; Velocità
	dc.w	200				; x
	dc.w	210				; y
	dc.l	SingleFrameList	; Lista fotogrammi
	dc.w	0				; Fotogramma attuale

	dc.l	0

; Y rana
; Direction     (3 left, 4 right)
Directions:
    dc.w    114,3
    dc.w    93,4
    dc.w    72,4
    dc.w    51,4
    dc.w    $ffff

