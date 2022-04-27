#PBS -N qc_qingxiangguo
#PBS -l nodes=1:ppn=2
#PBS -q cu
#PBS -S /bin/bash
#!/bin/bash
echo begin at: `date`
cd /backup01/qingxiangguo/transcriptome/01QC
source /lustre/Work/qingxiangguo/dev/sofs/SMRT/smrtanalysis_v3/current/etc/setup.sh
fofnToSmrtpipeInput.py /backup01/qingxiangguo/transcriptome/input.fofn > input.xml
smrtpipe.py --params=/backup01/01data/06isoseq/Filter.xml xml:input.xml
cd data && [[ -d QC ]] || mkdir QC
/lustre/Work/software/QC/ng_QC -i /backup01/qingxiangguo/transcriptome/01QC/data/filtered_subreads.fastq -q 33 -o /backup01/qingxiangguo/transcriptome/01QC/data/QC
echo filter end at: `date`
