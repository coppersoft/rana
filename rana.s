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


    ; Setto lo spritepointer (dff120) nello stesso modo fatto per i bitplane

;    lea     ShipBulletSpritePointer,a0
;    move.l  #ShipBulletSprite,d0

;    move.w  d0,6(a0)
;    swap    d0
;    move.w  d0,2(a0)

    ; Setto la copperlist

    move.l  #Copper,$dff080     ; http://amiga-dev.wikidot.com/hardware:cop1lch  (Copper pointer register) E' un long word move perché il registro è una long word

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

; Stabilisco il livello di difficoltà

; TODO

.iniziogioco

    bsr.w   CopiaSfondo
;    bsr.w   ShowLifes

;    bsr.w   DrawScore

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




    bsr.w   SwitchBuffers
    bsr.w   wframe






    btst    #6,$bfe001
    bne     mainloop

;    bsr.w   P61_End

    rts
; ===== FINE LOOP PRINCIPALE




; Includo funzioni utility per blitter, sprite, collisioni, conversioni e player musicale
    include "functions/blitter.s"
    include "functions/sprite.s"
    include "functions/utils.s"
    include "music/P6112-Play.s"

; *************** INIZIO ROUTINE UTILITY




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

    dc.w    $108,4+(44*4)          ; BPLxMOD: http://amiga-dev.wikidot.com/hardware:bplxmod  - Modulo interleaved
    dc.w    $10a,4+(44*4)


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
	dc.w $130,0     ;4
	dc.w $132,0
	dc.w $134,0     ;5
	dc.w $136,0
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
	dc.w	$0000,$0aaa,$0e00,$0a00,$0d80,$0fe0,$08f0,$0080,$00b6,$00dd
	dc.w	$00af,$007c,$000f,$070f,$0c0e,$0c08,$0620,$0e52,$0a52,$0005
	dc.w	$0038,$007b,$00dd,$0333,$0888,$0ddd,$0e52,$0a30,$0620,$0080
	dc.w	$03c0,$08f0

FadeInFrame:
    dc.w    0

Bitplanes1:
    dcb.b   (44*256)*5,0
Bitplanes2:
    dcb.b   (44*256)*5,0

view_buffer:
	dc.l	Bitplanes1	; buffer visualizzato
draw_buffer:
	dc.l	Bitplanes2	; buffer di disegno

Background:
    incbin "gfx/Background.raw"

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






Lifes:
    dc.w    3


; SPRITES:

ShipBulletSprite:
	dc.w    $0,$0	;Vstart.b,Hstart/2.b,Vstop.b,%A0000SEH

	dc.w	$6000,$6000
	dc.w	$f000,$f000
	dc.w	$9000,$f000
	dc.w	$0000,$f000
	dc.w	$0000,$6000
	dc.w	$6000,$0000
	dc.w	$6000,$0000

	dc.w 0,0

