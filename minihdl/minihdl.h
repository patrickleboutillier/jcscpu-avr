#ifndef MINIHDL_H
#define MINIHDL_H


#define module void
#define input 	
#define output 	


class wire {
  public:
    unsigned int id() ;
    wire(bool defval, const char *label) ;
    wire(const char *label) ;
    wire() ;
    ~wire() ;
    void assign(wire other) ;
    static wire vcc ;
    static wire gnd ;
    static wire reset ;
  private:
    unsigned int _id ;
    char *_label ;
    bool _assigned ;
    bool _defval ;
} ;



class nand {
  public:
    nand(wire a, wire b, wire c) ;
} ;



class or_ {
  public:
    or_(wire a, wire b, wire c) ;
} ;



#define MAX_EOR_INPUTS 256

class eor {
  public:
    eor(wire o) ;
    ~eor() ;
    void add_input(wire w) ;
    wire out() ;
  private:
    wire *_output ;
    wire *_inputs[MAX_EOR_INPUTS] ;
    int _idx ;
} ;


class wor : public wire {
  public:
    wor() ;
    wor(const char *label) ;
    ~wor() ;
    void assign(wire w) ;
    wire out() ;
  private:
    eor *_eor ;
} ;



class bus {
  public:
    bus(int n, const char *label) ;
    bus(int n) ;
    wire *wires() ;
  private:
    int _n ;
    wire *_wires ;
} ;



class busor {
  public:
    busor(int n, wire *os) ;
    busor(int n) ;
    ~busor() ;
    wire *get_output() ;
    wire *new_input() ;
    wire *new_input(const char *label) ;
  private:
    int _n ;
    wire *_output ;
    eor *_eors ;
} ;



void init() ;
void done() ;


#endif
