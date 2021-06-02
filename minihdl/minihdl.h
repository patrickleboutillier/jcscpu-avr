#ifndef MINIHDL_H
#define MINIHDL_H


#define input 	wire
#define output 	wire


class wire {
  public:
    unsigned int id() ;
    wire() ;
    wire(const char *label) ;
    static wire *bus(int n) ;
    static wire *bus(int n, const char *label) ;
    static wire one() ;
    static wire zero() ;
  private:
    wire(unsigned int id) ;
    unsigned int _id ;
} ;


class nand {
  public:
    nand(wire a, wire b, wire c) ;
} ;


void init() ;
void done() ;


#endif
