#Cardinalidad del grupo de clientes.
param C; #numero de clientes
param Lcap; #largo maximo de la ruta

#Set de Nodos Iniciales y Finales 
set I1 := {0}; #nodo depot
set I3 := C+1..C+Lcap-2; #nodos ficticios (servicio 0 pero tienen tiempo de viaje!!!)

# Set de Clientes. 
set I2 := 1..C;
set nodes := I1 union I2 union I3;

#Capacidad maxima diaria.
set L := 1..Lcap;

#set de comunas
set orig;
set dest;
set links within {orig,dest};

param t_cost {links} >=0;
param times{nodes,nodes};


#Data en cada Nodo
param place{nodes};		#comuna-no se usa
param penalty{nodes};	#costo por no atender
param service{nodes};	#tiempo servicio
#param totalservice;	

var s{L} integer >=0;	#Indica el numero (nombre) del cliente que esta en la posicion L
var w{L} >=0;			#instante en que se inicia la atencion en el nodo L
var d{L} >=0;			#atraso con que se llega al nodo L con respecto al fin de la jornada (debia ser TW)
var a{nodes} binary;	#Si e cliente 1 fue atendido en esta ruta.
var t{1..4} >=0;		#Tiempo de viaje entre nodos (Lcap-1)..

#variables dual del primal.
#param pi{I1 union I2};

#SP1.
#minimize SubProb: 5; #Busco una solucion factible.
minimize SubProb: 0.75*sum{l in L} d[l] + 0.25*sum{l in 1..4} t[l];
#minimize SubProb: 0.75*sum{l in L} d[l] + 0.25*w[5] - sum{i in I1 union I2} pi[i]*a[i] ;

#aux: Define el tiempo de la ruta -> tiempos de viaje fijo + Tservicio.
subject to aux{l in 1..4}: exists{i in nodes, j in nodes diff {i}} s[l] = i and s[l+1]=j and t[l] = times[i,j];

#res19
subject to allDifferents{i in L, j in L}: i!=j ==> s[i] != s[j]; 

subject to timing1: w[1] = 0;

#Restriccion de tiempo.
subject to timing2 {l in 2..Lcap}: exists{i in nodes, j in nodes diff {i} } w[l] = w[l-1] + times[i,j] + service[i] and s[l-1]=i and s[l]=j; 

#res 18:
subject to timing3{l in L}: d[l] = max(w[l]-8,0);

#rest 20:
subject to init: s[1] = 0;

#rest 21:
subject to second: s[2] <= C;

#res22:
subject to res22{l in 3..Lcap}: s[l] <= C+Lcap-2;

#res23:
subject to res23{l in 3..Lcap-1, i in I3}: s[l] = i ==> s[l+1] = i+1;

#res 24 y 25:
subject to aCol1: sum{i in nodes} a[i] = 5;
subject to aCol2{l in L}: exists{i in nodes}  a[i] = 1 and s[l] = i;

#res28 y 29:
subject to res28{l in 3..Lcap}: s[l] >= C+1 ==> s[l-1] = s[l]-1;
subject to res29{l in 3..Lcap}: s[l] <= C+1 ==> s[l-1] <= C+1;