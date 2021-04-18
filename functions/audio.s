PlayCra:

    ; Eventualmente, se si vuole fermare un suono prima che abbia finito fermare
    ; il DMA del canale
    move.w  #%0000000000001000,$dff096      ; DMA audio 3 inattivo in DMACON

    bsr.w   waitabit

    lea     Cra,a0
    move.l  a0,$dff0d0      ; Sample in AUD3LC
    move.w  #3000,$dff0d4  ; Lunghezza in word in AUD3LEN
    move.w  #300,$dff0d6    ; Periodo in AUD3PER
    move.w  #64,$dff0d8     ; Volume massimo in AUD3VOL
    move.w  #%1000000000001000,$dff096      ; DMA audio 3 attivo in DMACON

    move.w  #1,SoundStarted
    rts


PlayBoom:

    ; Eventualmente, se si vuole fermare un suono prima che abbia finito fermare
    ; il DMA del canale
    move.w  #%0000000000001000,$dff096      ; DMA audio 3 inattivo in DMACON

    bsr.w   waitabit

    lea     Boom,a0
    move.l  a0,$dff0d0      ; Sample in AUD3LC
    move.w  #4000,$dff0d4  ; Lunghezza in word in AUD3LEN
    move.w  #400,$dff0d6    ; Periodo in AUD3PER
    move.w  #64,$dff0d8     ; Volume massimo in AUD3VOL
    move.w  #%1000000000001000,$dff096      ; DMA audio 3 attivo in DMACON

    move.w  #1,SoundStarted
    rts


PlayWin:

    ; Eventualmente, se si vuole fermare un suono prima che abbia finito fermare
    ; il DMA del canale
    move.w  #%0000000000001000,$dff096      ; DMA audio 3 inattivo in DMACON

    bsr.w   waitabit

    lea     Win,a0
    move.l  a0,$dff0d0      ; Sample in AUD3LC
    move.w  #22154,$dff0d4  ; Lunghezza in word in AUD3LEN
    move.w  #300,$dff0d6    ; Periodo in AUD3PER
    move.w  #64,$dff0d8     ; Volume massimo in AUD3VOL
    move.w  #%1000000000001000,$dff096      ; DMA audio 3 attivo in DMACON

    move.w  #1,SoundStarted
    rts

CheckSoundStop:
    tst.w   SoundStarted
    beq.s   .noclean

    lea     Silent,a0
    move.l  a0,$dff0d0
    move.w  #16,$dff0d4  ; Lunghezza in word in AUD2LEN

    move.w  #0,SoundStarted

.noclean:
    rts

waitabit:
    move.w  #100,d0
.lop
    dbra    d0,.lop
    rts
