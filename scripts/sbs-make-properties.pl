#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;
use open ':encoding(utf-8)';

main:
{
	my @Syllables = (
		" BASE",
		"A",
		"U",
		"I",
		"E",
		"O",
		"AA",
		"UU",
		"II",
		"EE",
		"OO",
		" CONSONANT"
	);

	$_ = <>;
	$_ = <>;
	$_ = <>;
	while(<>) {
		chomp;
		my @row = split( /,/ );
		my $base = $row[4];
		for( my $i=0; $i<12; $i++ ) {
			my $syllable = $Syllables[$i];
			my $char = $row[5+$i];
			my $addr = ord($char);
			my $xAddr = sprintf( "U+%04X", $addr );
			$xAddr =~ s/E/1X/;
			print "SHEIKH BAKRI SAPALO SYLLABLE $base$syllable;Lo;0;L;;;;;N;;;;;\n";
		}
	}

}
