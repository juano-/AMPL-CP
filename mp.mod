set R;

param aa{I1 union I2,R};
param c{R};


var x{R} binary;
var vi{I1 union I2} binary;


minimize MasterProb: sum{r in R} c[r]*x[r] + sum{i in I1 union I2} penalty[i]*vi[i];

subject to res0{i in I1 union I2}: vi[i] + sum{r in R} aa[i,r]*x[r] >= 1;