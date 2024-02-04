#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;
use open ':encoding(utf-8)';

main:
{
	for my $upper ( 'A'..'Z' ) {
		my $lower = lc($upper);
		print "\@$upper = [$upper $lower];\n";
	}
	print "\@CH = [\@C \@H];\n";
	print "\@DH = [\@D \@H];\n";
	print "\@PH = [\@P \@H];\n";
	print "\@SH = [\@S \@H];\n";
	print "\@TS = [\@T \@S];\n";
	print "\@NY = [\@N \@Y];\n";
	print "\@ZY = [\@Z \@Y];\n";

}
