**PacBio long read analysis**

**Contributors**

Qingxiang Guo

**Notes**

Written by Qingxiang Guo, qingxiang.guo@outlook.com, distributed without any guarantees or restrictions.

**Codes**

**1. Use SMART to filter the PacBio raw data, and obtain the subreads**

\# The content of Input.fofn is as follows:

/Work/data/Analysis\_Results/m150730\_090551\_42199\_c100821272550000001823174411031557\_s1\_p0.1.bax.h5

/Work/data/Analysis\_Results/m150730\_090551\_42199\_c100821272550000001823174411031557\_s1\_p0.2.bax.h5

/Work/data/Analysis\_Results/m150730\_090551\_42199\_c100821272550000001823174411031557\_s1\_p0.3.bax.h5

\# The content of Filter.xml is as follows:

<?xml version="1.0" ?>

<smrtpipeSettings>

`  `<module name="P\_Fetch"/>

`  `<module name="P\_Filter">

`       `<param name="minSubReadLength" label="Minimum Subread Length">

`       `<value>100</value>

`       `</param>

`      `<param name="readScore" label="Minimum Polymerase Read Quality">

`      `<value>0.75</value>

`      `</param>

`      `<param name="minLength" label="Minimum Polymerase Read Length">

`      `<value>200</value>

`      `</param>

`  `</module>

<module id="P\_FilterReports" editableInJob="false"/>

</smrtpipeSettings>

~

\# Start analysis, do Filter.sh

\# To find isoseq, run flnc.sh

\# The content of the configuration file rs\_isoseq.xml is as follows:

<?xml version="1.0" encoding="utf-8"?>

<smrtpipeSettings>

` `<protocol>

`  `<param name="reference"><value>/backup01/qingxiangguo/transcriptome/02isoseq/ref/test</value></param>

` `</protocol>

` `<module id="P\_Fetch" />

` `<module label="Reads Of Insert" id="P\_CCS" editableInJob="true" >

`    `<description>Generates consensus sequences from single molecules.</description>

`    `<!-- This \*must\* be false in Mapping to disable to the standard P\_Mapping align task

`    `<param name="align" hidden="true"><value>False</value></param>

`    `<param name="alignCCS" hidden="true"><value>True</value></param>

`    `-->

`    `<param name='minFullPasses' label="Minimum Full Passes">

`      `<title>Minimum number of full-length passes over the insert DNA for the read to be emitted</title>

`      `<value>2</value>

`      `<input type="text"/>

`      `<rule type="digits" min="0" max="10" message="Value must be an integer between 0 and 10" />

`    `</param>

`    `<param name='minPredictedAccuracy' label="Minimum Predicted Accuracy">

`      `<title>Minimum predicted accuracy of the reads of insert emitted (in percent)</title>

`      `<value>90</value>

`      `<input type="text"/>

`      `<rule type="digits" min="70" max="100" message="Value must be between 70 and 100" />

`    `</param>

`  `</module>

` `<module name="P\_IsoSeqClassify">

`  `<param name="minSeqLen"><value>200 </value></param>

`  `<param name="ignorePolyA" hidden="False"><value>False</value></param>

`  `<param name="gmap\_n"><value>100</value></param>

`  `<param name="flnctocmph5"><value>False</value></param>

` `</module>

` `<module name="P\_IsoSeqCluster">

`  `<param name="cluster" hidden="False"><value>True</value></param>

"rs\_isoseq.xml"

**2. Map the long-read iso-seq to the reference genome using Gmap**

\# Run gmap.sh

**3. PacBio genome assembly**

**3.1 Use HGAP to assembly the genome**

\# Filter the PacBio raw data, and obtain the subreads

\# Run Filter.pl

perl filter.pl -i /backup01/qingxiangguo/HGAP/MCB/input.fofn -d /backup01/AS\_HGAP\_MCB/Filter

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

=head1 Usage

perl filter.pl -i <your\_input.fofn> -d <work\_dir>

=head1 Case

perl filter.pl -i /backup01/qingxiangguo/HGAP/MCB/input.fofn -d /backup01/AS\_HGAP\_MCB/Filter

=cut

\# The content of input.fofn is as follows:

/lustre/Work/data/HBE/E06\_1/Analysis\_Results/m150514\_130050\_42199\_c100795172550000001823166309091574\_s1\_p0.1.bax.h5

/lustre/Work/data/HBE/E06\_1/Analysis\_Results/m150514\_130050\_42199\_c100795172550000001823166309091574\_s1\_p0.2.bax.h5

/lustre/Work/data/HBE/E06\_1/Analysis\_Results/m150514\_130050\_42199\_c100795172550000001823166309091574\_s1\_p0.3.bax.h5

/lustre/Work/data/HBE/F06\_1/Analysis\_Results/m150514\_172003\_42199\_c100795172550000001823166309091575\_s1\_p0.1.bax.h5

/lustre/Work/data/HBE/F06\_1/Analysis\_Results/m150514\_172003\_42199\_c100795172550000001823166309091575\_s1\_p0.2.bax.h5

/lustre/Work/data/HBE/F06\_1/Analysis\_Results/m150514\_172003\_42199\_c100795172550000001823166309091575\_s1\_p0.3.bax.h5

\# Run Filter.pbs

\# The content of filter.xml is as follows:

<?xml version="1.0" ?>

<smrtpipeSettings>

`  `<module name="P\_Fetch"/>

`  `<module name="P\_Filter">

`       `<param name="minSubReadLength" label="Minimum Subread Length">

`       `<value>500</value>

`       `</param>

`      `<param name="readScore" label="Minimum Polymerase Read Quality">

`      `<value>0.75</value>

