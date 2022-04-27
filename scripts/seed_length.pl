use Getopt::Long;

my ($fofn,$dir);
GetOptions(
  "g=s"       =>\$genome_size,
  );

open in,"$ARGV[0]";###filtered_subreads.fasta_len
open o,">seed_stat";
select o;
@data=<in>;
for($i=1000;$i<=30000;$i+=1000){
$ratio=0;$gt_cov=0;
foreach(@data){
chomp;
@t=split/\t/;
if($i>=$t[1]){
$lt+=$t[1];
}
else{$gt+=$t[1];}
}
$ratio=$lt/$gt;
$gt_cov=$gt/$genome_size;
print "$i\t$ratio\t$gt_cov\n";
$gt=0;
$lt=0;
}
