{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio3;

uses math;
const
	Binario = 2;
	Octal = 8;
	Decimal = 10;
	Hexadecimal = 16;


function sibaseok (b: integer): boolean;
begin
	result := (b = Binario) or (b = Octal) or (b = Decimal) or (b = Hexadecimal);
end;


function sidigitook (d: char; base: integer): boolean;
begin
	case base of
		Binario:
			result := (d >= '0') and (d <= '1');
		Octal:
			result := (d >= '0') and (d <= '7');
		Decimal:
			result := (d >= '0') and (d <= '9');
		Hexadecimal:
			result := (d >= '0') and (d <= '9') 
			or (d >= 'A') and (d <= 'F') 
			or (d >= 'a') and (d <= 'f');
	end;
end;

function sinumok (d1,d2,d3: char; b: integer): boolean;
begin
	result := sibaseok(b) and 
	sidigitook(d1,b) and 
	sidigitook(d2,b)and 
	sidigitook(d3,b);
end;

function esminuscula(c: char): boolean;
begin
	result := (c >= 'a') and (c <= 'z');
end;

function minustomayus(c: char): char;
begin
	result := chr((ord(c) - ord ('a') + ord('A')));
end;

function digtomayus (d: char): char;
begin
	if esminuscula(d) then begin
		result:= minustomayus(d);
	end
	else begin 
		result := d;
	end;
end;

function charainteger(d:char):integer;
begin
	case d of
		'0'..'9':
			result := ord(d) - ord('0');
		'A'..'F':
			result := ord(d) - ord ('A') + Decimal;
		'a'..'f':
			result := ord(d) - ord ('a') + Decimal;
	end;
end;

function valordecimal(d1,d2,d3: char; b:integer):integer;
begin
	result := charainteger(d1) * b**2 +
	charainteger(d2) * b +
	charainteger(d3)  
end;

function espar(n: integer): boolean;
begin
	result := n mod 2 = 0;
end;

function menordigito(d1,d2: char): char;
begin
	if charainteger(d1) < charainteger(d2) then begin
		result := d1;
	end
	else begin
		result := d2;
	end;
end;

function mayordigito(d1,d2: char): char;
begin
	if charainteger(d1) > charainteger(d2) then begin
		result := d1;
	end
	else begin
		result := d2;
	end;
end;

const
	D1: char = '2';
	D2: char = 'a';
	D3: char = 'f';
	Base: integer = Hexadecimal;

begin
	if sinumok(D1,D2,D3,Base) then begin
		write('El numero elegido es: ');
		writeln(digtomayus(D1),digtomayus(D2),digtomayus(D3));
		write('Su valor decimal correspondiente es: ');
		writeln(valordecimal(D1,D2,D3,Base));
		if espar(valordecimal(D1,D2,D3, Base)) then begin
			writeln ('Dicho valor es par');
		end
		else begin
			writeln('Dicho valor es impar');
		end;
		write('Su menor digito es: ');
		writeln(charainteger(menordigito(menordigito(D1,D2),D3)));
		write('Su mayor digito es: ');
		writeln(charainteger(mayordigito(mayordigito(D1,D2),D3)));
	end
	else begin
		writeln('Mal numero');
	end;
end.
