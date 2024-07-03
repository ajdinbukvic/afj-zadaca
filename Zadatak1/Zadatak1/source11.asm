;automati i formalni jezici
;zadatak 1

;zaglavlje
option casemap:none			
externdef printf:proc
externdef asmScanf:proc
externdef atoi:proc
externdef convertToBinary:proc
public asmMain				

;segment konstanti
.const
    NULL            equ     0
	iNewLine	    equ	    10			
	iMaxLen		    equ	    256
    iMaxWord        equ     65535

;segment podataka
.data
    sPromptPrvi             byte    'Unesite prvi broj: ', NULL
    sPromptDrugi            byte    'Unesite drugi broj: ', NULL
    sPromptTreci            byte    'Unesite treci broj: ', NULL
    sNotNumErrMsg           byte    'Greska: Unesena vrijednost nije broj.', iNewLine, NULL
    sNotValidNumErrMsg      byte    'Greska: Unesena vrijednost ne moze biti veca od 65535', iNewLine, NULL
    sNotPositiveErrMsg      byte    'Greska: Unesena vrijednost mora biti pozitivan cijeli broj.', iNewLine, NULL
    sNejednakostErrMsg      byte    'Greska: Brojevi ne zadovoljavaju nejednakost trougla.', iNewLine, NULL
    sNejednakostSucMsg      byte    'Brojevi zadovoljavaju nejednakost trougla.', iNewLine, NULL
    sDec                    byte    'Decimalno: %d', iNewLine, NULL
    sBin                    byte    'Binarno: %s', iNewLine, NULL
    sHex                    byte    'Hexadecimalno: %X', iNewLine, NULL
    sInput			        byte	iMaxLen dup (?)
    buffer                  byte    17 dup (0)
    iPrvi                   word    ?
    iDrugi                  word    ?
    iTreci                  word    ?


;kodni segment
.code

; Glavna procedura

asmMain proc
    sub rsp, 56 

    ; Unos i provjera prvog broja
   
    input_loop_first:                   ; pocetak petlje za unos prvog broja
        lea rcx, sPromptPrvi            ; ucitavanje poruke za unos prvog broja
        call intScanf                   ; unos i konverzija vrijednosti s tastature
        cmp eax, 0                      ; provjera da li je unesena vrijednost pozitivan cijeli broj
        jle input_invalid_first         ; ako je unos pogresan prelazak na ispis poruke o gresci i vracanje na unos
        cmp rax, 65535                  ; provjera da li je uneseni broj manji od max vrijednosti
        jg size_error_first             ; ako je unos veci prelazak na ispis poruke o gresci i vracanje na unos
        mov iPrvi, ax                   ; spremanje unesene vrijednosti u iPrvi

    ; Unos i provjera drugog broja

    input_loop_second:                  ; pocetak petlje za unos drugog broja
        lea rcx, sPromptDrugi           ; ucitavanje poruke za unos drugog broja
        call intScanf                   ; unos i konverzija vrijednosti s tastature
        cmp eax, 0                      ; provjera da li je unesena vrijednost pozitivan cijeli broj
        jle input_invalid_second        ; ako je unos pogresan prelazak na ispis poruke o gresci i vracanje na unos
        cmp rax, 65535                  ; provjera da li je uneseni broj manji od max vrijednosti
        jg size_error_second            ; ako je unos veci prelazak na ispis poruke o gresci i vracanje na unos
        mov iDrugi, ax                  ; spremanje unesene vrijednosti u iDrugi

    ; Unos i provjera treceg broja

    input_loop_third:                   ; pocetak petlje za unos treceg broja
        lea rcx, sPromptTreci           ; ucitavanje poruke za unos treceg broja
        call intScanf                   ; unos i konverzija vrijednosti s tastature
        cmp eax, 0                      ; provjera da li je unesena vrijednost pozitivan cijeli broj
        jle input_invalid_third         ; ako je unos pogresan prelazak na ispis poruke o gresci i vracanje na unos
        cmp rax, 65535                  ; provjera da li je uneseni broj manji od max vrijednosti
        jg size_error_third             ; ako je unos veci prelazak na ispis poruke o gresci i vracanje na unos
        mov iTreci, ax                  ; spremanje unesene vrijednosti u iTreci

    ; Ispis prvog broja u decimalnom, hexadecimalnom i binarnom obliku

    ; Decimalni

    movzx rdx, iPrvi                    
    lea rcx, sDec                       
    call printf

    ; Heksadecimalni

    movzx rdx, iPrvi
    lea rcx, sHex
    call printf

    ; Binarni
    ; NAPOMENA: ovaj kod je preuzet s interneta i modifikovan prema potrebama zadatka

    movzx edx, word ptr [iPrvi]  
    lea rcx, [buffer]     
    mov r8d, 17  
    call convertToBinary 
    lea rcx, [sBin]
    lea rdx, [buffer]
    call printf

    ; Ispis drugog broja u decimalnom, hexadecimalnom i binarnom obliku

    ; Decimalni

    movzx rdx, iDrugi
    lea rcx, sDec
    call printf

    ; Heksadecimalni

    movzx rdx, iDrugi
    lea rcx, sHex
    call printf

    ; Binarni
    ; NAPOMENA: ovaj kod je preuzet s interneta i modifikovan prema potrebama zadatka

    movzx edx, word ptr [iDrugi] 
    lea rcx, [buffer]
    mov r8d, 17 
    call convertToBinary
    lea rcx, [sBin]
    lea rdx, [buffer]
    call printf

    ; Ispis treceg broja u decimalnom, hexadecimalnom i binarnom obliku

    ; Decimalni

    movzx rdx, iTreci
    lea rcx, sDec
    call printf

    ; Heksadecimalni

    movzx rdx, iTreci
    lea rcx, sHex
    call printf

    ; Binarni
    ; NAPOMENA: ovaj kod je preuzet s interneta i modifikovan prema potrebama zadatka

    movzx edx, word ptr [iTreci]
    lea rcx, [buffer]
    mov r8d, 17
    call convertToBinary
    lea rcx, [sBin]
    lea rdx, [buffer]
    call printf

    ; Provjera za nejednakost trougla

    ; Prvi slucaj a + b > c

    movzx rax, iPrvi                    ; ucitavanje spremljene vrijednosti za prvi broj
    movzx rbx, iDrugi                   ; ucitavanje spremljene vrijednosti za drugi broj
    add rax, rbx                        ; sabiranje vrijednosti prvog i drugog broja
    movzx rcx, iTreci                   ; ucitavanje spremljene vrijednosti za treci broj
    cmp rax, rcx                        ; poredjenje zbira prvog i drugog broja s trecim brojem
    jle triangle_inequality_fail        ; prelazak na ispis poruke ako uvjet za nejednakost trougla nije zadovoljen

    ; Drugi slucaj a + c > b

    movzx rax, iPrvi                    ; ucitavanje spremljene vrijednosti za prvi broj
    movzx rcx, iTreci                   ; ucitavanje spremljene vrijednosti za treci broj
    add rax, rcx                        ; sabiranje vrijednosti prvog i treceg broja
    movzx rbx, iDrugi                   ; ucitavanje spremljene vrijednosti za drugi broj
    cmp rax, rbx                        ; poredjenje zbira prvog i treceg broja s drugim brojem
    jle triangle_inequality_fail        ; prelazak na ispis poruke ako uvjet za nejednakost trougla nije zadovoljen

    ; Treci slucaj b + c > a

    movzx rax, iDrugi                   ; ucitavanje spremljene vrijednosti za drugi broj
    movzx rbx, iTreci                   ; ucitavanje spremljene vrijednosti za treci broj
    add rax, rbx                        ; sabiranje vrijednosti drugog i treceg broja
    movzx rcx, iPrvi                    ; ucitavanje spremljene vrijednosti za prvi broj
    cmp rax, rcx                        ; poredjenje zbira drugog i treceg broja s prvim brojem
    jle triangle_inequality_fail        ; prelazak na ispis poruke ako uvjet za nejednakost trougla nije zadovoljen

    ; Ispis poruke ako je ispunjena nejednakost trougla
    lea rcx, sNejednakostSucMsg
    call printf
    jmp end_proc

