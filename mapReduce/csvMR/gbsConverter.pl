#!/usr/bin/perl

#gbsConverter.pl by Akhil A. Saji (asajinx@gmail.com)
#Converts GBS files into plaintext for working with in MapReduce

#Declare dependencies
use 5.010;
use strict;
use warnings;

#This module uses Tie::File and Text::CSV to make a CSV File into a 2D array
use Tie::Array::CSV;

#Declare input filename
my $inputCSV = $ARGV[0];
my $outputFile = $ARGV[1];

#Use Tie Module to create multidimensional array.
tie(my @csvFile, 'Tie::Array::CSV', $inputCSV);

#Find length of the headers column so we know the width of the array
my $rowCount = $#csvFile;
my $columnCount = $#{$csvFile[1]};

#Open output filehandle.
open my $fh, ">", $outputFile or die "$0: open $outputFile: $!";

#Default Row to Start from since 0 is headers.
#Loop
for(my $currentRow=1; $currentRow <= $rowCount; $currentRow++) {
	for(my $y=1; $y <= $columnCount; $y++) {
		my $organism = $csvFile[0][$y];
		my $SNP = $csvFile[$currentRow][0];
		my $value = $csvFile[$currentRow][$y];
		print $fh "$organism:$SNP,$value\n";
	}
	#We have to print to STDERR instead of regular print because regular print goes to the IO Buffer
	#IO Buffer will not print until the Buffer is full.
	print STDERR "Processed Row: $currentRow/$rowCount \n";
}

#close file handle
close $fh;

#Complete Message
say "";
say "Done processing ", $inputCSV, ".";