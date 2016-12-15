#!/usr/bin/perl

use List::Util qw(min max sum);
$count_loci = 0;
$count_indels = 0;

unlink "Temp.txt";
unlink "Reformat.txt";

#Open input file
open (FILE1, $ARGV[0]) || die "Where is the input file?\n";
open (REFORMAT, ">>Reformat.txt") || die "Couldn't make tempfile\n";

until (eof FILE1) {
	$line = <FILE1>;
	chomp $line;
	if ($line =~ m/\[/){
		@nums = split ('\_' , $line);
		print REFORMAT $nums[2]."\t".$nums[4]."\n";
		} else {
		print REFORMAT ">".$line,"\n";
		}
}

close FILE1;
close REFORMAT;

#Open reformatted input file
open (FILE, "Reformat.txt") || die "where is the reformatted file?\n";
open (TAMP, ">>Temp.txt") || die "Couldn't make tempfile\n";

#Sort out any loci that have no indels; print those that do to a temp file
#read in first line1
$line1 = <FILE>;
chomp $line1;
	if ($line1 =~ m/>/){
	$count_loci++;
	} else {
	}

#begin loop: read in a line2
until (eof FILE) {
	$line2 = <FILE>;
	chomp $line2;
	if ($line2 eq ()) {
		print "This file is weird. Only contains: $line1\n";
		} else {

		#if line2 is a header
		if ($line2 =~ m/>/){
			$count_loci++;

			#if line1 was a header
			if ($line1 =~ m/>/){
				#push line1 to empty
				@heads = split ('\>' , $line1);
				push (@empties, $heads[1]);
				#line1=line2
				$line1 = $line2;
				} else {
				print TAMP "$line1\n";
				#line1=line2
				$line1 = $line2;
				}
			#else print line1\n;
			} else {
			print TAMP "$line1\n";
			#line1=line2
			$line1 = $line2;
		}
	}
}

#Tie up loose ends, aka the last line
if ($line2 eq ()) {
	} else {
	if ($line2 =~ m/>/){
		$count_loci++;
		@heads = split ('\>' , $line2);
		push (@empties, $heads[1]);
		} else {
		print TAMP "$line2\n";
		}}

print "These loci have no indels:\n";
foreach (@empties) {
	print "$_\n";
	}

close TAMP;
close FILE;

#Print output header
print "Header	Total_Indels	Min_length	Max_Length	Average_Length\n";

open (TEMP, "Temp.txt");
$line = <TEMP>;
chomp $line;
@topper = split ('\>' , $line);
$header = $topper[1];

#Process line
until (eof TEMP) {
	$line = <TEMP>;
	chomp $line;

	if ($line =~ m/>/){
		#calculate basic stats
		$min = min @pigeon;
		$max = max @pigeon;
		$average = ((sum @pigeon)/$count_indels);

		#Print output
		print "$header\t$count_indels\t$min\t$max\t$average\n";
		
		#Reset indel stats
		@pigeon = ();
		
		#Reset indel count
		$count_indels=0;

		@topper = split ('\>' , $line);
		$header = $topper[1];

		} else {

		$indel = $line;
		$count_indels++;
		@numbers = split ('\t' , $indel);
		$length = $numbers[1] - $numbers[0];
		$real_length = $length + 1;
		push (@pigeon, $real_length);
		}
	}

#Final stat calculation and output
$min = min @pigeon;
$max = max @pigeon;
$average = ((sum @pigeon)/$count_indels);
print "$header\t$count_indels\t$min\t$max\t$average\n";
print "File has $count_loci loci total\n";
unlink "Temp.txt";
unlink "Reformat.txt";

end;
