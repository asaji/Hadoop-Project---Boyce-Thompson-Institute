#!/usr/bin/perl

#gbsConverter.pl by Akhil A. Saji (asaji@bu.edu)
#Converts GBS files into plaintext for working with in MapReduce

#Declare dependencies
use 5.010;
use strict;
use warnings;

#This module uses Tie::File and Text::CSV to make a CSV File into a 2D array
use Tie::Array::CSV;

#Declare input filename
my $inputCSV = 'gbsTestData.csv';

#Use Tie Module
tie(my @csvFile, 'Tie::Array::CSV', $inputCSV);

#Find length of the headers column so we know the width of the array
my $rowCount = $#csvFile+1;
my $columnCount = $#{$csvFile[1]}+1;

#Open output filehandle.
open(my $fh, '>', 'gbsMRoutput.txt');

#Default Row to Start from since 0 is headers.
my $currentRow = 1;

#Loop
for(my $x=0; $x <= $columnCount; $x++) {
	print $fh $csvFile[0][$x],":",$csvFile[$currentRow][0],",",$csvFile[$currentRow][$x],"\n";
}