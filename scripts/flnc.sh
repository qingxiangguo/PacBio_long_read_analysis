#PBS -N guoqing
#PBS -l nodes=1:ppn=2
#PBS -q cu
#PBS -S /bin/bash
#!/bin/bash
echo begin at: `date`
source /lustre/Work/qingxiangguo/dev/sofs/SMRT/smrtanalysis_v3/current/etc/setup.sh
fofnToSmrtpipeInput.py /backup01/guoqing/transcriptome/01qc/input.fofn > input.xml
referenceUploader -c -p /backup01/qingxiangguo/transcriptome/02isoseq/ref -n test -f /backup01/01data/06isoseq/genome.fa
smrtpipe.py --params=/backup01/guoqing/transcriptome/isoseq/rs_isoseq.xml xml:input.xml
cd data && [[ -d flncQC ]] || mkdir flncQC
perl /backup01/01data/06isoseq/fasta2q.pl /backup01/guoqing/transcriptome/isoseq/data/isoseq_flnc.fasta /backup01/guoqing/transcriptome/isoseq/data/reads_of_insert.fastq > /backup01/guoqing/transcriptome/isoseq/data/isoseq_flnc.fastq
/lustre/Work/software/QC/ng_QC -i /backup01/guoqing/transcriptome/isoseq/data/isoseq_flnc.fastq -q 33 -o /backup01/guoqing/transcriptome/01qc/data/flncQC  
echo isoseq end at: `date`
