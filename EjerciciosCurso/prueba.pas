{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program prueba.p;

function prueba1(x,y: integer):integer;
begin
	result := x + y;
end;


const
	P1 = 5;
	P2 =6;

var
	A: integer;

begin
	writeln(prueba1(P1,P2));
	readln(A);
end.
