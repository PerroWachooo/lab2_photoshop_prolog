%Tda Imagen
:-module(tdaImagen_21165824_BritoGarrido, [image/5, getAlto/2, getAncho/2, getColor_Compresed/2, getPixels/2, setAlto/3, setAncho/3, setColor_Compressed/3, setPixels/3, imageIsBitmap/1, imageIsPixmap/1, imageIsHexmap/1, imageIsCompressed/1, imageFlipH/2, imageFlipV/2, imageCrop/6, imageRGBtoHex/2, imageToHistogram/2, imageRotate90/2, imageCompress/2, imageChangePixel/3, imageToString/2, imageDepthLayers/2, getHead/2, getSecond/2, min/3, max/3, abs/2, listaToString/2, depthSeparation/2, rellenoCapas/3, depthAndColorChange/3]).
:- use_module(tdaPixbit_21165824_BritoGarrido).
:- use_module(tdaPixhex_21165824_BritoGarrido).
:- use_module(tdaPixrgb_21165824_BritoGarrido).
:- use_module(funcionesextra_21165824_BritoGarrido).
%2) Image
%Entrada: "Color_Comprimido", Ancho, Alto, [Lista de pixeles]
%Salida: [Color_Comprimido,Ancho,Alto,[Lista de pixeles]]

image(Color_Comprimido,Ancho,Alto,[H|T], [Color_Comprimido,Ancho,Alto,[H|T]]):-
    integer(Ancho),
    integer(Alto).

getAlto([_,Alto,_,_], Alto).

getAncho([_,_,Ancho,_],Ancho).

getColor_Compresed([Color|_],Color).

getPixels([_,_,_,[H|T]], [H|T]).

setAlto([Color,_,Ancho,[H|T]], NewAlto, [Color,NewAlto,Ancho,[H|T]]):-
    integer(NewAlto).

setAncho([Color,Alto,_,[H|T]], NewAncho, [Color,Alto,NewAncho,[H|T]]):-
    integer(NewAncho).

setColor_Compressed([_,Alto,Ancho,[H|T]],NewColor, [NewColor,Alto,Ancho,[H|T]]).

setPixels([Color,Alto,Ancho,_], [NewH|NewT], [Color,Alto,Ancho,[NewH|NewT]]).

%3)imageIsBitmap
%Dominio: image
%Recorrido: boolean
imageIsBitmap([_,_,_,[H|_]]) :-
    pixbit(_,_,_,_, H ).


%4)imageIsPixmap
%Dominio: image
%Recorrido: boolean
imageIsPixmap([_,_,_,[H|_]]) :-
    pixrgb(_,_,_,_,_,_, H ).

%5)imageIsHexmap
%Dominio: image
%Recorrido: boolean
imageIsHexmap([_,_,_,[H|_]]) :-
    pixhex(_,_,_,_, H ).

%6)imageIsCompressed
%Dominio: Image
%Recorrido: Boolean
%Descripcion: Como se define en el Tda imagen que el primer elemento es el string
%del color comprimido, si el string es vacío significa es no ha sido comprimida.

imageIsCompressed([Color|_]):-
                  Color \= "" .

%7) imageFlipH
%Dominio: Imagen X Imagen
%Descripcion: Invierte la imagen de forma horizontal
 

imageFlipH([Color,Alto,Ancho, Pixeles], [Color,Alto,Ancho, NewPixeles]):-
    maplist(pixelFlipH(Alto),Pixeles,NewPixeles).

