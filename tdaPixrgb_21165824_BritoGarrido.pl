%TDA PIXRGB
:-module(tdaPixrgb_21165824_BritoGarrido, [pixrgb/7, getR/2, getG/2, getB/2, setrgb/5, pixrgb_to_pixhex/2, invertColorRGB/2]).
:- use_module(funcionesextra_21165824_BritoGarrido).
:- use_module(tdaPixhex_21165824_BritoGarrido).
%pixrgb
% Dominio: Posicion x(int) , Posicion y(int) , Canal R(int) , Canal G(int) , Canal B(int) ,profundidad
%Recorrido: [Posicion x, Posicion y, Canal R, Canal G, Canal B, profundidad]

pixrgb(X,Y,R,G,B,D,[X,Y,[R,G,B],D]):-
    integer(X),
    integer(Y),
    between(0,255,R),
    between(0,255,G),
    between(0,255,B),
    integer(D).

getR([_,_,[R,_,_],_] , R). %entrada: pixel

getG([_,_,[_,G,_],_] , G).

getB([_,_,[_,_,B],_] , B).

setrgb([X,Y,[_,_,_],D],NewR,NewG,NewB, [X,Y,[NewR,NewG,NewB],D]).

pixrgb_to_pixhex(Pixelin,Pixelout):-
    
    getx(Pixelin,X),
    gety(Pixelin,Y), 
    getD(Pixelin,D),
    getR(Pixelin,R),
    getG(Pixelin,G),
    getB(Pixelin,B),
    
    numtohex(R, RHex),
    numtohex(G, GHex),
    numtohex(B, BHex),
    
    string_concat('#',RHex, C1),
    string_concat(C1,GHex,C2),
    string_concat(C2,BHex,ColorHex),
    pixhex(X,Y,ColorHex,D,Pixelout).


%15) invertColorRGB
%Dominio: Pixel X pixel
%Descripcion: Deja un pixel de salida con el color simetricamente opuesto al de entrada
invertColorRGB(PixelIn, PixelOut):-
    getR(PixelIn,R),
    getG(PixelIn,G),
    getB(PixelIn,B),
    NewR is 255 - R,
    NewG is 255 - G,
    NewB is 255 - B,
    setrgb(PixelIn,NewR,NewG,NewB,PixelOut).