`      `</param>

`      `<param name="minLength" label="Minimum Polymerase Read Length">

`      `<value>100</value>

`      `</param>

`  `</module>

<module id="P\_FilterReports" editableInJob="false"/>

</smrtpipeSettings>

\# We have already obtained the subreads, next we calculated the distribution of seed length to screen the candidate seeds

perl /lustre/Work/qingxiangguo/dev/script/PacBio/scripts/len\_cal.pl filtered\_subreads.fasta

\# Then do seed length calculation

perl /lustre/Work/qingxiangguo/dev/script/PacBio/scripts/seed\_length.pl -g 5000000 filtered\_subreads.fasta\_len

\# Run the HGAP assembly for each seeds

perl /lustre/Work/qingxiangguo/dev/script/PacBio/HGAP/params\_seed.pl /backup01/guoqing/genome/01QC/HGAP\_10.lst

\# The content of configuration file HGAP.list is as follows:

genomesize      5000000

minCorCov       10

input.fofn      /backup01/01data/01QC/input.fofn

seed\_length     16000   17000

work\_path       /backup01/02HGAP/min10

ppn     3

PBS\_q   cu

\# The result is in data directory

**3.2 Use MHAP to assembly the genome**

\# Need two files, mhap.pbs and configuration file mhap\_pacbio.spec

\# The content of mhap.pbs is as follows:

#PBS -N MHAP\_test

#PBS -l nodes=1:ppn=3

#PBS -q cu

#PBS -S /bin/bash

cd /backup01/03MHAP/ECOLI\_relax

PBcR -l K12 -s mhap\_pacbio.spec -pbCNS -fastq /backup01/01data/02MHAP/ecoli\_filtered.fastq genomeSize=4650000

\# The content of mhap\_pacbio.spec is as follows:

merSize=16

mhap=-k 16 --num-hashes 512 --num-min-matches 3 --threshold 0.04 --weighted

useGrid=0

scriptOnGrid=0

ovlMemory=32

ovlStoreMemory=32000

threads=32

ovlConcurrency=1

cnsConcurrency=8

merylThreads=32

merylMemory=32000

ovlRefBlockSize=20000

frgCorrThreads = 16

frgCorrBatchSize = 100000

ovlCorrBatchSize = 100000

asmOvlErrorRate=0.10

asmUtgErrorRate=0.07

asmCgwErrorRate=0.10

asmCnsErrorRate=0.10

utgGraphErrorRate=0.07

utgGraphErrorLimit=3.25

utgMergeErrorRate=0.0825

utgMergeErrorLimit=5.25

asmOBT=0

qsub mhap.pbs

**3.3 Use Ectools to assembly the genome using both Illumina and PacBio reads**

\# Filter reads shorter than 1k

perl /lustre/Work/qingxiangguo/dev/script/seq/len\_flt.pl -d 1000 filtered\_subreads.fasta

\# Then you will get long reads, filtered\_subreads.fasta\_len\_flt.fasta

\# Split the fasta file

python /lustre/Work/qingxiangguo/dev/sofs/SMRT/ectools-master/partition.py 500 500 filtered\_subreads.fasta\_len\_flt.fasta

\# Feed the Illumina reads

perl  /lustre/Work/qingxiangguo/dev/sofs/SMRT/ectools-master/correct.pl -MIN\_READ\_LEN 1000 -UNITIG\_file /backup01/01data/03ECtools/ecoli\_illumina.fa -WORK\_DIR /backup01/guoqing/genome/06ECTOOLS/

\# Then run .sh file in correction.SH directory

\# Combine all the corrected sequence

Cat ????/\*.cor.fa > cor.fa

\# Use Celera to assembly

perl /lustre/Work/qingxiangguo/dev/sofs/SMRT/wgs-8.3rc2/Linux-amd64/bin/convert-fasta-to-v2.pl -l organism\_pbcor -s organism.cor.fa -q <(python /lustre/Work/qingxiangguo/dev/sofs/SMRT/ectools-master/qualgen.py cor.fa)> cor.frg

convert-fasta-to-v2.pl

runCA –d $work\_dir –p ec\_cor cor.frg

**4. Use PacBio long reads to do gap filling for Illumina sequences**

\# Run .sh

#PBS -N pbjelly\_test

#PBS -l nodes=1:ppn=3

#PBS -q cu

#PBS -S /bin/bash

source /lustre/Work/qingxiangguo/dev/sofs/SMRT/smrtanalysis\_v3/current/etc/setup.sh

cd /backup01/06PBJelly/ref

/lustre/Work/software/Assembly/PBSuite\_15.2.20/bin/fakeQuals.py lambda.fasta lambda.qual

cd /backup01/06PBJelly

Jelly.py setup Protocol.xml

Jelly.py mapping Protocol.xml

Jelly.py support Protocol.xml

Jelly.py extraction Protocol.xml

Jelly.py assembly Protocol.xml

Jelly.py output Protocol.xml

\# The content of configuration file Protocal.xml is as follows:

<jellyProtocol>

`    `<reference>/backup01/aipeng/genome/06PBJelly/ref/lambda.fasta</reference>

`    `<outputDir>/backup01/aipeng/genome/06PBJelly/</outputDir>

`    `<blasr>-minMatch 8 -minPctIdentity 70 -bestn 1 -nCandidates 20 -maxScore -500 -nproc 4 -noSplitSubreads</blasr>

`    `<input baseDir="/backup01/01data/05PBJelly/">

`        `<job>filtered\_subreads.fastq</job>

`    `</input>

</jellyProtocol>

**License**

All source code, i.e. scripts/\*.pl, scripts/\*.sh or scripts/\*.py are under the MIT license.
