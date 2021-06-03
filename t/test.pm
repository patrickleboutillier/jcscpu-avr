#!/usr/bin/perl


use strict ;
use Test::More ;
require simhdl ;


sub test {
	my $sim = shift ;
	my $ins = shift ;
	my $outs = shift ;

	open(CASES, "<t/$sim.tdata") or die("Can't open 't/$sim.tdata' for reading: $!") ;
	my @cases = () ;
	while (<CASES>){
		my $case = $_ ;
		chomp($case) ;
		$case =~ s/[_ ]//g ;
		next if !$case ;
		next if $case =~ /^#/ ;
		push @cases, $case ;
	}

	plan(tests => scalar(@cases)) ;

	simhdl("sim/$sim.sim") ;

	# Handle power-on-reset
	settle() ;
	setval('reset', 0) ;
	settle() ;

	foreach my $case (@cases){
		my ($is, $os) = split(/=/, $case) ;
		my @is = split(//, $is) ;
		for (my $i = 0 ; $i < scalar(@{$ins}) ; $i++){
			setval($ins->[$i], $is[$i]) ;
		}
		my $iter = settle() ;
		note("Settled after $iter iterations") ;
		my $wanted = $os ;
		my @got = '' ;
		for (my $i = 0 ; $i < scalar(@{$outs}) ; $i++){
			my $v = getval($outs->[$i]) ;
			$v = 'x' if !defined($v) ;
			push @got, $v ;
		}
		my $got = join('', @got) ;
		is($got, $wanted, "$is = $wanted") ;
	}


	return 1 ;
}


sub bus {
	my $label = shift ;
	my $n = shift || 8 ;

	return (map { $label . "[$_]" } (0 .. ($n-1))) ;
}
