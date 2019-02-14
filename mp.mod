set R;

set n_col_ini;
param col_ini {n_col_ini, L} >=0;

param aa{I2,R};
param c{R};
param fleet_size;


var x{R} binary;
var vi{I2} binary;

var fo1;
var fo2;

minimize MasterProb:  fo1 + fo2;

subject to fo1res:
	fo1 = sum{r in R} c[r]*x[r];
subject to fo2res:
	fo2 = sum{i in I2} penalty[i]*vi[i];

subject to res0{i in I2}:
	vi[i] + sum{r in R} aa[i,r]*x[r] = 1;

subject to res1:
	sum{r in R} x[r] <= fleet_size;
