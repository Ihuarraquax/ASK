; USTAWIENIE POCZATKOWYCH WARTOSCI
mov dl,90; miejsca, gdzie sciagane beda litery ze stosu
mov cl,C0; poczatek wyswietlacza




; WPROWADZANIE zdania do stosu ; ENTER konczy wprowadzanie
etap1:
in 00;
CMP AL,0D;
JZ etap2;





push al;
JMP etap1;

; SZUKANIE poczatku wyrazu od gory stosu (az znajdzie spacje lub poczatkek stosu)
etap2:
call 30; reset flag
pop al;
mov [dl],al ; sciagniecie ze stosu na miejsce o adresie w DL
inc dl;
cmp al,20;
jz etap3;
jnz etap2;










; ETAP 3 znalezienie spacji na stosie i przepisywanie wyrazu z pomocniczego stosu na wyswietlacz
etap3:;
call 30; reset flag
cmp dl,80 ; jesli adres cofnal sie do 80 ( czyli przepisal caly wyraz) ustawia flage Z
mov al, [dl]
mov [cl], al;








ORG 30; RESET FLAG
mov al,0;
push al;
popf;
ret;

end;