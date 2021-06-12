#!/usr/bin/perl


use strict ;
use Data::Dumper ;


my @GATES = () ;
my @WIRES = () ;
my %LABELS = () ;


sub simhdl {
	my $sim = shift ;

	open(SIM, "<$sim") || die("Can't open file '$sim' for reading: $!") ;
	while (<SIM>){
		my $line = $_ ;
		chomp($line) ;
		next if $line =~ /^#/ ;

		my ($verb, @args) = split(/\s+/, $line) ;
		if ($verb eq 'WIRE'){
			my ($id, $v, $label) = @args ;
			$WIRES[$id] = $v ;
			$LABELS{$label} = $id ;
		}
		elsif ($verb eq 'NAND'){
			my ($id, $a, $b, $c) = @args ;
			$GATES[$id] = { type => 'NAND', a => $a, b => $b, c => $c } ;
		}
		elsif ($verb eq 'BUF'){
			my ($id, $a, $b) = @args ;
			$GATES[$id] = { type => 'BUF', a => $a, c => $b } ;
		}
		elsif ($verb eq 'OR'){
			my ($id, $a, $b, $c) = @args ;
			$GATES[$id] = { type => 'OR', a => $a, b => $b, c => $c } ; 
		}
		elsif ($verb eq 'AND'){
			my ($id, $a, $b, $c) = @args ;
			$GATES[$id] = { type => 'AND', a => $a, b => $b, c => $c } ; 
		}
	}
}


sub setval {
	my $label = shift ;
	my $v = shift ;

	my $w = $LABELS{$label} ;
	die("No wire named '$label' was found!") unless defined($w) ;
	$WIRES[$w] = $v ;
}


sub getval {
	my $label = shift ;

	my $w = $LABELS{$label} ;
	die("No wire named '$label' was found!") unless defined($w) ;
	$WIRES[$w] ;
}


sub settle {
	my $change = 1 ;

	my $iter = 0 ;
	while ($change){
		$iter++ ;
		$change = 0 ;
		for (my $i = 0 ; $i < scalar(@GATES) ; $i++){
			my $g = $GATES[$i] ;
			my $prev = $WIRES[$g->{c}] ; 
			my $cur ;
			if ($g->{type} eq 'NAND'){
				$cur = nand($g) ;
			}
			elsif ($g->{type} eq 'BUF'){
				$cur = buf($g) ;
			}
			elsif ($g->{type} eq 'OR'){
				$cur = or_($g) ;
			}
			elsif ($g->{type} eq 'AND'){
				$cur = and_($g) ;
			}

			if ($cur != $prev){
				$WIRES[$g->{c}] = $cur ;
				$change = 1 ;
				# warn "$c changed: '$prev' -> '$cur' ($g->{a}, $g->{b})\n" ;
			}
		}
	}

	return $iter ;
}


sub nand {
	my $g = shift ;

	return (($WIRES[$g->{a}] & $WIRES[$g->{b}]) ? 0 : 1) ;
}


sub buf {
	my $g = shift ;

	return $WIRES[$g->{a}] ;
}


sub or_ {
	my $g = shift ;

	return (($WIRES[$g->{a}] | $WIRES[$g->{b}]) ? 1 : 0) ;
}


sub and_ {
	my $g = shift ;

	return (($WIRES[$g->{a}] & $WIRES[$g->{b}]) ? 1 : 0) ;
}


return 1 ;
