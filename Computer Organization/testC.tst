load Larc.hdl,

set RAM16K[0]  %X8105,    // 5 in $1
set RAM16K[1]  %X8207,    // 7 in $2
set RAM16K[2]  %XD021,
set RAM16K[3]  %XD012,
set RAM16K[4]  %XC105,    // 7 in $1
set RAM16K[5]  %XC207,    // 5 in $2
set RAM16K[6]  %X1321,    // -2 in $3
set RAM16K[7]  %XF000
;

repeat 30 { tick, tock; }