%(8 imageFlipV
%Dominio: Imagen X Imagen
%Descripcion: Invierte la imagen de forma vertical

imageFlipV([Color,Alto,Ancho, Pixeles], [Color,Alto,Ancho, NewPixeles]):-
    maplist(pixelFlipV(Ancho),Pixeles,NewPixeles).


%(9 Crop
%Dominio: image X x1 (int) X y1 (int) X x2 (int) X y2 (int) X image
%Descripcion: Recorta una imagen, dejando todo lo que esta dentro de los parametros

imageCrop([Color, _, _, Pixeles],X1,Y1,X2,Y2 , [Color, NewAlto, NewAncho, NewPixeles]):-
    H is X2-X1,
    abs(H,Hf),
    NewAlto is Hf + 1,
    W is Y2-Y1,
    abs(W,Wf),
    NewAncho is Wf + 1,
    
    min(X1,X2, Xmin),
    max(X1,X2, Xmax),
    min(Y1,Y2, Ymin),
    max(Y1,Y2, Ymax),
	include(dentro_de_margen(Xmin,Xmax,Ymin,Ymax),Pixeles, Pixelesfiltred),
	maplist(cambio_cords_crop(Xmin,Ymin),Pixelesfiltred,NewPixeles).


%10) imageRGBToHex
%Dominio:image X image
%Descripcion: Convierte una imagen rgb a hex, solo haciendo el cambio de pixeles
imageRGBtoHex(I, [Color, Alto, Ancho, NewPixeles]):-
    getColor_Compresed(I, Color),
    getAlto(I, Alto),
    getAncho(I, Ancho),
    getPixels(I, Pixeles),
    maplist(pixrgb_to_pixhex, Pixeles, NewPixeles).

%11)imageToHistogram
%Dominio: image X histograma
%Descripcion: De una imagen, Devuelve la representación de su histograma en forma de lista
imageToHistogram(Imagen, Histograma):-
    getPixels(Imagen, Pixels),
    pixel_histogram(Pixels, Histograma).



%pixel_histogram
%Domino: Lista De pixeles X Histograma
%Tipo de Recurción: Natural
%Descripcion: transforma una lista de pixeles en un histograma

%caso base 1: cuando no hay mas pixeles, se devuelve el histograma
pixel_histogram([],[]).



%caso recursivo
pixel_histogram(Pixels,[[Repeticiones,ColorPixel]|Histograma]):-
    %se toma el primer pixel
    getHead(Pixels, Head_Pixel),
    
    %se toma el color del primer pixel
    getColor(Head_Pixel,ColorPixel),   
    
    %se deja en una lista solo los pixeles del mismo color
    include(isSameColor(ColorPixel),Pixels,Pixeles_mismocolor),
    
    %se saca el largo de esa lista para saber las repeticiones
    length(Pixeles_mismocolor,Repeticiones),
    
    
    %se deja en una lista los pixeles distintos al color ya agregado
    exclude(isSameColor(ColorPixel),Pixels,NewPixeles),
    
    %se llama a la funcion nuevamente con el nuevo histograma y la nueva lista de pixeles
    pixel_histogram(NewPixeles,Histograma).




%12) imageRotate90
%Dominio: Image X Image
%Descripcion: Se invierten los valores entre ancho y alto y se rota cada pixel con otra funcion

imageRotate90(ImagenIn,ImagenOut):-
    getAlto(ImagenIn,Alto),
    getAncho(ImagenIn,Ancho),
    getPixels(ImagenIn,Pixeles),
    maplist(rotatepixel(Alto),Pixeles,NewPixeles),
    setAlto(ImagenIn,Ancho,ImageMod1),
    setAncho(ImageMod1,Alto,ImageMod2),
    setPixels(ImageMod2,NewPixeles,ImagenOut).

%13) imageCompress
%Dominio: image X image
%Descripcion: comprime una imagen eliminando el color más frecuente, guardando la
%informaciion del color

imageCompress(ImageIn,ImageCompressed):-
    %se saca el histograma de la imagen
    imageToHistogram(ImageIn,Histogram),
    
    %se ordena en orden decreciente de acuerdo a la frecuenca
    sort(0,@>,Histogram, HistogramSort),
    
    %se obtiene la cabeza del histograma ordenado ordenada(el mas frecuente)
    getHead(HistogramSort,PixelMasFrecuente),
    
    %se saca el segundo elemento de el elemnto anterior(el color del mas frecuente)
    getSecond(PixelMasFrecuente,ColorFrecuente),
    
    getPixels(ImageIn, Pixeles),
    
    %se filtra la lista de pixeles iniciales, dejando los que tengan el color más frecuente
    exclude(isSameColor(ColorFrecuente),Pixeles,PixelesCompressed),
    
    %crea una nueva imagen con los pixeles filtrados
    setPixels(ImageIn,PixelesCompressed, ImageMod),
    
    %a la imagen anterior le agrega el color más frecuente para guardarlo en el tda
    setColor_Compressed(ImageMod,ColorFrecuente,ImageCompressed).


