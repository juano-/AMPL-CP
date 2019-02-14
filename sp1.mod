#Cardinalidad del grupo de clientes.
param C; #numero de clientes
param Lcap; #largo maximo de la ruta

#Set de Nodos Iniciales y Finales 
set I3 := C+1..C+Lcap-2; #nodos ficticios (servicio 0 pero tienen tiempo de viaje!!!)

# Set de Clientes. 
set I2 := 1..C;
set nodes := I2 union I3;

#Capacidad maxima diaria.
set L := 1..Lcap;

#set de comunas
set orig;
set dest;
set links within {orig,dest};

param t_cost {links} >=0;
param times{nodes,nodes};


#Data en cada Nodo
param place{nodes};		#comuna
param penalty{nodes};	#costo por no atender
param service{nodes};	#tiempo servicio

var s{L} integer >=0;			#Vector de posicion del cliente en la ruta.
var w{L} integer >=0;			#instante en que se inicia la atencion en el nodo L
var d{L} integer >=0;			#atraso con que se llega al nodo L con respecto al fin de la jornada (debia ser TW)
var a{nodes} binary;			#Si e cliente 1 fue atendido en esta ruta.
var t{1..Lcap-1} integer >=0;		#Tiempo de viaje entre nodos (Lcap-1)..

#variables dual del primal.
param pi{I2};
param mu;

#SP.
minimize SubProb: sum{l in L} d[l] + sum{l in 1..Lcap-1} t[l] - sum{i in I2} pi[i]*a[i] -mu;

#aux: Define el tiempo de la ruta -> tiempos de viaje fijo + Tservicio.
subject to aux{l in 1..4}: exists{i in nodes, j in nodes} t[l] = times[i,j] and s[l] = i and s[l+1]=j;

#res19
#subject to allDifferents{i in L, j in L}: i!=j ==> s[i] != s[j]; 
subject to allDifferents: alldiff{l in L} s[l]; 


subject to timing1: w[1] = 0;

#Restriccion de tiempo.
subject to timing2 {l in 2..Lcap}: exists{i in nodes} s[l-1]=i and w[l] = w[l-1] + t[l-1] + service[i]; 


#res 18:
subject to timing3{l in L}: d[l] = max(w[l]-480,0);

#rest 20:
subject to init: s[1] <= C;

#rest 21:
subject to second: s[2] <= C;

#res22:
subject to res22{l in 3..Lcap}: s[l] <= C+Lcap-2;

#res23:
subject to res23{l in 3..Lcap-1, i in I3}: s[l] = i ==> s[l+1] = i+1;

#res 24 y 25:
subject to aCol1: sum{i in nodes} a[i] = 5;
subject to aCol2{l in L}: exists{i in nodes} s[l] = i and a[i] = 1;

#res28 y 29:
subject to res28{l in 3..Lcap}: s[l] > C+1 ==> s[l-1] = s[l]-1;
subject to res29{l in 3..Lcap}: s[l] <= C+1 ==> s[l-1] < C+1;