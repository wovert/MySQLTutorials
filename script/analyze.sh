#!/bin/bash
awk '
   BEGIN {
     printf "#ts date time load QPS";
     fmt=" %.2f";
   }
   /^TS/ {
   ts = substr($2,1,index($2,".")-1);
   load = NF -2;
   diff = ts - prev_ts;
   printf "\n%s %s %s %s",ts,$3,$4,substr($load,1,length($load)-1);
   prev_ts=ts;
   }
   /Queries/{
   printf fmt,($2-Queries)/diff;
   Queries=$2
   }
   ' "$@"
