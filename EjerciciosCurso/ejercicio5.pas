{$mode objfpc}{$H-}{$R+}{$T+}{$Q+}{$V+}{$D+}{$X-}{$warnings on}

program ejercicio5.p;

type
	TipoNombreEquipo = (Ferrari,Mercedes,Redbull);
	TipoConfiguracion = (alta,baja);
	TipoColor = (Rojo,blanco,Azul);
	TipoNombrePiloto = (Leclerc,Sainz,Alonso);
	TipoPuntos = 0..12;
	
	TipoCoche = record
		motor: integer;
		configuracion: TipoConfiguracion;
		color: TipoColor;
	end;
	
	TipoPiloto = record
		nombre: TipoNombrePiloto;
		puntos: TipoPuntos;
		segundos: integer;
	end;
	
	TipoEquipo = record
		nombre: TipoNombreEquipo;
		coche: TipoCoche;
		piloto: TipoPiloto;
		tiempometa: integer;
	end;

procedure leercoche(var coche: TipoCoche);
begin
	write('Tipo de motor: ');
	readln(coche.motor);
	write('Tipo de configuracion aerodinamica: ');
	readln(coche.configuracion);
	write('Introducir color: ');
	readln(coche.color);
end;

procedure leerpiloto(var piloto: TipoPiloto);
begin
	write('Nombre del piloto: ');
	readln(piloto.nombre);
	write('Puntos de superlicencia: ');
	readln(piloto.puntos);
	write('Segundos de penalizacion: ');
	readln(piloto.segundos);
end;

procedure leerequipo(var equipo: TipoEquipo);
begin
	write('Introducir nombre del equipo: ');
	readln(equipo.nombre);
	leercoche(equipo.coche);
	leerpiloto(equipo.piloto);
	write('Tiempo en llegar a meta: ');
	readln(equipo.tiempometa);
	writeln();
end;

procedure escribircoche(coche: TipoCoche);
begin
	writeln('Coche: ',coche.motor,' cilindros carga ',coche.configuracion,' ',coche.color);
end;

procedure escribirpiloto(piloto: TipoPiloto);
begin
	writeln('Piloto: ',piloto.nombre,' ',piloto.puntos,' puntos penalizacion ',piloto.segundos,' segundos');
end;

procedure escribirquipo(equipo: TipoEquipo);
begin
	writeln('Ganador: ',equipo.nombre);
	escribircoche(equipo.coche);
	escribirpiloto(equipo.piloto);
	writeln('Tiempo sin penalizacion: ',equipo.tiempometa,' segundos');
end;

function tiempototal(equipo: TipoEquipo):integer;
begin
	if equipo.nombre = Ferrari then begin
		result := 0;
	end
	else if equipo.piloto.puntos = 0 then begin
		result := Maxint;
	end
	else begin
		result := equipo.tiempometa + equipo.piloto.segundos;
	end;
end;

function esmejorpiloto(piloto1,piloto2: TipoPiloto):boolean;
begin
	result := piloto1.nombre < piloto2.nombre;
end;

function equipoganador (equipo1,equipo2: TipoEquipo): TipoEquipo;
var 
	tiempofinaleq1,tiempofinaleq2: integer;
begin
	tiempofinaleq1 := tiempototal(equipo1);
	tiempofinaleq2 := tiempototal(equipo2);
	if tiempofinaleq1 = tiempofinaleq2 then begin
		if esmejorpiloto(equipo1.piloto,equipo2.piloto) then begin
			result := equipo1;
		end
		else begin 
			result := equipo2;
		end;
	end
	else if tiempofinaleq1 < tiempofinaleq2 then begin
		result := equipo1;
	end
	else begin
		result := equipo2;
	end;
end;



var
	equipo1,equipo2,equipo3: TipoEquipo;

begin 
	leerequipo(equipo1);
	leerequipo(equipo2);
	leerequipo(equipo3);
	escribirquipo(equipoganador(equipoganador(equipo1,equipo2),equipo3)); {crear sino un equipoganador y meter dentro mejorequipo}
end.
