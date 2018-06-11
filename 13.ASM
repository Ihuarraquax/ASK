; USTAWIENIE POCZATKOWYCH WARTOSCI
mov dl,90; miejsca, gdzie sciagane beda litery ze stosu
mov cl,C0; poczatek wyswietlacza
mov bl,0D; wstawia znak enter na poczatek stosu
push bl;



; WPROWADZANIE zdania do stosu ; ENTER konczy wprowadzanie
etap1:
in 00;
CMP AL,0D;
JZ etap2; jesli wcisniemy ENTER przejdziemy do nastepnego etapu





push al;
JMP etap1;

; SZUKANIE poczatku wyrazu od gory stosu (az znajdzie spacje lub poczatkek stosu)
etap2:
call 80; reset flag
pop al;

cmp al,0D; jesli wczyta enter, oznacza to znalezienie konca stosu
jz etap4; skacze na koncowa petle, ktora wypisze ostatnie slowo i skonczy program

cmp al,20;
mov [dl],al ; sciagniecie ze stosu na miejsce o adresie w DL
jz etap3;

mov [dl],al ; sciagniecie ze stosu na miejsce o adresie w DL
inc dl;

jnz etap2;










; ETAP 3 znalezienie spacji/entera na stosie i przepisywanie wyrazu z pomocniczego stosu na wyswietlacz
etap3:;

call 80; reset flag



mov al, [dl];
mov [cl], al;

inc cl;


cmp dl,90 ; jesli adres cofnal sie do 80 ( czyli przepisal caly wyraz) ustawia flage Z
jz etap2;
dec dl;
jnz etap3;




; ETAP 4;
etap4:
mov al,20
mov [dl],al;

etap4petla:
call 80; reset flag



mov al, [dl];
mov [cl], al;

inc cl;


cmp dl,90 ; jesli adres cofnal sie do 80 ( czyli przepisal caly wyraz) ustawia flage Z
jz koniec;
dec dl;
jnz etap4petla;















ORG 80; RESET FLAG
mov al,0;
push al;
popf;
ret;

koniec:
end;