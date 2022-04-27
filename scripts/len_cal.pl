open in,"$ARGV[0]";
open o,">$ARGV[0]_len";
select o;

$/=">";
while(<in>){
chomp;
($id,$seq)=split/\n/,$_,2;
if($seq cmp ""){
$seq=~s/\s+//g;
$len=length($seq);
print "$id\t$len\n";
}
}
