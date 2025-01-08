#!/bin/sh
#$ -S /bin/bash
#$ -pe def_slot 18 ##12
#$ -l s_vmem=10G
#$ -l lmem
#$ -q '!mjobs_rerun.q'
#$ #-o /dev/null

nextclade="/home/kaho/Applications/nextclade"

####Set and forget.
# use multinomial_independent.stan for older stan version
py_script="/home/kaho/variant_report/gisaid_filter.py" 
py_script_mut="/home/kaho/variant_report/summarize_mut_info.ver2.py"

####Please edit every time. Probably just the dates.
download_date="2024-12-28"
out_prefix="2024_12_28"
working_dir="/home/kaho/variant_monitoring/output/${out_prefix}" 
sequences_fasta="/home/kaho/variant_monitoring/output/${out_prefix}/sequences_fasta_${out_prefix}.tar.xz"
gisaid_file="/home/kaho/variant_monitoring/output/${out_prefix}/metadata_tsv_${out_prefix}"

####Command
cd ${working_dir}

python3 ${py_script} \
        ${sequences_fasta} \
        "${download_date}" \
        > ${working_dir}/filtered.fasta 

echo $SECONDS > time.with_decode.txt

${nextclade} run -d sars-cov-2 -j 6 --output-tsv=nextclade.tsv filtered.fasta  ## -j 4 or 5 or 6

echo $SECONDS >> time.with_decode

###gisaid mut_long.tsv 
python3 ${py_script_mut} \
       ${gisaid_file}/metadata.tsv\
       > ${gisaid_file}/metadata.mut_long.tsv


