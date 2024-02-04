#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;
use open ':encoding(utf-8)';


	my @Syllables = (
		"\@A",
		"\@U",
		"\@I",
		"\@E",
		"\@O",
		"\@A \@A",
		"\@U \@U",
		"\@I \@I",
		"\@E \@E",
		"\@O \@O",
		""
	);

sub printClasses
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
	print "\@SingleQuote = [quotesingle uni2019];\n";
	print "\n";

}

sub printSyllable
{
my($base,$qubee, $syllable, $char) = @_;

	my $addr = ord($char);
	my $sequence = "";

	for my $q (split(//, $qubee)) {
		$sequence .= "\@".uc($q)." ";
	}
	$sequence .= $syllable;
	my $Qubee = $sequence;
	$Qubee  =~ s/[@ ]//g;
	my $calt = sprintf( "\tsub $sequence by uni%4X; # $char → $Qubee\n", $addr );
	$calt =~ s/  / /;
	print $calt;

}

sub printRow
{
my @row = @{ $_[0] };

	my $base = $row[5];
	my $qubee = $row[1];
	return unless( $qubee );

	# Long Vowels
	for( my $i=5; $i<10; $i++ ) {
		printSyllable( $base, $qubee, $Syllables[$i], $row[6+$i] );
	}
	# Short Vowels
	for( my $i=0; $i<5; $i++ ) {
		printSyllable( $base, $qubee, $Syllables[$i], $row[6+$i] );
	}
	# Consonant
	printSyllable( $base, $qubee, "", $row[16] );

}

sub printRegularRow
{
	printRow( @_ );
}

sub printGeminatedRow
{
	printRow( @_ );
}

main:
{
	printClasses();


print<<BEGIN;
feature calt {
# Contextual Alternates

#> feature
BEGIN
	$_ = <>;
	$_ = <>;
	$_ = <>;
	$_ = <>; # Vowels
	for( my $i=0; $i<10; $i++ ) {
		my @row = split( /,/ );
		my $syllable = $Syllables[$i];
		my $char = $row[6+$i];
		my $addr = ord($char);
		my $sequence = "\@SingleQuote $syllable";
		my $Qubee = $sequence;
		$Qubee  =~ s/[@ ]//g;
		my $calt = sprintf( "\tsub $sequence by uni%4X; # $char → $Qubee\n", $addr );
		print $calt;
	}
	$_ = <>; # Skip Geminated Vowels

	# Print order for calt's follows longest-token-first::
	# (1) Geminated Consonant Long Vowels
	# (2) Geminated Consonant Short Vowels
	# (3) Geminated Consonant
	# (4) Regular Consonant Long Vowels
	# (5) Regular Consonant Short Vowels
	# (6) Regular Consonant 
	while(<>) {
		chomp;
		my @RegularRow = split( /,/ );
		$_ = <>;
		chomp;
		my @GeminatedRow = split( /,/ );
		printGeminatedRow( \@GeminatedRow );
		printRegularRow( \@RegularRow );
	}
print<<END;
#< feature
} calt;
END
}
