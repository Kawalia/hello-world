#!/bin/bash -l
 
PROJECTDIR=$1 ###e.g. 
#FileNo=$2
ENRID=$2 ### only number
Outdir=$3 ### ResultsDir ## 
mkdir -p $Outdir

BCFTOOL=<dir>/bcftools-1.2/bcftools
### Need to create first KGVCF file by using following commonds 

#$BCFTOOL view -R ENRID4.bed ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.vcf.gz | sed 's/;AF=/;AF_ALL=/g' | sed 's/AC=/AC_ALL=/g' | sed 's/;AN=/;AN_ALL=/g' | sed 's/EUR_AF/AF/g' | gzip > ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.Enrid4_target.vcf.gz

####################
KGVCF=<dir>/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.Enrid${ENRID}_target.vcf.gz
#list=`find $PROJECTDIR -name "*.Improved.bam" -type f | sort | head -$FileNo`
#BEGIN=1;END=50;
BEGIN=1;
FileNo=`ls -tr $PROJECTDIR/SID*/AID*/*.Improved.bam | wc -l`
if [ $FileNo -gt 50 ]; then
        END=50
else
        END=$FileNo
fi

list=`ls -tr $PROJECTDIR/SID*/AID*/*.Improved.bam | sed -n ''$BEGIN','$END'p'`
for i in $list;do
	filename=$(basename $i)
	basename=${filename%.*}
	verifyBamID --vcf $KGVCF --bam $i --out $Outdir/${basename}_verifyBamID.Report --verbose --ignoreRG --maxDepth 1000 --precise > $Outdir/${basename}_verifyBamID.Report.STDOUT 2>&1
done

