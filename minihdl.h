#ifndef MINIHDL_H
#define MINIHDL_H


#define input 	wire
#define output 	wire


class wire {
  public:
    unsigned int id() ;
    wire() ;
    wire(int io) ;
  private:
    unsigned int _id ;
} ;


class nand {
  public:
    nand(wire a, wire b, wire c) ;
} ;


void init() ;
void done() ;


#endif
