#!/usr/bin/perl


use strict ;
use Test::More ;
require sim ;


sub test {
	my $sim = shift ;
	my $ins = shift ;
	my $outs = shift ;

	plan(tests => scalar(@{$cases})) ;

	sim("modules/$sim.mod") ;

	foreach my $case (@{$cases}){
		chomp($case) ;
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