%14)imageChangePixel
%Dominio: Imagen x Pixel x Imagen
%Descripción: Permite remplazar un pixel de una imagen, cambiandolo por uno que tenga
%las mismas cordenadas que el pixel original


imageChangePixel(ImagenIn,PixelFinal,ImagenOut):-
    %se obtiene la lista de pixeles iniciales y las cordenadas x e y del pixel modificado
    getPixels(ImagenIn,Pixeles),
    getx(PixelFinal,X),
    gety(PixelFinal,Y),
    
    %se deja una lista sin el pixel que coincida con las cordenadas del pixel modificado
    exclude(isSameCord(X,Y),Pixeles,PixelesMod),
    
    %se agrega el pixel modificado a la lista modificada anteriormente y se crea una imagen con esta nueva lista
    append([PixelFinal],PixelesMod,Pixeles_Out),

    setPixels(ImagenIn,Pixeles_Out,ImagenOut).


%16)imageToString
%Dominio: Image X string
%Descripción: Transforma una imagen en una respresentación de string

imageToString(Imagen,String):-
    getAncho(Imagen,Ancho),
    getPixels(Imagen,Pixeles),
    %se convierte la lista de pixeles un una lista de strings, donde cada elemento es un color
    maplist(pixelToString(Ancho),Pixeles,List_Colors),
    %se transforma la lista de strings en un solo string
    listaToString(List_Colors,String).

%pixelToString
%Dominio: AnchoImagen X Pixel X String
%Descripcion: cambia un pixel a una representación de string añadiendo '\t o \n donde corresponda
pixelToString(Ancho,Pixelin,StringOut):-
    gety(Pixelin, Y),
    getColor(Pixelin, Color),
    Limite is Ancho - 1,
    
    %si es un pixrgb, la lista de color se transforma a string con la funcion term_string, si no, se una atom_string
    ((pixrgb(_,_,_,_,_,_,Pixelin),term_string(Color,Color_string));
    (atom_string(Color,Color_string))),
    
    %si el pixel esta al final se le agrega un \n, si no, se le agrega un \t
    ((Y < Limite, string_concat(Color_string,"\t   ",StringOut));
     (Y = Limite, string_concat(Color_string,"\n   ",StringOut))).


%17)imageDepthLayers
%Domino: Imagen X lista de imagenes
%Descripción: Separa las imagenes por capas de profundiad los pixeles que estan
% en otras capas son sustituidos por pixeles de color blaco para cada imagen

imageDepthLayers(Imagen,ListaImagenes):-
    getPixels(Imagen,Pixeles),
    %se separan los pixeles originales por capas de profundiad
    depthSeparation(Pixeles,PixelesAgrupadosD),
    %para cada capa se crea una imagen, dejando estas imagenes en la lista de imagenes de salida
    maplist(rellenoCapas(Imagen),PixelesAgrupadosD,ListaImagenes).


%-------------------------OTRAS-------------------------
getHead([H|_], H).
getSecond([_,S|_],S).

min(Int1, Int2, Int3):-
    (Int1 < Int2, Int3 = Int1);
    (Int1 > Int2, Int3 = Int2);
    (Int1 = Int2, Int3 = Int2).

max(Int1, Int2, Int3):-
    (Int1 > Int2, Int3 = Int1);
    (Int1 < Int2, Int3 = Int2);
    (Int1 = Int2, Int3 = Int2).

abs(Intin, Intout):-
    (Intin >= 0, Intout = Intin);
    (Intin < 0, Intout is Intin * -1).

