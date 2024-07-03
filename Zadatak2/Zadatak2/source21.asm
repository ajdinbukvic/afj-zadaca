;automati i formalni jezici
;zadatak 2

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
    sPrompt1    byte   'Unesite prvi string: ', NULL
    sPrompt2    byte   'Unesite drugi string: ', NULL
    sIspis1		byte   'Uneseni prvi string je: ', '%s', iNewLine, NULL
    sIspis2		byte   'Uneseni drugi string je: ', '%s', iNewLine, NULL
    sPromjena1	byte   'Prvi string nakon promjene slova: ', '%s', iNewLine, NULL
    sPromjena2	byte   'Drugi string nakon promjene slova: ', '%s', iNewLine, NULL
    sFormat	    byte   '%256[^', iNewLine, ']%*c', NULL
    sTekst1     byte   iMaxLen dup (?) ; Buffer za prvi string
    sTekst2     byte   iMaxLen dup (?) ; Buffer za drugi string

;kodni segment
.code

; Glavna procedura

asmMain proc
    sub rsp, 56

    ; Unos prvog stringa
    lea rcx, sPrompt1
    call printf
    mov sTekst1, iNula
    lea rcx, sFormat
    lea rdx, sTekst1
    call scanf

    ; Unos drugog stringa
    lea rcx, sPrompt2
    call printf
    mov sTekst2, iNula
    lea rcx, sFormat
    lea rdx, sTekst2
    call scanf

    ; Ispis unesenog prvog strina
    lea	rcx, sIspis1
    lea rdx, sTekst1
    call printf

    ; Ispis unesenog drugog strina
    lea	rcx, sIspis2
    lea rdx, sTekst2
    call printf

    ; Zamjena velikih i malih slova i ispis modifikovanog prvog stringa
    lea rcx, sTekst1
    call swapLetters            ; poziv procedure za zamjenu velikih i malih slova
    lea	rcx, sPromjena1
    lea rdx, sTekst1
    call printf

    ; Zamjena velikih i malih slova i ispis modifikovanog drugog stringa
    lea rcx, sTekst2
    call swapLetters            ; poziv procedure za zamjenu velikih i malih slova
    lea	rcx, sPromjena2
    lea rdx, sTekst2
    call printf

    add rsp, 56
    ret
asmMain endp

; Procedura za zamjenu velikih i malih slova

swapLetters proc
    mov rax, rcx                ; Ucitavanje adrese stringa u rax
swapLoop:
    movzx edx, byte ptr [rax]   ; Ucitavanje bajta iz memorije u edx
    test dl, dl                 ; Provjera da li je kraj stringa (dl = 0)
    jz swapDone                 ; Ako je kraj stringa, završi petlju

    ; Provjera da li je slovo ('A' do 'Z')
    cmp dl, 'A'
    jb notLetter                ; Preskoci ako nije slovo
    cmp dl, 'z'
    jbe convertLetter           ; Ako je slovo malo, konvertuj u veliko

    ; Provjera da li je slovo ('a' do 'z')
    cmp dl, 'a'
    jb notLetter                ; Preskoci ako nije slovo
    cmp dl, 'Z'
    jbe convertLetter           ; Ako je slovo veliko, konvertuj u malo

; Preskoci ako nije slovo
notLetter:
    inc rax                     ; Predjii na sljedeci karakter
    jmp swapLoop                ; Ponovi petlju

; Zamjena bita na 5. tezinskoj poziciji u ASCII kodu
; Velika i mala slova se razlikuju na toj poziciji (kod velikog je 0, a kod malog 1)
convertLetter:
    xor dl, 20h                 ; Invertuj 5. bit koristeci XOR sa 20h (32 decimalno - 2^5)
    mov [rax], dl               ; Sacuvaj modifikovanu vrijednost nazad u memoriju
    inc rax                     ; Predji na sljedeci karakter
    jmp swapLoop                ; Ponovi petlju

; Kraj petlje kada se dodje do zadnjeg (nul-terminiranog = 0) karaktera
swapDone:
    ret
swapLetters endp

end
