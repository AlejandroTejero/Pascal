{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio9.p;

const
	Maxpalabra = 25;
	Maxnumpalabras = 30;
	Esp = ' ';
	Tab = '	'; 

type
	TipoPalabra = string; {Todos los caracteres ascii}
	TipoPalabras = array[1..Maxnumpalabras] of TipoPalabra;
	TipoEstoyLeyendo = (LeoPalabra,FinFrase,FinFichero);
	TipoFrase = record
		palabras: TipoPalabras;
		numpalabras: integer;
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

function esminuscula(c: char): boolean;
begin
	result := (c >= 'a') and (c <= 'z');
end;

function mintomayus(c: char):char;
begin
	if not esminuscula(c) then begin
		result := c;
	end
	else begin
		result := char(ord(c) - ord('a') + ord('A'));
	end;
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
		addcar(palabra,mintomayus(c));
		if eof(fichero) or eoln(fichero) then begin
			haypalabra := False;
		end
		else begin
			read(fichero,c);
			haypalabra := not esblanco(c);
		end;
	end;
end;

function palabratieneletra(palabra: TipoPalabra; letra: char):boolean;
var
	poseeletra: boolean;
	letrayuda: char;
	i: integer;
begin
	poseeletra := False;
	i := 1;
	while(i <= length(palabra)) and (not poseeletra) do begin
		letrayuda := palabra[i];
		if letrayuda = letra then begin
			poseeletra := True;
		end;
		i := i + 1;
	end;
	result := poseeletra;
end;

function frasetieneletra(frase: TipoFrase; letra: char):boolean;
var
	poseeletra: boolean;
	palabra: TipoPalabra;
	i: integer;
begin
	poseeletra := False;
	i := 1;
	while (not poseeletra) and (i <= frase.numpalabras) do begin
		palabra := frase.palabras[i];
		if palabratieneletra(palabra,letra) then begin 
			poseeletra := True;
		end;
		i := i +1;
	end;
	result:= poseeletra;
end;

function espangrama(frase: TipoFrase):boolean;
var
	loes: boolean;
	letra: char;
begin
	loes := True;
	letra := 'A';
	while (loes) and (letra <= 'Z') do begin
		if not frasetieneletra(frase,letra) then begin
			loes := False;
		end;
	letra := succ(letra);
	end;
	result := loes;
end;

procedure leerfrase(var fichero: text; var frase: TipoFrase; var que: TipoEstoyLeyendo);
var
	palabra: TipoPalabra;
begin
	frase.numpalabras := 0;
	repeat
		leerpalabra(fichero,palabra);
		if palabra = '' then begin
			que := FinFichero;
		end
		else begin 
			frase.numpalabras := frase.numpalabras + 1;
			frase.palabras[frase.numpalabras] := palabra;
			if palabra[length(palabra)] = '.' then begin
				que := FinFrase;
			end
			else begin
				que := LeoPalabra;
			end;
		end;
	until (que <> LeoPalabra) or (frase.numpalabras = Maxnumpalabras);
end;

procedure escribirfrase(frase: TipoFrase);
var
	i: integer;
begin
	for i := 1 to frase.numpalabras - 1 do begin
		write((frase.palabras[i]),' ');
	end;
	write(frase.palabras[frase.numpalabras], ' '); {Escribe la ultima palabra con el .}
	writeln('(',frase.numpalabras,' palabras)');
end;

var
	fichero: text;
	frase: TipoFrase;
	que: TipoEstoyLeyendo;

begin
	assign(fichero, 'datos9.txt');
	reset(fichero);
	repeat
		leerfrase(fichero,frase,que);
		if (que = FinFrase) and (espangrama(frase)) then begin
			escribirfrase(frase);
		end;
	until que = FinFichero;
	close(fichero);
end.
	
	
	
	
