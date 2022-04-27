@t1=split/\s+/,$t[-1];
foreach $seed(@t1){
system("mkdir -p $work_dir/$seed");

open $out1,">$work_dir/$seed/hgap.pbs";
print $sh "qsub $work_dir/$seed/hgap.pbs\n";
print $out1 "#PBS -N HGAP_$seed"."\n";
print $out1 "#PBS -l nodes=1:ppn="."$ppn"."\n";
print $out1 "#PBS -q $q"."\n";
print $out1 "#PBS -S /bin/bash"."\n";
print $out1 "cd "."$work_dir/$seed"."\n";
print $out1 "source /lustre/Work/qingxiangguo/dev/sofs/SMRT/smrtanalysis_v3/current/etc/setup.sh\n";
print $out1 "fofnToSmrtpipeInput.py $input_fofn > input.xml\n";
print $out1 "smrtpipe.py --params=params.xml xml:input.xml\n";

open $out,">$work_dir/$seed/params.xml";
foreach (@para){
if($_!~/genomeSize/ && $_!~/minLongReadLength/ && $_!~/minCorCov/){
print $out "$_";
}
elsif(/minCorCov/){
print $out "            <param name=\"minCorCov\"><value>$minCorCov<\/value><\/param>\n";
}
elsif(/minLongReadLength/){
print $out "            <param name=\"minLongReadLength\"><value>$seed<\/value><\/param>\n";
}
elsif(/genomeSize/){
print $out "            <param name=\"genomeSize\"><value>$genomesize<\/value><\/param>\n";
}
}
}
}
}

system("sh $work_dir/qsub.sh");
