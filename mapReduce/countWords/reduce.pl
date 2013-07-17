#!/bin/usr/perl

use 5.010;
use warnings;
use strict;

my $currentWord = null;
my $currentCount = 0;

my $line = "apple	1";

#Remove the \n
chomp $line;

#Index 0 is the word, index 1 is the count value
my @lineData = split('\t', $line);
my $word = $lineData[0];
my $count = $lineData[1];

if($currentWord eq $word) {
	$currentCount = $currentCount + $count;
} else {
	if($currentWord) {
		#Output the key we're finished working with
		print "$currentWord \t $currentCount";

		#Switch the current variables over to the next key
		$currentCount = $count;
		$currentWord = $word;
	}
}