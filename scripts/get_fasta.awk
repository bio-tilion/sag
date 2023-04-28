{
	# skip first line with column names
	if (NR > 1)
	{
		# replace space with underscore in Species field
		gsub(" ", "_", $1) ;
		# header fasta format Member|Taxid|Species
		print ">" $3 "|taxid:" $2 "|" $1 ;
		# get sequence with eggNOG api in fasta format (all lines but header)
		system("curl -s http://eggnogapi6.embl.de/get_sequence/"$3 "| sed 1d") ;
		# new line after each entry
		printf "\n"
	}
}
