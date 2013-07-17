#!/bin/usr/perl

use 5.010;
use warnings;

my $currentWord = "";
my $currentCount = 0;

##Use this block for testing the reduce script with some test data.
#Open the test file
#open(my $fh, "<", "testdata.txt");
#while(!eof $fh) {}

while($line = <>) {
	#Remove the \n
	chomp $line;

	#Index 0 is the word, index 1 is the count value
	my @lineData = split('\t', $line);
	my $word = $lineData[0];
	my $count = $lineData[1];

	if($currentWord eq $word) {
		$currentCount = $currentCount + $count;
	} else {
		if($currentWord ne "") {
			#Output the key we're finished working with
			print "$currentWord \t $currentCount \n";
		}
		#Switch the current variables over to the next key
		$currentCount = $count;
		$currentWord = $word;
	}
}

#deal with the last loop 
print "$currentWord \t $currentCount \n";