#!/usr/bin/perl

#reducerTB.pl by Akhil A. Saji (asajinx@gmail.com)
#Serves as testbench reducer

use 5.010;
use strict;
use warnings;

#Reduce Parameters
my $upperLimit = 1;
my $lowerLimit = 0.8;

#Test Setup using files
my $file = 'reducerInput.txt';
open(my $fileHandle, "<", $file) || die("Could not open $file");


while(!eof $fileHandle) {
	#read the line;
	my $line = readline $fileHandle;
	chomp $line;

	#Split by key/value
	my @lineArray = split(/,/, $line);
	#Split the key by the : parameter
	my @keyArray = split(/:/, $lineArray[0]);

	#Automatically filter out all values that don't exist, then apply the upper and lower limits.
	if($lineArray[1] ne "NA") {
		if(($lineArray[1] <= $upperLimit) && ($lineArray[1] >= $lowerLimit)) {
			print "$keyArray[0],$keyArray[1],$lineArray[1]\n";
		}
	}
}