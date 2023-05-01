{
	# set output separator to Tab
	{OFS="\t"}
	# check forth column (DB column) if contains 'Pfam'
	if ($4 ~/Pfam/)
	{
		# print Tab-separated selection of columns:
		# 1: NCBI accession, 4: DB (Pfam), 5: Pfam entry ID,
		# 6: Domain name, 7: Start pos, 8: End pos,
		# 9: e-value, 12: Interpro entry ID,
		# 13: Domain description, 14: GO terms
		print $1, $4, $5, $6, $7, $8, $9, $12, $13, $14
	}
}
