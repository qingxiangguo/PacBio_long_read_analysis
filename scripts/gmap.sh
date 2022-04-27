#PBS -N gmap_guoqing
#PBS -l nodes=1:ppn=2
#PBS -q cu
#PBS -S /bin/bash
#!/bin/bash
echo begin at: `date`
cd /backup01/qingxiangguo/transcriptome/03gmap
/lustre/Work/software/gmap_gsnp/gmap-2014-07-04/bin/gmap_build -d qingxiangguo /backup01/01data/06isoseq/genome.fa
/lustre/Work/software/gmap_gsnp/gmap-2014-07-04/bin/gmap -d qingxiangguo -n 10 -A /backup01/01data/06isoseq/query.fa > /backup01/guoqing/transcriptome/03gmap/gmap.out 2 > /backup01/guoqing/transcriptome/03gmap/unmap.out
echo gmap end at: `date`
