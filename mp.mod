set R;

param aa{I2,R};
param c{R};


var x{R} binary;
var vi{I2} binary;


minimize MasterProb: sum{r in R} c[r]*x[r] + sum{i in I2} penalty[i]*vi[i];

subject to res0{i in I2}: vi[i] + sum{r in R} aa[i,r]*x[r] = 1;
subject to res1: sum{r in R} x[r] <= 8;