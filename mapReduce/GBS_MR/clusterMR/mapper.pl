#!/usr/bin/perl

#mapper.pl by Akhil A. Saji (asajinx@gmail.com)
#Serves as the mapping layer for the MapReduce GBS Application
#User Instructions:
#Provide organism and SNP selections in the organismSelector and snpSelector arrays

use 5.010;
use strict;
use warnings;

#Query Parameters
#Sample Inputs:
	##Select All SNPs specific to given organisms
	#organismSelector = '2013_0002_4','2013_0002_7','2013_0003_14'
	#snpSelector = '*'

	##Select All Organisms specific to given SNP
	#organismSelector = '*'
	#snpSelector = 'S6606_19846','S7129_100757'

	##Select Specific SNP/Organism Pair
	#organismSelector = '2013_10145_32'
	#snpSelector = 'S7129_100757'
my @organismSelector = ('2013_10145_32');
my @snpSelector = ('*');


####Do Not Edit Below This Line####
#Convert Query Arrays into Hashes for various utilities
my %organismSelectorHash = map { $_ => 1 } @organismSelector;
my %snpSelectorHash = map { $_ => 1 } @snpSelector;

while(my $line = <>) {
	chomp $line;

	#Split by key/value
	my @lineArray = split(/,/, $line);
	#Split the key by the : parameter
	my @keyArray = split(/:/, $lineArray[0]);

	if($organismSelector[0] eq "*") {
		if(exists($snpSelectorHash{$keyArray[1]})) {
			print "$keyArray[0]:$keyArray[1],$lineArray[1]\n";
		}
	} elsif($snpSelector[0] eq "*") {
		if(exists($organismSelectorHash{$keyArray[0]})) {
			print "$keyArray[0]:$keyArray[1],$lineArray[1]\n";
		}
	} else {
		if((exists($organismSelectorHash{$keyArray[0]})) && exists($snpSelectorHash{$keyArray[1]})) {
			print "$keyArray[0]:$keyArray[1],$lineArray[1]\n";
		}
	}
}