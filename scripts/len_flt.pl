use Getopt::Long;
GetOptions(
'd=s'  =>\$cutoff,
);

open in,"$ARGV[0]";
open o,">$ARGV[0]_len_flt.fasta";
select o;

$/=">";
while(<in>){
chomp;
($head,$seq)=split/\n/,$_,2;
$seq=~s/\s+//g;
$len=length($seq);
if($len>=$cutoff){
print ">$head\n$seq\n";
}
}
