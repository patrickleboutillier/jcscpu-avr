
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "minihdl.h"


unsigned int wirecnt = 1 ;
unsigned int gatecnt = 1 ;


wire wire::gnd = wire(0, "GND") ;				// wire 1
wire wire::vcc = wire(1, "VCC") ;				// wire 2
wire wire::reset = wire(1, "RESET") ;	  		// wire 3


wire::wire(bool defval, const char *label){ 
	_assigned = false ;
	_defval = defval ;
	_label = (label == NULL ? NULL : strdup(label)) ;
 	_id = wirecnt++ ;
} ;


wire::wire(const char *label) : wire(0, label){} ;
wire::wire() : wire(0, NULL){} ;


wire::~wire(){
	printf("WIRE %d %d %s\n", _id, (_defval ? 1 : 0), (_label != NULL ? _label : "")) ;	
}


void wire::assign(wire other){
	_id = other.id() ;
	_assigned = true ;
}


unsigned int wire::id(){ 
 	return _id ; 
} ;



nand::nand(wire a, wire b, wire c){
 	printf("NAND %d %d %d %d\n", gatecnt, a.id(), b.id(), c.id()) ; 
	gatecnt++ ;
}



or_::or_(wire a, wire b, wire c){
 	printf("OR %d %d %d %d\n", gatecnt, a.id(), b.id(), c.id()) ; 
	gatecnt++ ;
}



eor::eor(wire o){
	_output = new wire(o) ;
	for (int i = 0 ; i < MAX_EOR_INPUTS ; i++){
		_inputs[i] = NULL ;
	}
	_idx = 0 ;
}


eor::~eor(){
	switch (_idx){
		case 0: break ;
		case 1: {
			or_ or0(*_inputs[0], *_inputs[0], *_output) ; 
			break ;
		}
		case 2: {
			or_ or0(*_inputs[0], *_inputs[1], *_output) ; 
			break ;
		}
		default: {
			wire os[_idx-2] ;
	  		or_ or0(*_inputs[0], *_inputs[1], os[0]) ;
		    for (int j = 0; j < (_idx-2); j = j + 1){
      			or_ oj(os[j], *_inputs[j+2], (j == (_idx-3) ? *_output : os[j+1])) ;
			}
		}
	}
}


void eor::add_input(wire i){
	_inputs[_idx++] = new wire(i) ;
}


wire eor::out(){
	return *_output ;
}


wor::wor(const char *label) : wire(label){
	_eor = new eor(*this) ;
}


wor::wor() : wor(NULL){}


wor::~wor(){
	delete _eor ;
}


wire wor::out(){
	return _eor->out() ;
}


void wor::assign(wire i){
	_eor->add_input(i) ;
}



bus::bus(int n, const char *label){
	_n = n ;
	_wires = (wire *)malloc(_n * sizeof(wire)) ;
	for (int i = 0 ; i < _n ; i++){
		if (label == NULL){
			_wires[i] = wire() ;
		}
		else {
			int l = strlen(label) + 8 + 1 ;
			char buf[l] ;
			sprintf(buf, "%s[%d]", label, i) ;
			_wires[i] = wire(buf) ;
		}
	}
}


bus::bus(int n) : bus(n, NULL){} ;


wire *bus::wires(){
	return _wires ;
}



// busor should receive o as parameter?
busor::busor(int n, wire *os){
	_n = n ;
	_output = (wire *)malloc(_n * sizeof(wire)) ;
	memcpy(_output, os, _n * sizeof(wire)) ;
	_eors = (eor *)malloc(_n * sizeof(eor)) ;
	for (int i = 0 ; i < _n ; i++){
		_eors[i] = eor(_output[i]) ;
	}
}


busor::busor(int n) : busor(n, new wire[n]){}

busor::~busor(){
	for (int i = 0 ; i < _n ; i++){
		_eors[i].~eor() ;
	}
}


wire *busor::new_input(){
	return new_input(NULL) ;
}


wire *busor::new_input(const char *label){
	wire *ret = (wire *)malloc(_n * sizeof(wire)) ;
	for (int i = 0 ; i < _n ; i++){
		if (label == NULL){
			ret[i] = wire() ;
		}
		else {
			int l = strlen(label) + 8 + 1 ;
			char buf[l] ;
			sprintf(buf, "%s[%d]", label, i) ;
			ret[i] = wire(buf) ;
		}
		_eors[i].add_input(ret[i]) ;
	}

	return ret ;
}


wire *busor::get_output(){
	return _output ;
}


void init(){
}


void done(){
 	printf("# wirecnt = %d\n", wirecnt - 1) ; 
 	printf("# gatecnt = %d\n", gatecnt - 1) ; 
}
