# The content of fasta2q.pl is as follows:
#!/usr/bin/perl 

die ("perl $0 *.tab *.fa\n" ) unless (@ARGV==2);
open(FILE,"<$ARGV[0]") or die ("Can not open $ARGV[0] $!\n");
my (%h1,%h2,%h3,%h4);
while(<FILE>){
        chomp;
        if(/^>/){
                $_=~s/^>//g;
                if(/^(\w+\/\d+\/)(\d+)_(\d+)_CCS/){
                        $c=$1."ccs";
                        $s=$2;
                        $e=$3;
                        if($s>$e){
                                $l=$s-$e;
                                $h1{$c}=$e;
                                $h2{$c}=$l;
                                $h3{$c}='-';
                                $h4{$c}=$_;
                        }else{
                                $l=$e-$s;
                                $h1{$c}=$s;
                                $h2{$c}=$l;
                                $h3{$c}='+';
                                $h4{$c}=$_;
                        }
                }
        }
}
close FILE;
$/="\@m1";
open(IN,"<$ARGV[1]") or die ("Can not open $ARGV[1] $!\n");


