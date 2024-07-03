;automati i formalni jezici
;zadatak 3

;zaglavlje
option casemap:none			
externdef printf:proc
externdef scanf:proc
externdef asmScanf:proc
public asmMain				

;segment konstanti
.const
	NULL            equ     0
	iNewLine	    equ	    10			
	iMaxLen		    equ	    256
    iNula           equ     0	

;segment podataka
.data
    sInput1             byte        'Unesite prvi realni broj: ', NULL
    sInput2             byte        'Unesite drugi realni broj: ', NULL
    sFormatInput        byte        '%f', NULL
    sFormatBin          byte        'Binarn oblik: %s', iNewLine, NULL
    sFormatDec          byte        'Decimalni oblik: %f', iNewLine, NULL
    sFormatDec2         byte        'Broj decimalno je: %lf', iNewLine, NULL
    sZbirDec            byte        'Zbir decimalno je: %lf', iNewLine, NULL
    sZbirBin            byte        'Zbir binarno je: %lf', iNewLine, NULL
    sRazlikaBin         byte        'Razlika decimalno je: %lf', iNewLine, NULL
    sRazlikaDec         byte        'Razlika decimalno je: %lf', iNewLine, NULL
    sDebugMsg           byte        'Debug: ', NULL
    dPrvi               real8        5.7
    dDrugi              real8        3.2
    fNum1               real4        ?
    fNum2               real4        ?
    newLine             byte         0Ah, 0
    sBuffer             byte         33 dup (?)

; -----------------------------------------------------------
; NAPOMENA
; -----------------------------------------------------------
; Nakon visesatnog rada i istrazivanja zadatak nije u potpunosti uradjen
; Problem koji je ostao nerijesen je citanje realnih broja s konzole
; Nefunkcionalni dio koda je ostavljen kao primjer (kada se unese broj ispise vrijednost: 0.0)
; Ostatak zadatka je uradjen koristenjem unaprijed definisanih vrijednosti za dva broja
; -----------------------------------------------------------

;kodni segment
.code

; glavna procedura
asmMain proc
    sub rsp, 56

    ; Unos prvog broja
    lea rcx, sInput1
    call printf
    lea rcx, sFormatInput
    lea rdx, fNum1                ; Adresa za unos prvog broja
    call scanf

    ; Ucitavanje prvog broja u xmm registar
    ;movss xmm0, dword ptr fNum1

    ; Debug ispis unesenog prvog broja
    lea rcx, sDebugMsg
    call printf
    lea rcx, sFormatDec
    movss xmm0, dword ptr [fNum1]
    movss dword ptr [rsp], xmm0
    mov rdx, rsp
    call printf
    lea rcx, newLine
    call printf

    ; Unos drugog broja
    lea rcx, sInput2
    call printf
    lea rcx, sFormatInput
    lea rdx, fNum2                ; Adresa za unos drugog broja
    call scanf

    ; Ucitavanje drugog broja u xmm registar
    ;movss xmm1, dword ptr fNum2

    ; Debug ispis unesenog drugog broja
    lea rcx, sDebugMsg
    call printf
    lea rcx, sFormatDec
    movss xmm0, dword ptr [fNum1]
    movss dword ptr [rsp], xmm0
    mov rdx, rsp
    call printf
    lea rcx, newLine
    call printf
    
    ; Ispis kodirane vrijednosti za prvi broj (decimalni oblik)
    movsd xmm1, [dPrvi]
    mov rdx, [dPrvi]
    lea rcx, sFormatDec2
    call printf

    ; Ispisivanje binarnog oblika prvog broja
    movsd xmm2, qword ptr [dPrvi]   ; Ucitavanje double broja dPrvi u xmm2
    call floatToBin                 ; poziv procedure za konverziju broja u binarni oblik
    lea rcx, sBuffer
    lea rdx, sFormatBin
    call printf

    ; Ispis kodirane vrijednosti za drugi broj (decimalni oblik)
    movsd xmm1, [dDrugi]
    mov rdx, [dDrugi]
    lea rcx, sFormatDec2 
    call printf

    ; Ispisivanje binarnog oblika drugog broja
    movsd xmm2, qword ptr [dDrugi]  ; Ucitavanje double broja dDrugi u xmm2
    call floatToBin                 ; poziv procedure za konverziju broja u binarni oblik
    lea rcx, sBuffer
    lea rdx, sFormatBin
    call printf

    ; Izracunaj zbir
    movsd xmm0, qword ptr [dPrvi]   ; Ucitava dPrvi u xmm0
    addsd xmm0, qword ptr [dDrugi]  ; Dodaje dDrugi u xmm0 za zbir

    ; Ispis zbira
    lea rcx, sZbirDec     
    movq rdx, xmm0          
    call printf           

    ; Ispis binarnog zbira
    call floatToBin                 ; Poziv procedure za konverziju broja u binarni oblik
    lea rcx, sBuffer        
    lea rdx, sZbirBin  
    call printf             

    ; Izracunaj razliku
    movsd xmm0, qword ptr [dPrvi]   ; Ucitaj dPrvi u xmm0
    subsd xmm0, qword ptr [dDrugi]  ; Oduzmi dDrugi od dPrvi u xmm0 za razliku

    ; Ispis razlike
    lea rcx, sRazlikaDec 
    movq rdx, xmm0          
    call printf             

    ; Ispis binarne razlike
    call floatToBin         ; Poziv procedure za konverziju broja u binarni oblik
    lea rcx, sBuffer        
    lea rdx, sRazlikaBin  
    call printf             


    add rsp, 56
    ret
asmMain endp

; procedura za konverziju broja u binarni oblik
; NAPOMENA: ova procedura je preuzeta s interneta i modifikovana prema potrebama zadatka
; Ispis brojeva i zbira/razlike u binarnom obliku je izostavljen
floatToBin proc
    
    movd eax, xmm2                  ; Premjestanje bitova iz xmm2 u eax
    lea rdi, sBuffer + 32           ; Pocetak punjenja niza s kraja
    mov byte ptr [rdi], 0           ; Zavrsni NULL karakter
    std                             ; Postavljanje DF (Direction Flag)

    mov ecx, 32                     ; 32 bita za konverziju
convert_loop:
    shr eax, 1                      ; Desni pomak bitova u eax
    adc al, 48                      ; Dodavanje ASCII vrijednosti '0'
    stosb                           ; Spremanje rezultata u buffer za binarni ispis
    loop convert_loop

    cld                             ; ciscenje DF (Direction Flag)
    ret
floatToBin endp

end