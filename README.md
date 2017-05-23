# Indel-stats
Please cite use of this software.

[![DOI](https://zenodo.org/badge/76591162.svg)](https://zenodo.org/badge/latestdoi/76591162)


Starting with 2matrix's \*.garli.nex output file, this script will give indel #, and min/max/mean length per sequence. Get 2matrix.pl from (https://github.com/nrsalinas/2matrix).

Steps:  
1) Run 2matrix.pl with flag "-o nexus"  
2) Get a file of a header and indel coordinates from a directory full of \*.garli.nex output files:  
    
		for x in \`ls\`; do echo $x; grep "indel\_" $x; done >Outfile.txt  

Format will look like:

	sequence1.garli.nex  
				[1] sequence_indel_6_to_7  
				[2] sequence_indel_44_to_44  
    sequence2.garli.nex  
				[1] sequence_indel_1_to_2  
				[2] sequence_indel_5_to_7  
				[3] sequence_indel_11_to_11      
				

3) Run perl indel_stats.pl Outfile.txt

4) Cite this script using the DOI above
