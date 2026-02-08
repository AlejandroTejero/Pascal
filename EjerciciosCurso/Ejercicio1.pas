{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio1;

uses math;

const
	Pi: real = 3.1415;
	
	N1: integer = 8;
	C1: char = 'B';
	C2: char = 'b';
	C3: char = '9';
	C4: char = 'd';
	Base: real = 2.0;
	Altura: real = 3.0;
	Radio: real = 2.0;
	A: real = 1.0;
	B: real = 3.0;
	C: real = 2.0;

begin
	writeln(chr((ord(C1) - ord('A')) + ord('a')));
	writeln(chr((ord(C2) - ord('a')) + ord('A')));
	writeln((ord(C3) - ord('0')) * 2);
	writeln(N1 mod 2 = 0);
	writeln(((ord(C4) - ord('a')) + 1) mod 2 <> 0);
	writeln((Base * Altura):0:2);
	writeln(4 / 3 * Pi * (Radio **3):0:2);
	writeln((Base * Altura) = (Pi * (Radio**2)));
	writeln(((-B + sqrt(sqr(B) - 4 * A * C)) / (2 * A)):0:2);
end.
