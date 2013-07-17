#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

while(my $line = <>) {
	my @words = split(' ', $line);

	foreach my $word(@words) {
		print "$word \t 1 \n";
	}
}