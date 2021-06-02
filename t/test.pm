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
		push @cases, $case ;
	}

	plan(tests => scalar(@cases)) ;

	simhdl("sim/$sim.sim") ;

	foreach my $case (@cases){
		my ($is, $os) = split(/=/, $case) ;
		my @is = split(//, $is) ;
		for (my $i = 0 ; $i < scalar(@{$ins}) ; $i++){
			setval($ins->[$i], $is[$i]) ;
		}
		settle() ;
		my $wanted = $os ;
		my @got = '' ;
		for (my $i = 0 ; $i < scalar(@{$outs}) ; $i++){
			push @got, getval($outs->[$i]) ;
		}
		my $got = join('', @got) ;
		is($got, $wanted, "$is = $wanted") ;
	}

	return 1 ;
}

