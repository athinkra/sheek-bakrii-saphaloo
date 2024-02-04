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
my @Orders =(
	"Base",
	"ShortA",
	"ShortU",
	"ShortI",
	"ShortE",
	"ShortO",
	"LongA",
	"LongU",
	"LongI",
	"LongE",
	"LongO",
	"Consonant"
);
my %OrdersToKeys =(
	"Base" => "*",
	"ShortA" => "Aa",
	"ShortU" => "Uu",
	"ShortI" => "Ii",
	"ShortE" => "Ee",
	"ShortO" => "Oo",
	"LongA" => "Aa",
	"LongU" => "Uu",
	"LongI" => "Ii",
	"LongE" => "Ee",
	"LongO" => "Oo",
	"Consonant" => ""
);

my %MonographToDigraph =(
	# Mappings to Digraphs
	# c => ch
	'' => '',
	# d => dh
	'' => '',
	# n => ny
	'' => '',
	# p => ph
	'' => '',
	# s => sh
	'' => '',
	# t => ts
	'' => '',
	# z => zy
	'' => '',

	# Letters with no direct Qubee correspondence
	# h => h2
	'' => '',
	# s => s2
	'' => '',
	# k => k2
	'' => '',
	# a => ʕ
	'' => ''
);

sub printClasses
{
	for my $key (@Orders) {
		print "store($key) '$OrdersToKeys{$key}'\n";
	}

	print "store(H_Modifier) 'Hh'\n";
	print "store(H_DigraphBases) ''\n";
	print "store(H_DigraphTargets) ''\n";

	print "store(Y_Modifier) 'Yy'\n";
	print "store(Y_DigraphBases) ''\n";
	print "store(Y_DigraphTargets) ''\n";

	print "store(S_Modifier) 'Ss'\n";

	print "store(2_DigraphBases) ''\n";
	print "store(2_DigraphTargets) ''\n";

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
	for( my $i=0; $i<4; $i++ ) {
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

sub printQubeeKeys
{
my @SBS = @{ $_[0] };


	my %Digraphs = ();
	foreach my $key (keys %MonographToDigraph) {
		my $value = $MonographToDigraph{$key};
		$Digraphs{$value} = $key;
	}

	print "store(QubeeKeys) \'";
	for (my $i=0; $i<$#SBS;) {
		my $row = $SBS[$i];
		$i += 2;
		my $key = $row->[1];		
		next if( length($key) > 1 );
		print $key;
	}
	print "'\n";
	print "store(OrdersConsonantsRegular) \'";
	for (my $i=0; $i<$#SBS;) {
		my $row = $SBS[$i];
		$i += 2;
		my $consonant = $row->[16];
		next if( $Digraphs{$consonant} );
		print $consonant;
	}
	print "'\n";
	print "store(OrdersConsonantsGeminated) \'";
	for (my $i=1; $i<$#SBS;) {
		my $row = $SBS[$i];
		my $regularConsonant = $SBS[$i-1]->[16];
		my $consonant = $row->[16];
		$i += 2;
		next if( $Digraphs{$regularConsonant} );
		print $consonant;
	}
	print "'\n";
}


sub printOrderArray
{
my $i = shift;
my @SBS = @{ $_[0] };

	print "store(Order$Orders[$i]) \'";
	for my $row (@SBS) {
		print $row->[$i+5];
	}
	print "'\n";
		
}

main:
{

	printClasses();

	$_ = <>;
	$_ = <>;
	$_ = <>;

	my @SBS = ();
	while(<>) {
		my @row = split( /,/ );
		push( @SBS, \@row );
			
	}
	printQubeeKeys(\@SBS);
	for ( my $i=0; $i<=$#Orders; $i++ ) {
		printOrderArray($i, \@SBS);
	}

	print "\n";
	print "begin Unicode > use(main)\n";
	print "group(main) using keys\n\n";

	print "+ any(QubeeKeys)                   > index(OrdersConsonantsRegular,1);\n";
	print "any(OrdersConsonantsRegular + any(QubeeKeys) > index(OrdersConsonantsGeminated,1);\n";
	print "any(OrdersConsonant) + '*'         > index(OrdersBase,1);\n";
	print "any(OrdersConsonant) + any(ShortA) > index(OrdersShortA,1);\n";
	print "any(OrdersConsonant) + any(ShortU) > index(OrdersShortU,1);\n";
	print "any(OrdersConsonant) + any(ShortI) > index(OrdersShortI,1);\n";
	print "any(OrdersConsonant) + any(ShortE) > index(OrdersShortE,1);\n";
	print "any(OrdersConsonant) + any(ShortO) > index(OrdersShortO,1);\n";
	print "any(OrdersShortA)    + any(LongA)  > index(OrdersLongA,1);\n";
	print "any(OrdersShortU)    + any(LongU)  > index(OrdersLongU,1);\n";
	print "any(OrdersShortI)    + any(LongI)  > index(OrdersLongI,1);\n";
	print "any(OrdersShortE)    + any(LongE)  > index(OrdersLongE,1);\n";
	print "any(OrdersShortO)    + any(LongO)  > index(OrdersLongO,1);\n";

	print "any(H_DigraphBases) + any(H_Modifier)  > any(H_DigraphTargets)\n";
	print "'' + any(S_Modifier)  > ''\n";
	print "any(Y_DigraphBases) + any(Y_Modifier)  > any(Y_DigraphTargets)\n";

	if( 0 ) {
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
}
}
