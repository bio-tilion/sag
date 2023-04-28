rule all:
	input:
		"results/clustalo_COG5002_members_1762.log",
		"results/clustalo_uniprot_COG5002_1762.log"

rule eggnog_get_fasta:
	input:
		"scripts/get_fasta.awk",
		"data/{eggnog_member_list}.tsv"
	output:
		"data/{eggnog_member_list}.faa"
	shell:
		"awk -F '\\t' -f {input} > {output}"

rule uniprot_get_fasta:
	input:
		"scripts/uniprot_eggnog.py"
	output:
		"data/uniprot_{fasta_seqs}.faa"
	shell:
		"python {input}"

rule msa_clustalo_ebi:
	input:
		"data/{fasta_seqs}.faa"
	output:
		"results/clustalo_{fasta_seqs}.log"
	shell:
		"python scripts/clustalo.py --email alberto.locca1@gmail.com --stype protein --sequence {input} --outfile results/clustalo_{wildcards.fasta_seqs} --quiet > {output}"
