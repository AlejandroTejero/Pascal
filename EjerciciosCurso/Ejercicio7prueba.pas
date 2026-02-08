{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio7.p;

const 
	NBarcos = 15;

type
	TipoEntrada = (Submarino,Dragaminas,Fragata,PortaAviones,Fin);
	TipoClase = Submarino..PortaAviones;
	TipoOrientacion = (Vertical,Horizontal);
	TipoColor = (Rojo,Verde,Azul);
	Tipoestado = (Tocado,Hundido,Intacto);
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
	
	TipoJuego = record
		numfilas: integer;
		numcolumnas: integer;
		numbarcos: integer;
		numhundidos: integer;
		barcos: TipoFlota;
	end;

procedure leerproa(var proa: TipoProa); 
begin
	write('Columna para la proa: ');
	readln(proa.columna);
	write('Fila para la proa: ');
	readln(proa.fila);
end;


procedure leerbarco(var barco: TipoBarco; var esfin: boolean); 
var
	entrada: TipoEntrada;
begin
	write('Clase de barco: ');
	readln(entrada);
	if entrada <> Fin then begin
		esfin := False;
		barco.clase := entrada;
		write('Orientacion: ');
		readln(barco.orientacion);
		leerproa(barco.proa);
		write('Color: ');
		readln(barco.color);
		write('Estado: ');
		readln(barco.estado);
	end
	else begin
		esfin := True;
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

procedure agregarbarco(var juego: TipoJuego; barco: TipoBarco);
begin
	juego.numbarcos := juego.numbarcos + 1;
	juego.barcos[juego.numbarcos] := barco;
end;


procedure leerentrada(var juego: TipoJuego); 
var
	barco: TipoBarco;
	esfin: boolean;
begin
	juego.numbarcos := 0;
	juego.numhundidos := 0;
	write('Numero de filas: ');
	readln(juego.numfilas);
	write('Numero de columnas: ');
	readln(juego.numcolumnas);
	repeat
		leerbarco(barco,esfin);
		if not esfin then begin
			agregarbarco(juego,barco);
			if barco.estado <> hundido then begin
				juego.numhundidos := juego.numhundidos;
			end
			else begin
				juego.numhundidos := juego.numhundidos + 1;
			end;	
		end;
	until (esfin) or(juego.numbarcos = NBarcos);
end;

{function ubicacioncasilla(barco: TipoBarco;fila:integer;columna:char):boolean;
var
	columnapopa: char;
	filapopa: integer;

begin
	if barco.orientacion = horizontal then begin
		columnapopa := chr(ord(barco.proa.columna) + numerolong(barco) -1);
		result :=(fila = barco.proa.fila) and ((columna >= barco.proa.columna) and (columna <= columnapopa)); 
	end
	else begin 
		filapopa := barco.proa.fila + numerolong(barco) -1;
		result := (columna = barco.proa.columna) and ((fila >= barco.proa.fila) and (fila <= filapopa)); 
	end
end;}

function ubicacioncasilla(barco: TipoBarco;fila:integer;columna:char):boolean;
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


procedure coincidecasilla(columna: char; fila: integer;
 juego: Tipojuego;var encontrado: boolean; var barco:TipoBarco);
var
	i: integer;

begin
	encontrado := False;
	i := 1;
	while (not encontrado) and (i <= juego.numbarcos) do begin  {cambiar orden vale tbm}
		barco := juego.barcos[i];
		if ubicacioncasilla(barco,fila,columna) then begin
		encontrado := True;
		end;
		i := i + 1;
	end;
end;

{begin
	encontrado := False;
	i := 1;
	while (not encontrado) and (i <= juego.numbarcos) do begin
		if ubicacioncasilla(juego.barcos[i],fila,columna) then begin
		encontrado := True;
		barco := juego.barcos[i];
		end;
		i := i + 1;
	end;
end;}

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

procedure escribirtablero(juego: TipoJuego);
var
	fila,column: integer;
	columna: char;
	encontrado: boolean;
	barco: TipoBarco;
begin
	for fila := 1 to juego.numfilas do begin
		columna := 'A';
		for column := 1 to juego.numcolumnas do begin
			coincidecasilla(columna,fila,juego,encontrado,barco);
			if encontrado then begin
				if barco.estado = hundido then begin 
					write('X');
				end
				else begin
					write(inicialcasilla(barco));
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
	writeln();
	write(juego.numbarcos, ' Barcos ');
	writeln(juego.numhundidos, ' Hundidos');
	escribirtablero(juego);
end;

var
	juego: TipoJuego;

begin
		leerentrada(juego);
		escribirjuego(juego);
end.



