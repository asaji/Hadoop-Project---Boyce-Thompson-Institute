#!/usr/bin/perl

#reducer.pl by Akhil A. Saji (asajinx@gmail.com)
#Serves as the reducing layer for the MapReduce GBS Application
#User Instructions:
#Provide upper and lower limits for value reducing.

use 5.010;
use strict;
use warnings;

#Reduce Parameters
my $upperLimit = 1;
my $lowerLimit = 0.8;

####Do Not Edit Below This Line####
while(my $line = <>) {
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