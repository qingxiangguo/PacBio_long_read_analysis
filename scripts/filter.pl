use Getopt::Long;     
my ($fofn,$dir);
GetOptions(
  "help|h|?"  =>\$help,
  "i=s"       =>\$fofn,
  "d=s"       =>\$dir
  );
die `pod2text $0` if ($help);
if(! -e $dir){
system("mkdir -p $dir");
}
open o,">$dir/filter.pbs";
select o;
print "#PBS -N filter\n";
print "#PBS -l nodes=1:ppn=3\n";
print "#PBS -q cu \n";
print "#PBS -S /bin/bash\n";
print "cd $dir\n";
print "cp /lustre/Work/qingxiangguo/dev/script/PacBio/Filter/filter.xml $dir/filter.xml\n";
print "cp $fofn $dir/input.fofn\n";
print "source /lustre/Work/qingxiangguo/dev/sofs/SMRT/smrtanalysis_v3/current/etc/setup.sh\n";
print "fofnToSmrtpipeInput.py input.fofn > input.xml\n";
print "smrtpipe.py --params=filter.xml xml:input.xml\n";

system("qsub $dir/filter.pbs");