; Ispis poruke ako nije ispunjena nejednakost trougla

triangle_inequality_fail:
    lea rcx, sNejednakostErrMsg
    call printf
    jmp end_proc

end_proc:
    add rsp, 56
    ret

; Ispis poruke za pogresno unesen ili negativan prvi broj i povratak na novi unos

input_invalid_first:
    lea rcx, sNotPositiveErrMsg
    call printf
    call clearInputBuffer
    jmp input_loop_first

; Ispis poruke za pogresno unesen ili negativan drugi broj i povratak na novi unos

input_invalid_second:
    lea rcx, sNotPositiveErrMsg
    call printf
    call clearInputBuffer
    jmp input_loop_second

; Ispis poruke za pogresno unesen ili negativan treci broj i povratak na novi unos

input_invalid_third:
    lea rcx, sNotPositiveErrMsg
    call printf
    call clearInputBuffer
    jmp input_loop_third

; Ispis poruke za unesen prvi broj veci od dozvoljenog i povratak na novi unos

size_error_first:
    lea rcx, sNotValidNumErrMsg
    call printf
    call clearInputBuffer
    jmp input_loop_first

; Ispis poruke za unesen drugi broj veci od dozvoljenog i povratak na novi unos

size_error_second:
    lea rcx, sNotValidNumErrMsg
    call printf
    call clearInputBuffer
    jmp input_loop_second

; Ispis poruke za unesen treci broj veci od dozvoljenog i povratak na novi unos

size_error_third:
    lea rcx, sNotValidNumErrMsg
    call printf
    call clearInputBuffer
    jmp input_loop_third


asmMain endp

; Procedura za unos s konzole i pretvaranje vrijednosti u cijeli broj

intScanf		proc
				sub		rsp, 56
				call	printf
				lea		rcx, sInput
				mov		rdx, iMaxLen
				call	asmScanf
				lea		rcx, sInput
				call	atoi
                add		rsp, 56
                ret
intScanf		endp

; Procedura za ciscenje buffera za unos

clearInputBuffer proc
    mov rax, 0
    mov edx, iMaxLen
    lea rcx, sInput
    ret
clearInputBuffer endp

; Procedura za ispis broja u binarnom zapisu
; NAPOMENA: ovaj kod je preuzet s interneta i modifikovan prema potrebama zadatka

printf_buffer proc
    push rbx
    push rcx
    push rdx

    lea rcx, buffer    
    call printf        

    pop rdx
    pop rcx
    pop rbx

    ret
printf_buffer endp

end