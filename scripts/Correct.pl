use Getopt::Long;
GetOptions(
'MIN_ALIGNMENT_LEN=s'   =>\$MIN_ALIGNMENT_LEN,
'WIGGLE_PCT=s'          =>\$WIGGLE_PCT,
'CONTAINED_PCT_ID=s'    =>\$CONTAINED_PCT_ID,
'CLR_PCT_ID=s'          =>\$CLR_PCT_ID,
'MIN_READ_LEN=s'        =>\$MIN_READ_LEN,
'NUCMER_BREAK_LEN=s'    =>\$NUCMER_BREAK_LEN,
'PRE_DELTA_FILTER=s'    =>\$PRE_DELTA_FILTER,
'UNITIG_file=s'         =>\$UNITIG_file,
'WORK_DIR=s'            =>\$WORK_DIR,
);

$MIN_ALIGNMENT_LEN ||=200;
$WIGGLE_PCT ||=0.05;
$CONTAINED_PCT_ID ||=0.80;
$CLR_PCT_ID ||=0.96;
$MIN_READ_LEN ||=500;
$NUCMER_BREAK_LEN ||=10000;
$PRE_DELTA_FILTER ||="false";

opendir ORI,"$WORK_DIR";

$CORRECT_SCRIPT="/lustre/Work/qingxiangguo/dev/sofs/SMRT/ectools-master/pb_correct.py";
$PRE_DELTA_FILTER_SCRIPT="/lustre/Work/qingxiangguo/dev/sofs/SMRT/ectools-master/pre_delta_filter.py";

system("mkdir -p $WORK_DIR/correction_SH");
open o,">$WORK_DIR/correction_SH/all.sh";

while($file=readdir(ORI)){
if($file=~/^\d+/ && $file!~/[a-zA-Z_]/){
open $out,">$WORK_DIR/correction_SH/$file\.sh";
print o "qsub $WORK_DIR/correction_SH/$file\.sh\n";
print $out "#PBS -N $file\n";
print $out "#PBS -l nodes=1:ppn=1\n";
print $out "#PBS -q batch\n";
