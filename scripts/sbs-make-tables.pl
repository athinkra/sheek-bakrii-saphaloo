#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;
use open ':encoding(utf-8)';

main:
{
	my $start = hex( "0xE000" );
	my $end   = hex( "0xE317" );
	my $i = 1;
	for my $c ( $start .. $end ) {
		if( ($i % 12) == 0 ) {
			print chr($c), "\n";
		}
		else {
			print chr($c), "\t";
		}
		$i ++;
	}

}
