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
		elsif ($verb eq 'OR'){
			my ($id, $a, $b, $c) = @args ;
			$GATES[$id] = { type => 'OR', a => $a, b => $b, c => $c } ; 
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


sub setbusval {
	my $label = shift ;
	my $val = shift ;
	my $len = shift || 8 ;

    my @vals = split('', sprintf("%0${len}b", $val)) ;
    map { setval("${label}[$_]", $vals[$_]) } (0 .. ($len-1)) ;
}


sub getval {
	my $label = shift ;

	my $w = $LABELS{$label} ;
	die("No wire named '$label' was found!") unless defined($w) ;
	$WIRES[$w] ;
}


sub getbusval {
	my $label = shift ;
	my $len = shift || 8 ;

	my @bus = map { getval("${label}[$_]") } (0 .. ($len-1)) ;
	return oct("0b" . join('', @bus)) ;	
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
			elsif ($g->{type} eq 'OR'){
				$cur = or_($g) ;
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


sub or_ {
	my $g = shift ;

	return (($WIRES[$g->{a}] | $WIRES[$g->{b}]) ? 1 : 0) ;
}


return 1 ;
