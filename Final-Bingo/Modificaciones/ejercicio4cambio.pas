{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio4;

const
	A:integer = 10;
	B:integer = 20;
	C:integer = 30;
	D:integer = 40;

procedure leerboolean (var b: boolean);
var
	c :char;
begin
	readln(c);
	b := (c = 's') or (c = 'S');
end;

procedure leerdeclaracion (var dinero,porcentaje,numminimo: integer;
var minimoimpo: boolean; var tramo: char;var privilegios: boolean);
begin
	write('Introducir dinero ganado: ');
	readln(dinero);
	write('Introducir porcentaje fijo: ');
	readln(porcentaje);
	write('¿Existe minimo imponible? ');
	leerboolean(minimoimpo);
	if minimoimpo then begin 
		write('Introducir minimo imponible: ');
		readln(numminimo);
	end;
	write('Introducir tramo: ');
	readln(tramo);
	write('Tiene privilegios: ');
	leerboolean(privilegios);
end;

procedure escribirdeclaracion (dinero,porcentaje,numminimo: integer;minimoimpo: boolean;tramo: char);
begin
	writeln();
	writeln('Resumen de la declaracion: ');
	writeln('Dinero ganado: ',dinero);
	writeln('Porcentaje fijo: ',porcentaje);
	writeln('Existencia de minimo imponible: ',minimoimpo);
	if 	minimoimpo then begin
		writeln('Cantidad del minimo imponible: ',numminimo);
		writeln('Tramo introducido: ',tramo);
	end
	else begin
		writeln('Tramo introducido: ',tramo);
	end;
end;

function sirestardinero(dinero,numminimo: integer;minimoimpo: boolean;privilegios: boolean): boolean;
begin
	result := (not privilegios) and ((minimoimpo) and (dinero >= numminimo)) or (not minimoimpo);
end;

function tipotramo (tramo: char):integer;
begin
	case tramo of
		'A','a':
			result := A;
		'B','b':
			result := B;
		'C','c':
			result := C;
		'D','d':
			result := D;
		end;
end;

function valorporcentaje(dinero,porcentaje: integer):integer;
begin
	result := (porcentaje * dinero) div 100;
end;

function dineroexpolio(dinero,porcentaje,numminimo: integer; minimoimpo: boolean; tramo: char;privilegios: boolean): integer;
begin
	if sirestardinero(dinero,numminimo,minimoimpo,privilegios) then begin
		result := valorporcentaje(dinero,porcentaje) + valorporcentaje(dinero,tipotramo(tramo));
	end
	else begin 
		result := 0;
	end;
end;

function dinerocuidadano(dinero,porcentaje,numminimo: integer;minimoimpo: boolean;tramo: char;privilegios: boolean): integer;
begin
	if privilegios then begin
		result := dinero + 400;
	end
	else begin
		result := dinero - dineroexpolio(dinero,porcentaje,numminimo,minimoimpo,tramo,privilegios);
	end;
end;

var
	dinero,porcen,cantidadminimo: integer;
	minimoimpo,privilegios: boolean;
	tramo: char;

begin 
	leerdeclaracion(dinero,porcen,cantidadminimo,minimoimpo,tramo,privilegios);
	escribirdeclaracion(dinero,porcen,cantidadminimo,minimoimpo,tramo);
	writeln('Dinero expoliado: ',dineroexpolio(dinero,porcen,cantidadminimo,minimoimpo,tramo,privilegios));
	writeln('Dinero perteneciente al contribuyente: ',dinerocuidadano(dinero,porcen,cantidadminimo,minimoimpo,tramo,privilegios));
end.

