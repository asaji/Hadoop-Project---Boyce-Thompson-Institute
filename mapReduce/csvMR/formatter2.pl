#!/usr/bin/perl

#formatter.pl by Akhil A. Saji (asaji@bu.edu)
#Converts GBS files into plaintext for working with in MapReduce

#Declare dependencies
use 5.010;
use strict;
use warnings;

#This module uses Tie::File and Text::CSV to make a CSV File into a 2D array
use Tie::Array::CSV;

tie(my @csvFile, 'Tie::Array::CSV', 'gbsTestData.csv');

#Find length of the headers column so we know the width of the array

print $#csvFile[0];