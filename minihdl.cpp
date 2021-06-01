
#include <stdio.h>
#include "minihdl.h"


unsigned int wirecnt = 3 ;
unsigned int gatecnt = 0 ;


wire::wire(){ 
  _id = wirecnt++ ; 
} ;


unsigned int wire::id(){ 
  return _id ; 
} ;


nand::nand(wire a, wire b, wire c){ 
  printf("%s  (gate){NAND, %d, %d, %d}", (gatecnt++ > 0 ? ",\n" : ""), a.id(), b.id(), c.id()) ; 
}



void init(){
  printf("#include \"sim.h\"\n") ;
  printf("\n") ;
  printf("PROGMEM const gate gates[] = {\n") ;
}


void done(){
  printf("\n} ;\n") ;
  printf("word gatecnt = %d ;\n", gatecnt) ;
  printf("word wirecnt = %d ;\n", wirecnt) ;
  printf("\n") ;
  printf("sim s(gates, gatecnt, wirecache) ;\n") ;
}
