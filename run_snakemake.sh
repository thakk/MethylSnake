#!/bin/bash

#if [ ! -d logs ]; then
 # mkdir -p logs/{trim_galore,bismark,bismark_methylation_extractor,bismark2report,bismark2summary,bam2nuc,filter_non_conversion}
#fi

#singularity exec -B /lustre/bmt-data/genomics/projects/glioma_cellline_rrbs ~/containers/snakemake_latest.sif snakemake \
LOG_FOLDER=$(grep log_folder "$1" | awk -F":" '{print $2}')
SBATCH="sbatch -J {cluster.jobname} --partition={cluster.partition} --mem={cluster.mem} --time={cluster.time} --cpus-per-task={threads} -e ${LOG_FOLDER%/}/{cluster.log} -o ${LOG_FOLDER%/}{cluster.log}"

snakemake \
    -r -j 100 --configfile ./config.yaml \
    --use-conda \
    --cluster-config ./cluster-config/cluster.json \
    --cluster "$SBATCH" \
    --latency-wait 120 \
    --rerun-incomplete
#    --profile slurm