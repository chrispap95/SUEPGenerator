#!/usr/bin/sh

scenarios=(generic leptonic hadronic)
mMed=(125 200 300 400 750 1000)

for sc in ${scenarios[@]}
do
for mass in ${mMed[@]}
do
namestring=mMed${mass}_gen14TeV_${sc}
edmFileUtil -f root://cmseos.fnal.gov//store/user/${USER}/SUEPTest/merged/${namestring}.root
done
done
