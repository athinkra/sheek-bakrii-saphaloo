#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;
use open ':encoding(utf-8)';

main:
{
	while( <> ) {
		tr/\x{E000}-\x{E323}/\x{1C800}-\x{1CB17}\x{1CB20}-\x{1CB2B}/;
		print;
	}
}
