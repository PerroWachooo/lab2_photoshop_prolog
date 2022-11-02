:-module(funcionesextra_21165824_BritoGarrido, [getx/2, gety/2, getColor/2, getD/2, setx/3, sety/3,setD/3, pixelFlipH/3, pixelFlipV/3, cambio_cords_crop/4, dentro_de_margen/5, rotatepixel/3, isSameCord/3,  isSameD/2, numtohex/2,isSameColor/2]).

getx([X|_], X).

gety([_,Y|_], Y).

getColor([_,_,Color,_],Color).

getD([_,_,_,D],D).

setx([_|T], NewX, [NewX|T]):-
    integer(NewX).

sety([X,_|T], NewY, [X,NewY|T]):-
    integer(NewY).

setD([X,Y,Color,_],NewD, [X,Y,Color,NewD]):-
    integer(NewD).

pixelFlipH(Alto, [X,Y|T] ,[X,NewY|T]):-
    NewY is (Alto-1)-Y.

pixelFlipV(Ancho, [X,Y|T] ,[NewX,Y|T]):-
    NewX is (Ancho-1)-X.

cambio_cords_crop(Xmin,Ymin,Pixelin,Pixelout):-
        getx(Pixelin,X),
        gety(Pixelin,Y),
        NewX is X-Xmin,
        NewY is Y-Ymin,
    	setx(Pixelin, NewX, P1),
    	sety(P1,NewY, Pixelout).
        
       
dentro_de_margen(Xmin,Xmax,Ymin,Ymax,Pixel):-
    getx(Pixel,X),
    gety(Pixel,Y),
    (X>=Xmin, X=<Xmax),
    (Y >= Ymin, Y =< Ymax).

%rotatepixel
%Dominio: AltoImagen X Pixel X Pixel
%Descripcion: rota la cordenada del pixel en 90 grados hacia la derecha, manteniendo los demas valores
%la nueva cordenada x es la cord y inicial, la nueva cordenada y es(AltoImagen-1)-Xinicial,

rotatepixel(AltoImagen,Pixelin,PixelOut):-
    getx(Pixelin,X),
    gety(Pixelin,Y),
    NewX is Y,
    NewY is AltoImagen - 1 - X,
    setx(Pixelin, NewX, Pixelmod),
    sety(Pixelmod, NewY, PixelOut).

%isSameCord
%Dominio: CordenadaX x CordenadaY x Pixel
%Descripción: Arroja true si las cordenadas del pixel coincide con las cordenadas entregadas

isSameCord(X,Y,[X,Y,_,_]).


%isSameD (se usa en imageDepthLayers)
%Dominio: Profundidad X Pixel
%Descripicon: da true si la profundidad del pixel es igual a la entregada
isSameD(D,[_,_,_,D]).

numtohex(Int, Hex) :-
    Rem1 is Int//16 rem 16,
    Rem2 is Int rem 16,

    ((Rem1 <10, number_string(Rem1,Hex1)); 
    (Rem1 =10, Hex1 = 'A'); 
    (Rem1 =11, Hex1 = 'B');
    (Rem1 =12, Hex1 = 'C');
    (Rem1 =13, Hex1 = 'D');
    (Rem1 =14, Hex1 = 'E');
    (Rem1 =15, Hex1 = 'F')),

    ((Rem2<10, number_string(Rem2,Hex2));
    (Rem2=10, Hex2 = 'A');
    (Rem2=11, Hex2 = 'B');
    (Rem2=12, Hex2 = 'C');
    (Rem2=13, Hex2 = 'D');
    (Rem2=14, Hex2 = 'E');
    (Rem2=15, Hex2 = 'F')),
    string_concat(Hex1,Hex2,Hex).

isSameColor(Color,[_,_,Color,_]).
