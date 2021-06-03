
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "minihdl.h"


unsigned int wirecnt = 3 ;
unsigned int gatecnt = 0 ;


wire::wire(){ 
 	_id = wirecnt++ ;
} ;


wire::wire(unsigned int id){ 
 	_id = id ;
} ;


wire::wire(const char *label) : wire(){ 
	printf("WIRE %d %s\n", _id, label) ;
} ;


wire::wire(unsigned int id, const char *label) : wire(id){ 
	printf("WIRE %d %s\n", _id, label) ;
} ;


wire wire::one(){
	return wire(1) ;
}


wire wire::zero(){
	return wire((unsigned int)0) ;
}


wire wire::reset(){
	return wire(2, "reset") ;
}


wire *wire::bus(int n){
	return new wire[n] ;
}

wire *wire::bus(int n, const char *label){
	wire *bus = (wire *)malloc(n * sizeof(wire)) ;
	for (int i = 0 ; i < n ; i++){
		int l = strlen(label) + 8 + 1 ;
		char buf[l] ;
		sprintf(buf, "%s[%d]", label, i) ;
		bus[i] = wire(buf) ;
	}
	return bus ;
}


unsigned int wire::id(){ 
 	return _id ; 
} ;


nand::nand(wire a, wire b, wire c){ 
 	printf("NAND %d %d %d\n", a.id(), b.id(), c.id()) ; 
	gatecnt++ ;
}


void init(){
	wire::reset() ;
}


void done(){
 	printf("# wirecnt = %d\n", wirecnt) ; 
 	printf("# gatecnt = %d\n", gatecnt) ; 
}
