PlayCra:
    lea     Cra,a0
    move.l  a0,$dff0d0      ; Sample in AUD3LC
    move.w  #3000,$dff0d4  ; Lunghezza in word in AUD3LEN
    move.w  #300,$dff0d6    ; Periodo in AUD3PER
    move.w  #64,$dff0d8     ; Volume massimo in AUD3VOL
    move.w  #%1000000000001000,$dff096      ; DMA audio 2 attivo in DMACON

    move.w  #1,SoundStarted
    rts

CheckSoundStop:
    tst.w   SoundStarted
    beq.s   .noclean

    lea     Silent,a0
    move.l  a0,$dff0d0
    move.w  #100,$dff0d4  ; Lunghezza in word in AUD2LEN

    move.w  #0,SoundStarted

.noclean:
    rts