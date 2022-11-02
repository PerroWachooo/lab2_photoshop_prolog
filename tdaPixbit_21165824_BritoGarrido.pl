%TDA PIXBIT
:-module(tdaPixbit_21165824_BritoGarrido, [pixbit/5,  setbit/3  ]).

%pixbit-d
%Entrada: Posicion x, Posicion y, Bit, profundidad
%Salida: [Posicion x, Posicion y, Bit, profundidad]

pixbit(X,Y,Bit,D,[X,Y,Bit,D]):-
    integer(X),
    integer(Y),
    Bit = 0 ; Bit = 1,
    integer(D).





setbit([X,Y,_,D], NewBit, [X,Y,NewBit,D]):-
    NewBit = 0 ; NewBit = 1.











    