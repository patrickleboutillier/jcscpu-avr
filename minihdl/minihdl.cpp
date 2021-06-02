
#include <stdio.h>
#include "minihdl.h"


unsigned int wirecnt = 3 ;
unsigned int gatecnt = 0 ;


wire::wire(){ 
 	_id = wirecnt++ ;
	// printf("WIRE %d\n", _id) ;
} ;


wire::wire(const char *label){ 
 	_id = wirecnt++ ;
	printf("WIRE %d %s\n", _id, label) ;
} ;


unsigned int wire::id(){ 
 	return _id ; 
} ;


nand::nand(wire a, wire b, wire c){ 
 	printf("NAND %d %d %d\n", a.id(), b.id(), c.id()) ; 
	gatecnt++ ;
}


void init(){
}


void done(){
 	printf("# wirecnt = %d\n", wirecnt) ; 
 	printf("# gatecnt = %d\n", gatecnt) ; 
}
