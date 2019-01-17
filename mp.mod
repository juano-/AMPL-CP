set R;

param aa{I1 union I2,R};    #matriz de columnA
param c{R};					#Costo de la ruta en horas.



var x{R} binary;			#Si se usa la ruta R o no.
var vi{I1 union I2} binary; #Si cliente i, está dentro de alguna ruta o no.


minimize MasterProb: sum{r in R} c[r]*x[r] + sum{i in I1 union I2} penalty[i]*vi[i];

subject to res0{i in I1 union I2}: vi[i] + sum{r in R} aa[i,r]*x[r] >= 1;

#Flota restringida a 12 técnicos.
#subject to res12: sum{r in R} x[r] <= 12;
