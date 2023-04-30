rule all:
	input:
		"results/clustalo/COG5002_members_1762.jobid",
		"results/clustalo/uniprot_COG5002_1762.jobid",
		"results/interproscan/phoR_pfam.json",
		"results/interproscan/phoR_pfam.tsv",

rule eggnog_get_fasta:
	input:
		awk="scripts/get_fasta.awk",
		tab="data/{eggnog_member_list}.tsv"
	output:
		"data/{eggnog_member_list}.fasta"
	shell:
		"awk -F '\\t' -f {input.awk} {input.tab} > {output}"

rule uniprot_get_fasta:
	input:
		"scripts/uniprot_eggnog.py"
	output:
		"data/uniprot_{fasta_seqs}.fasta"
	shell:
		"python {input}"

rule msa_clustalo_ebi:
	input:
		"data/{fasta_seqs}.fasta"
	output:
		"results/clustalo/{fasta_seqs}.jobid"
	params:
		email="alberto.locca1@gmail.com",
		type="protein"
	shell:
		"python scripts/clustalo.py --email {params.email} --stype {params.type} --sequence {input} --outfile results/clustalo/{wildcards.fasta_seqs} --quiet > {output}"

rule interproscan_search:
	input:
		"data/{prot}.faa"
	output:
		job="results/interproscan/{prot}.jobid",
		_=touch(multiext("results/interproscan/{prot}", ".json.json", ".tsv.tsv")),
	params:
		email="alberto.locca1@gamil.com",
		type="p"
	shell:
		"python scripts/iprscan5.py --email {params.email} --stype {params.type} --sequence {input} --outfile results/interproscan/{wildcards.prot} --quiet > {output.job}"

rule pfam_json:
	input:
		"results/interproscan/{prot}.json.json"
	output:
		"results/interproscan/{prot}_pfam.json"
	shell:
		"python scripts/pfam_filter_json.py {input} > {output}"

rule pfam_tsv:
	input:
		awk="scripts/pfam_filter_tsv.awk",
                ips_tab="results/interproscan/{prot}.tsv.tsv"
	output:
		"results/interproscan/{prot}_pfam.tsv"
	shell:
		"awk -F '\\t' -f {input.awk} {input.ips_tab} > {output}"