%listaToString
%Dominio: Lista de strings X String
%Descripcion: Funcion recursiva natural, que convierte una lista de strings en un solo string

%Caso base: Cuando no hay más elementos en la lista retorna un espacio vacio ("")
listaToString([],"").

%Recurcion: hace el llamado hasta llegar al caso base, desde ahí, se junta el elemnto con lo entregado por la llamada
listaToString([H|T],String):-
    listaToString(T,TailListString),
    string_concat(H,TailListString,String).

%depthSeparation(se usa en imageDepthLayers)
%Dominio: Lista De pixeles X lista de listas de pixeles 
%Descripcion: Separa los pixeles de una lista un sublistas de pixeles con la misma profundidad
%Recursión Natural

%Caso base, llega al final y empieza retornar la lista
depthSeparation([],[]).

%Caso recursivo: separa los pixeles dependiendo de la profundidad del primero y vuelve a hacer un llamado con los pixeles
% con distintas profundidades hasta que la lista de pixeles originales se acabe

depthSeparation(PixelesOriginales,[Profundidad_actual|Profundiades_Restantes]):-
    %se obtiene el primer pixel
    getHead(PixelesOriginales,Head_Pixel),
    %se le saca la profundiad
    getD(Head_Pixel,D),
    %filtra los pixeles originales dejndo solo los que tengan la misma profundiad del primer pixel
    include(isSameD(D),PixelesOriginales,Profundidad_actual),
    %filtra los pixeles originales dejndo solo los que tengan distinta profundiad del primer pixel
    exclude(isSameD(D),PixelesOriginales,Pixeles_restantes),
    %vuelve a hacer un llamado con los pixeles que faltan por agrupar en otras profundiades
    depthSeparation(Pixeles_restantes,Profundiades_Restantes).


    
%rellenoCapas (se usa en imageDepthLayers)
%Dominio: Imagen X Lista De pixeles x Imagen
%Descripción: Crea una imagen nueva, con pixeles de la misma profundidad, remplazando solo los pixeles 
%de la imagen original que estan en otra profundiad distinta a la de los pixeles entregados dejandolos como color blanco

rellenoCapas(ImagenOriginal,PixelesCapa, ImagenCapa):-
    %se obtiene la lista original de pixeles
    getPixels(ImagenOriginal,PixelesOriginales),
    %se obtiene el primer pixel de la lista de entrada para sabe su profundidad
    getHead(PixelesCapa,Head),
    getD(Head,D),
    %se filtra la lista de pixeles original dejando solo los que no esten en la profundad sacada
    exclude(isSameD(D),PixelesOriginales,PixelesDistintoD),
    %los pixeles filtrados se les cambia por pixeles de color blanco en la misma profundiad
    maplist(depthAndColorChange(D),PixelesDistintoD,Relleno),
    %se une los pixeles de color blanco con los pixeles de la misma profundiad
    append(PixelesCapa,Relleno,PixelesRellenados),
    %se crea otra imagen similar a la original, solo cambiando los pixeles
    setPixels(ImagenOriginal,PixelesRellenados,ImagenCapa).


%depthAndColorChange (se usa en imageDepthLayers)
%Dominio: Profundidad X Pixel X Pixel
%Descripcion: A El pixel de entrada, le modifica la profundidad por la entregada y su color por uno blanco
depthAndColorChange(NewD,PixelIn,PixelOut):-
    %dependiendo de que tipo de pixel sea, se le cambia a color blanco en su formato
    (   (pixrgb(_,_,_,_,_,_,PixelIn),setD(PixelIn,NewD,PixelMod),setrgb(PixelMod,255,255,255,PixelOut));
        (pixhex(_,_,_,_,PixelIn), setD(PixelIn,NewD,PixelMod),sethex(PixelMod,"FFFFFF",PixelOut));
        (pixbit(_,_,_,_,PixelIn), setD(PixelIn,NewD,PixelMod),setbit(PixelMod,1,PixelOut))).





