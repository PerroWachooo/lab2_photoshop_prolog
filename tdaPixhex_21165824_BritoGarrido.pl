%TDA PIXHex
:-module(tdaPixhex_21165824_BritoGarrido, [pixhex/5, sethex/3]).


%pixhex
%Entrada: Posicion x, Posicion y, Hex, profundidad
%Salida: [Posicion x, Posicion y, Hex, profundidad]

pixhex(X,Y,Hex,D,[X,Y,Hex,D]):-
    integer(X),
    integer(Y),
    string(Hex),
    integer(D).

sethex([X,Y,_,D], NewHex, [X,Y,NewHex,D]):-
    string(NewHex).


