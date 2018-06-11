;##############################################################################################
; TEMAT:
;Program odwracaj¹cy kolejnoœæ wyrazów we wprowadzonym tekœcie. Tekst wprowadzamy
;z klawiatury. Je¿eli wyrazy zosta³y odwrócone, to zapali siê zielone œwiat³o na sygnalizatorze.
;Je¿eli nie mo¿na odwróciæ tekstu, bo nie ma separatorów, to zapali siê czerwone œwiat³o.

; OPIS: 
;- Separatorem jest odstêp (SPACE)
;- Do programu mozemy wprowadzic max. 62 znaki
;##############################################################################################


; USTAWIENIE POCZATKOWYCH WARTOSCI
mov dl,80	; miejsca, gdzie sciagane beda litery ze stosu
mov cl,C0	; poczatek wyswietlacza
mov bl,0D	; wstawia znak enter na poczatek stosu
push bl		; wepchniecie na stos
mov bl,00	; wyzerowanie rejestru bl


;---------------------------------------------------------------------------------------
;ETAP 1 WPROWADZANIE zdania do stosu ; ENTER konczy wprowadzanie
etap1:
in 00		; wczytanie z klawiatury do rejestru al
CMP AL,0D	; sprawdzenie czy w rejestrze AL znajduje sie kod ASCII odpowiadajacy ENTEROWI
JZ etap2	; jesli wcisniemy ENTER przejdziemy do nastepnego etapu

push al		; Jesli podany znak nie jest enterem, to dodajemy go do stosu
JMP etap1	; Wracamy do poczatku etapu 1.
;---------------------------------------------------------------------------------------


;---------------------------------------------------------------------------------------
;ETAP 2 SZUKANIE poczatku wyrazu od gory stosu (az znajdzie spacje lub poczatkek stosu)
etap2:
call 6b		; reset flag
pop al

cmp al,0D	; jesli wczyta enter, oznacza to znalezienie konca stosu
jz etap4	; skacze na koncowa petle, ktora wypisze ostatnie slowo i skonczy program

cmp al,20	; jesli wczyta spacje, oznacza to znalezienie poczatku wyrazu
mov [dl],al 	; sciagniecie ze stosu na miejsce o adresie w DL
jz etap3	;

mov [dl],al 	; porownywany wczesniej znak zapisujemy na zaimplementowanym stosie;
inc dl 


jnz etap2	; Jesli wczytany znak nie jest spacja ani enterem, wczytujemy kolejny;
;---------------------------------------------------------------------------------------








;---------------------------------------------------------------------------------------
; ETAP 3 znalezienie spacji na stosie i przepisywanie wyrazu z pomocniczego stosu na wyswietlacz
etap3:
call 72		; ustawienie flagi 'znalezionej spacji' w rejestrze BL
call 6b		; reset flag

etap3petla:

mov al, [dl]	; przeniesienie wartosci z rejestru DL na wyswietlacz;
mov [cl], al	

inc cl

cmp dl,80 	; jesli adres cofnal sie do 80 ( czyli przepisal caly wyraz) ustawia flage Z
jz etap2
dec dl		; jesli nie lecimy dalej z petla;
jnz etap3
;---------------------------------------------------------------------------------------


;---------------------------------------------------------------------------------------
; ETAP 4 wypisanie ostatniego slowa i zakonczenie programu
etap4:

call 6b		; reset flag

cmp bl,0	; Sprawdza, czy separator nie wystapil;
jz brakseparatora; skacze jesli separator niewysapil
mov al,20 	; dodaje spacje przed wypisaniem ostatniego slowa; 
mov [dl],al

etap4petla:

mov al, [dl]	; wypisanie ostatniego wyrazu na wyswietlacz
mov [cl], al

inc cl;

cmp dl,80 	; jesli adres cofnal sie do 80 ( czyli przepisal caly wyraz) ustawia flage Z

jz szczesliwykoniec;

dec dl;
jnz etap4petla;
;---------------------------------------------------------------------------------------








; Jesli separator nie zostal znaleziony wyswietla czerwone swiatla na sygnalizacji swietlnej
;..............
brakseparatora:  
mov al,93;
out 01;
jmp koniec;
;..............



ORG 6b; RESET FLAG
mov al,0;
push al;
popf;
ret;

ORG 72; USTAWIENIE WLASNEJ "FLAGI"
mov bl,1;
ret;


; Jesli wpisane znaki byly zdaniem i udalo sie zamienic slowa, wyswietla zielone swiatla na sygnalizacji swietlnej
;..............
szczesliwykoniec:
mov al,27;
out 01;
koniec:
end;
;..............