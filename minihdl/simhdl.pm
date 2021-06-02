#!/usr/bin/perl


use strict ;
use Data::Dumper ;


my @GATES = () ;
my @CACHE = () ;
my %WIRES = () ;


sub simhdl {
	my $sim = shift ;

	open(SIM, "<$sim") || die("Can't open file '$sim' for reading: $!") ;
	while (<SIM>){
		my $line = $_ ;
		chomp($line) ;

		my ($verb, @args) = split(/\s+/, $line) ;
		if ($verb eq 'WIRE'){
			$WIRES{$args[1]} = $args[0] ;
		}
		elsif ($verb eq 'NAND'){
			my $nand = { type => 'NAND', a => $args[0], b => $args[1], c => $args[2] } ;
			push @GATES, $nand ;
		}
	}
}


sub setval {
	my $label = shift ;
	my $v = shift ;

	my $w = $WIRES{$label} ;
	die("No wire named '$label' was found!") unless defined($w) ;
	$CACHE[$WIRES{$label}] = $v ;
}


sub getval {
	my $label = shift ;
	my $v = shift ;

	my $w = $WIRES{$label} ;
	die("No wire named '$label' was found!") unless defined($w) ;
	return $CACHE[$WIRES{$label}] ;
}


sub settle {
	my $change = 1 ;

	while ($change){
		$change = 0 ;
		foreach my $g (@GATES) {
			if ($g->{type} eq 'NAND'){
				my $va = $CACHE[$g->{a}] ;
				my $vb = $CACHE[$g->{b}] ;
				my $c = $g->{c} ;
				if (defined($va) && defined($vb)){
					my $prev = $CACHE[$c] ;
					my $cur = (! ($va & $vb)) || 0 ;
					if ((! defined($prev))||($cur != $prev)){
						$CACHE[$c] = $cur ;
						$change = 1 ;
						# warn "$c changed: '$prev' -> '$cur'\n" ;
					}
				}
			}
		}
	}
}



return 1 ;
