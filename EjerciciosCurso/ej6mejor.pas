{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio6.p;

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
	TipoJuego = record
		numfilas: integer;
		numcolumnas: integer;
		numbarcos: integer;
		numhundidos: integer;
		mayorbarco: TipoBarco;
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

{function estadentrocolumna(juego: TipoJuego; barco: TipoBarco): boolean;
begin
	result := (ord(barco.proa.columna) - 64) <= juego.numcolumnas;
end;}

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
		{if ((barco.proa.fila <= juego.numfilas) and (estadentrocolumna(juego,barco))) then begin}
			if not esfin then begin
				if juego.numbarcos = 0 then begin
					juego.mayorbarco := barco;
				end
				else if numerolong(juego.mayorbarco) < numerolong(barco) then begin
					juego.mayorbarco := barco;
				end;
					if barco.estado <> hundido then begin
						juego.numhundidos := juego.numhundidos;
					end
					else begin
						juego.numhundidos := juego.numhundidos + 1;
					end;	
						juego.numbarcos := juego.numbarcos + 1;
			end;
		{end
		else begin
			writeln('Fila o columna del barco mal introducida');
		end;}
	until esfin;
end;

function casillacoincidenteproa(juego: TipoJuego;columna: char; fila: integer):boolean;
begin
	result := (juego.mayorbarco.proa.columna = columna) and (juego.mayorbarco.proa.fila = fila);
end;

procedure escribirtablero(juego: TipoJuego);
var
	fila,column: integer;
	columna: char;
begin
	for fila := 1 to juego.numfilas do begin
		columna := 'A';
		for column := 1 to juego.numcolumnas do begin
			if (juego.numbarcos <> 0) and casillacoincidenteproa(juego,columna,fila) then begin
				write('P ');
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
	writeln(juego.numbarcos, ' Barcos');
	writeln(juego.numhundidos, ' Hundidos');
	escribirtablero(juego);
end;

var
	juego: TipoJuego;

begin
		leerentrada(juego);
		escribirjuego(juego);
end.
