{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio8.p;

const 
	NBarcos = 15;
	MaxPalabra = 12; {PortaAviones}
	Esp = ' ';
	Tab = '	';

type
	TipoEntrada = (Submarino,Dragaminas,Fragata,PortaAviones,Fin);
	TipoClase = Submarino..PortaAviones;
	TipoOrientacion = (Vertical,Horizontal);
	TipoColor = (Rojo,Verde,Azul);
	TipoEstado = (Tocado,Hundido,Intacto);
	TipoEsCorrecto = (Bien,Mal,FinJugador,FinFichero);
	{Recordatorio: No meto los blancos,los leo en una function (lin 47)}
	TipoPalabra = string[Maxpalabra];
	
	TipoProa = record
		columna: char;
		fila: integer;
	end;
	TipoBarco = record
		clase: TipoClase;
		orientacion: TipoOrientacion;
		proa: TipoProa;
		color: TipoColor;
		estado: TipoEstado;
	end;
	
	TipoFlota = array[1..NBarcos] of TipoBarco;
	
	TipoJugador = record
		barcos: TipoFlota;
		numbarcos: integer;
	end;
	
	TipoJuego = record
		numfilas: integer;
		numcolumnas: integer;
		jugador1: TipoJugador;
		jugador2: TipoJugador;
	end;
	
function esblanco(c:char):boolean;
begin
	result := (c = Esp) or (c = Tab);
end;

procedure vaciarpalabra(var palabra: TipoPalabra);
begin
	setlength(palabra, 0);
end;

procedure addcar(var palabra: TipoPalabra; c: char);
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
		addcar(palabra,c);
		if eof(fichero) or eoln(fichero) then begin
			haypalabra := False;
		end
		else begin
			read(fichero,c);
			haypalabra := not esblanco(c);
		end;
	end;
end;

procedure leerenteros(var fichero: text; var enteros: integer;var estaok: TipoEsCorrecto);
var
	palabra: TipoPalabra;
	pos: integer;
begin
	estaok := Bien;
	leerpalabra(fichero,palabra);
	if palabra = '' then begin
		estaok := Finfichero;
	end
	else begin 
		val(palabra,enteros,pos);
		if (pos <> 0) or (enteros <= 0)then begin 
		{si pos=mal o numfilas<=0 tbm mal, no filas negativas o 0}
			estaok := mal;
		end; 
	end;
end;

procedure leerclase(var fichero: text; var clase: TipoClase;var estaok: TipoEsCorrecto);
var
	palabra: TipoPalabra;
	entrada: TipoEntrada;
	pos: integer;
begin
	estaok := bien;
	leerpalabra(fichero,palabra);
	if palabra = '' then begin
		estaok := FinFichero;
	end
	else begin
		val(palabra,entrada,pos);
		if pos = 0 then begin 
			if entrada <> Fin then begin
				clase := entrada;
			end
			else begin
				estaok := FinJugador;
			end;
		end
		else begin 
			estaok := Mal;
		end;
	end;
end;

procedure leerorientacion(var fichero: text; var orientacion: TipoOrientacion;var estaok: TipoEsCorrecto);
var
	palabra: TipoPalabra;
	pos: integer;
begin
	estaok := bien;
	leerpalabra(fichero,palabra);
	if palabra = '' then begin
		estaok := FinFichero;
	end
	else begin
		val(palabra,orientacion,pos);
		if pos <> 0 then begin 
			estaok := Mal;
		end;
	end;
end;

procedure leercolumna(var fichero: text; var columna: char;var estaok: TipoEsCorrecto);
var
	palabra: TipoPalabra;
begin
	estaok := Bien;
	
	leerpalabra(fichero,palabra);
	if palabra = ' ' then begin 
		estaok := FinFichero;
	end
	else begin
		if (length(palabra) = 1) and (palabra[1] >= 'A') then begin
			columna := palabra[1];
		end
		else begin 
			estaok := Mal;
		end;
	end;
end;


procedure leerproa(var fichero: text; var proa: TipoProa;var estaok: TipoEsCorrecto);
begin
	leercolumna(fichero,proa.columna,estaok);
	if estaok = bien then begin
		leerenteros(fichero,proa.fila,estaok);
	end;
end;


procedure leercolor(var fichero: text; var color: TipoColor;var estaok: TipoEsCorrecto);
var
	palabra: TipoPalabra;
	pos: integer;
begin
	estaok := bien;
	leerpalabra(fichero,palabra);
	if palabra = '' then begin
		estaok := FinFichero;
	end
	else begin
		val(palabra,color,pos);
		if pos <> 0 then begin 
			estaok := Mal;
		end;
	end;
end;

procedure leerestado(var fichero: text; var estado: TipoEstado;var estaok: TipoEsCorrecto);
var
	palabra: TipoPalabra;
	pos: integer;
begin
	estaok := bien;
	leerpalabra(fichero,palabra);
	if palabra = '' then begin
		estaok := FinFichero;
	end
	else begin
		val(palabra,estado,pos);
		if pos <> 0 then begin 
			estaok := Mal;
		end;
	end;
end;

procedure leerbarco(var fichero: Text; var barco: TipoBarco; var estaok: TipoEsCorrecto);
begin
	leerclase(fichero,barco.clase,estaok);
	if estaok = bien then begin
		leerorientacion(fichero,barco.orientacion,estaok);
	end;
	if estaok = bien then begin
		leerproa(fichero,barco.proa,estaok);
	end;
	if estaok = bien then begin
		leercolor(fichero,barco.color,estaok);
	end;
	if estaok = bien then begin
		leerestado(fichero,barco.estado,estaok);
	end;
end;

procedure agregarbarco(var jugador: TipoJugador; barco:TipoBarco);
begin
	jugador.numbarcos := jugador.numbarcos + 1;
	jugador.barcos[jugador.numbarcos] := barco;
end;

procedure leerjugador(var fichero: text; var jugador: Tipojugador; var estaok: TipoEsCorrecto);
var
	barco: TipoBarco;
begin 
	jugador.numbarcos := 0;
	repeat
		leerbarco(fichero,barco,estaok);
		if estaok = Bien then begin
			agregarbarco(jugador,barco);
			
		end
	until (estaok <> bien) or (jugador.numbarcos = NBarcos);
end;

procedure leerentrada(var fichero: text; var juego: TipoJuego);
var
	estaok: TipoEsCorrecto;
begin
	leerenteros(fichero,juego.numfilas,estaok);
	if estaok = bien then begin 
			leerenteros(fichero,juego.numcolumnas,estaok);
	end;
	if estaok = bien then begin 
			leerjugador(fichero,juego.jugador1,estaok);
	end;
	if estaok = FinJugador then begin 
			leerjugador(fichero,juego.jugador2,estaok);
	end;
end;

function numerolong(barco:TipoBarco):integer;
begin
	case barco.clase of
		Submarino:
			result := 1;
		Dragaminas:
			result := 2;
		Fragata:
			result := 3;
		PortaAviones:
			result := 4;
	end;
end;

function horientacioncasilla(barco: TipoBarco;fila:integer;columna:char):boolean;
var
	columnapopa: char;
	filapopa: integer;
begin
	if barco.orientacion = vertical then begin
		filapopa := barco.proa.fila + numerolong(barco) -1;
		result := (columna = barco.proa.columna) and ((fila >= barco.proa.fila) and (fila <= filapopa)); 
	end
	else begin {horizontal}
		columnapopa := chr(ord(barco.proa.columna) + numerolong(barco) -1);
		result :=(fila = barco.proa.fila) and ((columna >= barco.proa.columna) and (columna <= columnapopa)); 
	end
end;

procedure coincidecasilla(columna: char; fila: integer;jugador: TipoJugador;var encontrado: boolean; var barco:TipoBarco);
var
	i: integer;
begin
	encontrado := False;
	i := jugador.numbarcos;
	while (not encontrado) and (i >= 1) do begin 
		barco := jugador.barcos[i];
		if horientacioncasilla(barco,fila,columna) then begin
		encontrado := True;
		end;
		i := i - 1;
	end;
end;

function inicialcasilla(barco: TipoBarco): char;
begin
	case barco.clase of
		Submarino:
			result := 'S';
		Dragaminas:
			result := 'D';
		Fragata:
			result := 'F';
		PortaAviones:
			result := 'P';
	end;
end;

procedure escribirtablero(jugador: TipoJugador;juego: TipoJuego);
var
	fila,column: integer;
	columna: char;
	encontrado: boolean;
	barco: TipoBarco;
begin
	for fila := 1 to juego.numfilas do begin
		columna := 'A';
		for column := 1 to juego.numcolumnas do begin
			coincidecasilla(columna,fila,jugador,encontrado,barco);
			if encontrado then begin
				if barco.estado = hundido then begin
					write('X ');
				end
				else begin
					if (barco.clase <> Submarino) then begin
						write(inicialcasilla(barco));
						write(' ');
					end;
				end;
			end
			else begin
				write('. ');
			end;
			columna := succ(columna);
		end;
	writeln();
	end;
end;

procedure escribirjuego(juego: TipoJuego);
begin
	writeln('jugador1');
	escribirtablero(juego.jugador1,juego);
	writeln('jugador2');
	escribirtablero(juego.jugador2,juego);
end;

var
	juego: TipoJuego;
	fichero: text;
begin
	assign(fichero, 'datos8.txt');
	reset(fichero);
	leerentrada(fichero,juego);
	close(fichero);
	escribirjuego(juego);
end.
