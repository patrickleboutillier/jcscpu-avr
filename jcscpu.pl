#!/usr/bin/perl

use strict ;
use Data::Dumper ;
use lib "./minihdl" ;
require simhdl ;

# Autoflush STDOUT ;
$|++ ;

my $MAR = 0 ;
my @RAM = map { oct("0b$_") ; }grep { /[^\s]/ } map { chomp($_) ; $_ =~ s/\s*#.*$// ; $_ } (<>) ;
# print Dumper(\@RAM) ;

simhdl("sim/jCORE.sim") ;

# Handle power-on-reset
settle() ;
setval('RESET', 0) ;
settle() ;

my $tick = -1 ;
my $step = 0 ;

while (1){
    advance_clk() ;
    advance_step() ; 

    settle() ;

    if (getval("halt")){
        print("\n") ;
        exit(0) ;
    }

    handle_RAM() ;
    handle_IO() ;
}


sub advance_clk {
    # Clock
    $tick++ ;
    $tick = 0 if $tick == 4 ;
    my @clk ;
    @clk = (1, 0, 1, 0) if $tick == 0 ;
    @clk = (1, 1, 1, 1) if $tick == 1 ;
    @clk = (0, 1, 1, 0) if $tick == 2 ;
    @clk = (0, 0, 0, 0) if $tick == 3 ;
    setval("clk", $clk[0]) ;
    setval("clkd", $clk[1]) ;
    setval("clke", $clk[2]) ;       
    setval("clks", $clk[3]) ;  
}


sub advance_step {
    # Stepper
    if ($tick == 0){
        $step++ ;
        $step = 1 if $step == 7 ;
        my @steps ;
        @steps = (1, 0, 0, 0, 0, 0) if $step == 1 ;
        @steps = (0, 1, 0, 0, 0, 0) if $step == 2 ;
        @steps = (0, 0, 1, 0, 0, 0) if $step == 3 ;
        @steps = (0, 0, 0, 1, 0, 0) if $step == 4 ;
        @steps = (0, 0, 0, 0, 1, 0) if $step == 5 ;
        @steps = (0, 0, 0, 0, 0, 1) if $step == 6 ;
        map { setval("stpbus[$_]", @steps[$_]) } (0 .. 5) ;
    }
}


sub handle_RAM {
    $MAR = getbusval("bus") if getval("ram_mar_s") ;
    setbusval("bus", $RAM[$MAR]) if getval("ram_e") ;
    $RAM[$MAR] = getbusval("bus") if getval("ram_s") ;
}


my $io_dev = 0 ;
sub handle_IO {
    my ($io_s, $io_e, $io_da, $io_io) = (getval("io_s"), getval("io_e"), getval("io_da"), getval("io_io")) ;
    if ($io_s && $io_da && $io_io){
        $io_dev = getbusval("bus") ;
    }
    if ($io_s && !$io_da && $io_io){
        my $io_data = getbusval("bus") ;
        if ($io_dev == 0){
            printf("%c", $io_data) ;
        }
        if ($io_dev == 1){
            printf("%08b", $io_data) ;
        }       
    }
    if ($io_e && !$io_da && !$io_io){
		if ($io_dev == 1){
            my $rnd = int(rand(256)) ;
			setbusval("bus", $rnd) ;
        }
    }
}