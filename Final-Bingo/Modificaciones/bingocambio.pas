{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program bingo.p;

const
	MaxJugadores = 3;
	MaxCartones = 100;
	MaxLineas = 3;
	MaxCasillas = 5;
	MinNum = 1;
	MaxNum = 100;
	MaxExtracciones = 300;
	MaxPalabra = 8;
	
	Tab = '	';
	Esp = ' ';
	
type
	TipoEntrada = (Rojo,Verde,Azul,Amarillo,Fin);
	
	TipoColor = Rojo..Amarillo;
	
	TipoNumero = MinNum..MaxNum;
	
	TipoEstoyLeyendo = (Bien,Mal,FinCartonesJugador,FinFichero);
	
	TipoPalabra = string[MaxPalabra];
	
	TipoBola = record
		color: TipoColor;
		numero: TipoNumero;
	end;
	TipoBolas = array[1..MaxExtracciones] of TipoBola;
	
	TipoResultadoExtraccion = (Nada,Tachado,Bingo);
	
	TipoResultadosJugador = array[1..MaxJugadores] of TipoResultadoExtraccion;
	
	TipoCasilla = record
		numero: Tiponumero;
		tachado: boolean;
	end;
	TipoCasillas = array[1..MaxCasillas] of TipoCasilla;
	
	TipoLinea = record
		color: TipoColor;
		casillas: TipoCasillas;
	end;
	TipoCarton = array[1..MaxLineas] of TipoLinea;
	TipoCartones = array[1..MaxCartones] of TipoCarton;
	
	TipoJugador = record
		cartones: TipoCartones;
		numcartones: integer;
	end;
	TipoJugadores = array[1..MaxJugadores] of TipoJugador;
		
	TipoExtracciones = record
		bolas: TipoBolas;
		numbolas: integer;
	end;


{=======================================================================}

function esblanco(c:char):boolean;
begin
	result := (c = Esp) or (c = Tab);
end;

procedure vaciarpalabra(var palabra: TipoPalabra);
begin
	setlength(palabra, 0);
end;

procedure aniadirchar(var palabra: TipoPalabra; c: char);
var
	n: integer;
begin
	n := length(palabra);
	n := n + 1;
	setlength(palabra,n);
	palabra[n] := c;
end;
procedure leerpalabra(var fichero: text;var palabra: TipoPalabra);
var
	haypalabra: boolean;
	c: char;
begin
	vaciarpalabra(palabra);
	haypalabra := False;
	while not eof(fichero) and not haypalabra do begin
		if eoln(fichero) then begin 
			readln(fichero);
		end
		else begin
			read(fichero,c);
			haypalabra := not esblanco(c);
		end;
	end;
	
	while haypalabra and (length(palabra) <> MaxPalabra) do begin
		aniadirchar(palabra,c);
		if eof(fichero) or eoln(fichero) then begin
			haypalabra := False;
		end
		else begin
			read(fichero,c);
			haypalabra := not esblanco(c);
		end;
	end;
end;


{=========================(leer configuracion)==========================}

procedure leernumero(var fichero: text; var numero: TipoNumero;var que: TipoEstoyLeyendo);
var
	n: integer;
	palabra: TipoPalabra;
	pos: integer;
begin
	que := bien; 
	leerpalabra(fichero,palabra);
	if palabra = '' then begin
		que := FinFichero;
	end
	else begin 
		val(palabra,n,pos);
		if (pos = 0) and (n <= MaxNum) and (n >= MinNum) then begin
			numero := n;
		end
		else begin
			que := Mal;
		end;
	end;
end;

procedure leercasillas(var fichero: text; var casillas: TipoCasillas;var que: TipoEstoyLeyendo);
var
	numero: TipoNumero;
	numcasillas: integer;
begin
	numcasillas := 0;
	repeat
		leernumero(fichero,numero,que);
		if que = Bien then begin
			numcasillas := numcasillas + 1;
			casillas[numcasillas].numero := numero;
			casillas[numcasillas].tachado := false;
		end;
	until (que <> Bien) or (numcasillas = MaxCasillas);
end;

procedure leercolor(var fichero: text; var color: TipoColor;var que: TipoEstoyLeyendo);
var
	palabra: TipoPalabra;
	entrada: TipoEntrada;
	pos: integer;
begin
	que := bien;
	leerpalabra(fichero,palabra);
	if palabra = '' then begin
		que := FinFichero;
	end
	else begin
		val(palabra,entrada,pos);
		if pos = 0 then begin 
			if entrada <> Fin then begin
				color := entrada;
			end
			else begin
				que := FinCartonesJugador;
			end;
		end
		else begin 
			que := Mal;
		end;
	end;
end;

procedure leerlinea(var fichero: text; var linea: TipoLinea;var que: TipoEstoyLeyendo);
begin
	leercolor(fichero,linea.color,que);
	if que = bien then begin
		leercasillas(fichero,linea.casillas,que);
	end;
end;

{========================(ordenar num carton)==========================}

function compararnumderech2izq(casillas: TipoCasillas; desde: integer): integer;
var
	i,posicionminnum: integer;
begin
	posicionminnum := desde;
	for i := desde + 1 to MaxCasillas do begin
		if casillas[i].numero < casillas[posicionminnum].numero then begin
			posicionminnum := i;
		end;
	end;
	result := posicionminnum;
end;

procedure cambiarordennum(var casilla1,casilla2 : TipoCasilla);
var
	casillaaux: TipoCasilla;
begin
	casillaaux := casilla1;
	casilla1 := casilla2;
	casilla2 := casillaaux;
end;

procedure ordenarmentomay(var casillas: TipoCasillas);
var
	i,posicionminnum: integer;
begin
	for i := 1 to MaxCasillas - 1 do begin
		posicionminnum := compararnumderech2izq(casillas,i); {menor poscion desde i para alante}
		if posicionminnum <> i then begin
			cambiarordennum(casillas[posicionminnum],casillas[i]);
		end;
	end;
end;

{======================================================================}

procedure leercarton(var fichero: text; var carton: TipoCarton;var que: TipoEstoyLeyendo);
var
	numlineas: integer;
	linea: TipoLinea;
begin
	numlineas := 0;
	repeat
		leerlinea(fichero,linea,que);
		if que = Bien then begin
			ordenarmentomay(linea.casillas);
			numlineas := numlineas + 1;
			carton[numlineas] := linea;
		end;
	until (que <> Bien) or (numlineas = MaxLineas);
end;

procedure aniadircarton(var jugador: TipoJugador;carton: TipoCarton);
begin
	jugador.numcartones := jugador.numcartones + 1;
	jugador.cartones[jugador.numcartones] := carton;
end;

procedure leerjugador(var fichero: text; var jugador: TipoJugador;var que: TipoEstoyLeyendo);
var
	carton: TipoCarton;
begin
	jugador.numcartones := 0;
	repeat
		leercarton(fichero,carton,que);
		if que = Bien then begin
			aniadircarton(jugador,carton);
		end;
	until (que <> Bien) or (jugador.numcartones = Maxcartones);
end;

procedure leerconfiguracion(var fichero: text;var jugadores: TipoJugadores;var que: TipoEstoyLeyendo);
var
	numjugadores: integer;
	jugador: Tipojugador;
begin
	numjugadores := 0;
	repeat
		leerjugador(fichero,jugador,que);
		if que = FinCartonesJugador then begin
			numjugadores := numjugadores + 1;
			jugadores[numjugadores] := jugador;
		end;
	until (que <> FinCartonesJugador) or (numjugadores = maxjugadores);
end;

{=======================(escribir configuracion)========================}

procedure escribircasilla(casilla: TipoCasilla);
begin
	if casilla.tachado then begin
		write(' XX');
	end
	else begin
		write(' ',casilla.numero, ' '); 
	end;
end;

procedure escribircasillas(casillas: TipoCasillas);
var
	i: integer;
begin
	for i:= 1 to MaxCasillas do begin
		escribircasilla(casillas[i]);
	end;
end;

procedure escribirlinea(linea: TipoLinea);
var
	i: integer;
begin
	write(linea.color);
	{ordenarnumeros(linea.casillas);}
	for i:= 1 to MaxCasillas do begin
		escribircasilla(linea.casillas[i]);
	end;
	writeln();
end;

procedure escribircarton(carton: Tipocarton);
var 
	i: integer;
begin
	for i:= 1 to MaxLineas do begin;
		escribirlinea(carton[i]);
	end;
	writeln();
end;

procedure escribirjugador(numjugador: integer; jugador: TipoJugador);
var
	i: integer;
begin
	for i:= 1 to jugador.numcartones do begin
		writeln('Jugador ', numjugador, ' Carton ', i);
		escribircarton(jugador.cartones[i]);
	end;
end;

procedure escribirjugadores(jugadores: TipoJugadores);
var
	i: integer;
begin
	for i:= 1 to MaxJugadores do begin
		escribirjugador(i, jugadores[i]);
	end;
end;

{==========================(leer extraccion)===========================}

procedure leerbola(var fichero: text;var bola: TipoBola;var que: TipoEstoyLeyendo);
begin
	leercolor(fichero,bola.color,que); 
	 if que = Bien then begin
		leernumero(fichero,bola.numero,que);
	 end;
end;

procedure aniadirbola(var extracciones: TipoExtracciones; bola: TipoBola);
begin
	extracciones.numbolas := extracciones.numbolas + 1;
	extracciones.bolas[extracciones.numbolas] := bola;
end;

procedure escribirbola(bola: TipoBola);
begin
	writeln(bola.color,' ',bola.numero);
end;

{==========================(tachar extraccion)==========================}

procedure tacharnumenlinea(bola: TipoBola;var linea: TipoLinea;var tachadoenlinea: boolean);
var
	i: integer;
begin
	tachadoenlinea := False;
	for i:= 1 to MaxCasillas do begin
		if (bola.numero = 3) and (bola.color = rojo) then begin
			tachadoenlinea := False;
			linea.casillas[i].tachado := False;
		end
		else if bola.numero = linea.casillas[i].numero then begin
			tachadoenlinea := True;
			linea.casillas[i].tachado := True;
		end;
	end;
end;

procedure tacharnumencarton(bola: TipoBola;var carton: TipoCarton;var tachadoencarton: boolean);
var
	i: integer;
	tachadoenlinea: boolean;
	
begin
	tachadoencarton := False;
	for i:= 1 to MaxLineas do begin
		if bola.color = carton[i].color then begin
		tacharnumenlinea(bola,carton[i],tachadoenlinea);
			if tachadoenlinea then begin
				tachadoencarton := True;
			end;
		end;
	end;
end;

function estalineatachada(linea: TipoLinea):boolean;
var
	lineatachada: boolean;
	i: integer;
begin
	lineatachada:= True;
	i:= 1;
	while (lineatachada) and (i <= MaxCasillas) do begin
		if linea.casillas[i].tachado then begin
			lineatachada:= True;
		end
		else begin
			lineatachada:= False;
		end;
		i:= i + 1;
	end;
	result := lineatachada;
end;

function escartonconbingo(carton: TipoCarton):boolean;
var
	haybingo: boolean;
	i: integer;
begin
	haybingo:= True;
	i:= 1;
	while (haybingo) and (i <= MaxLineas) do begin
		if estalineatachada(carton[i]) then begin
			haybingo:= True;
		end
		else begin
			haybingo:= False;
		end;
		i:= i + 1;
	end;
	result:= haybingo;
end;

procedure tacharnumerosjugador(bola: TipoBola;
var jugador: TipoJugador;
var resultadoextraccion: TipoResultadoExtraccion);

var
	hacantadobingo : boolean;
	i: integer;
	tachadoencarton : boolean;
begin
	resultadoextraccion:= Nada;
	hacantadobingo:= False;
	i := 1;
	while (not hacantadobingo) and (i <= jugador.numcartones) do begin
		tacharnumencarton(bola,jugador.cartones[i],tachadoencarton);
		if (tachadoencarton) and (escartonconbingo(jugador.cartones[i])) then begin
			hacantadobingo := True;
			resultadoextraccion := Bingo;
		end
		{else if (tachadoencarton) and (bola.color = Verde) and (bola.numero = 3) then begin
			hacantadobingo := True;
			resultadoextraccion := Bingo;
		end}
		else if (tachadoencarton) and (bola.color = rojo) and (bola.numero = 3) then begin
			resultadoextraccion := Nada;
		end
		else if tachadoencarton then begin
			resultadoextraccion := Tachado;
		end;
		i := i + 1;
	end;
end;

procedure tacharnumeroscartones(bola: TipoBola;
var jugadores: TipoJugadores;
var resultadosjugador: TipoResultadosJugador);

var
	i: integer;
begin
	for i:= 1 to MaxJugadores do begin
		tacharnumerosjugador(bola,jugadores[i],resultadosjugador[i]);
	end;
end;

{======================================================================}

procedure escribirresultadosjugadores(resultadosjugadores: TipoResultadosJugador);
var
	i: integer;
begin
	for i := 1 to MaxJugadores do begin
		writeln('Jugador ',i,': ' ,resultadosjugadores[i],'.');
	end;
	writeln();
end;

function cuantosbingoshay(resultadosjugadores: TipoResultadosJugador):integer;
var
	i: integer;
	numerodebingos:integer;
begin
	numerodebingos := 0;
	for i := 1 to MaxJugadores do begin
		if resultadosjugadores[i] = bingo then begin
			numerodebingos := numerodebingos +1; 
		end;
	end;
	result := numerodebingos;
end;

procedure leerextracciones(var fichero: text;
var extracciones: TipoExtracciones;
var jugadores: TipoJugadores;
var resultadosjugadores: TipoResultadosJugador;
var que: TipoEstoyLeyendo);

var
	haganadoalguien: boolean;
	bola: TipoBola;
begin
	haganadoalguien := False;
	extracciones.numbolas := 0;
	repeat
		leerbola(fichero,bola,que);
		if que = Bien then begin
			escribirjugadores(jugadores);
			aniadirbola(extracciones,bola);
			escribirbola(bola);
			tacharnumeroscartones(bola,jugadores,resultadosjugadores);
			escribirresultadosjugadores(resultadosjugadores);
			if cuantosbingoshay(resultadosjugadores) <> 0 then begin
				haganadoalguien := True;
			end;
		end;
	until (haganadoalguien) or (que <> Bien) or (extracciones.numbolas = MaxExtracciones);
end;

function jugadorganador(resultadosjugadores: TipoResultadosJugador):integer;
var
	ganadorencontrado: boolean;
	numjugador: integer;
begin
	ganadorencontrado:= False;
	numjugador:= 1;
	while (not ganadorencontrado) and (numjugador <= MaxJugadores) do begin
		if resultadosjugadores[numjugador] = Bingo then begin
			ganadorencontrado:= True;
		end
		else begin
			numjugador := numjugador + 1;
		end;
	end;
	result := numjugador;
end;

procedure escribirbolasextraidas(extracciones: TipoExtracciones);
var
	i: integer;
begin
	for i:= 1 to extracciones.numbolas do begin
		writeln(extracciones.bolas[i].color,' ',extracciones.bolas[i].numero);
	end;
end;

procedure escribirganador(resultadosjugadores: TipoResultadosJugador);
begin
	if cuantosbingoshay(resultadosjugadores) = 0 then begin
		writeln('Empate sin bingo');
	end
	else if (cuantosbingoshay(resultadosjugadores) = 1) then begin
		writeln('Ganador: Jugador ', jugadorganador(resultadosjugadores));
	end
	else begin
		writeln('Empate con bingo')
	end;
end;

var
	fichero: text;
	jugadores: TipoJugadores;
	extracciones: TipoExtracciones;
	resultadosjugadores: TipoResultadosJugador;
	que: TipoEstoyLeyendo;

begin
	
	assign(fichero, 'datos.txt');
	reset(fichero);
	leerconfiguracion(fichero,jugadores,que);
	if que <> FinCartonesJugador then begin
			writeln('Error en la fase de configuracion');
	end
	else begin
		leerextracciones(fichero,extracciones,jugadores,resultadosjugadores,que);
			if que = Mal then begin
				writeln('Error en la fase de extraciones');
			end;
		escribirbolasextraidas(extracciones);
		escribirganador(resultadosjugadores);
	end;
	close(fichero);
end.
