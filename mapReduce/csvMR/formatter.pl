#!/usr/bin/perl

#formatter.pl by Akhil A. Saji (asaji@bu.edu)
#Converts GBS files into plaintext for working with in MapReduce

#Declare dependencies
use 5.010;
use warnings;
use Text::CSV;

my $fileName = 'gbsTestData.csv';

#binary is set to ensure that we can handle new lines
my $csv = Text::CSV->new({
	binary => 1,
	sep_char => ",",
	}) or die "CSV Error:".Text::CSV->error_diag();

#the $! allows us to reference the error number of whatever cause the line to crash.
open(FILEHANDLE, "<", $fileName) or die $!;

my @data;
while(my $line = <FILEHANDLE>) {
	if($csv->parse($line)) {
		#If parse() is sucessful, we can call fields()
		push @data, $csv;
	} else {
		my $error = $csv->error_input();
		print "Failed";
	}
}

close FILEHANDLE;

print @data[0];