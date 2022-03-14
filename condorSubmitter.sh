#!/usr/bin/sh
source ${PWD}/prepareCondor.sh

scenarios=(generic hadronic leptonic)
mMed=(125 200 300 400 750 1000)
evtsPerJob=5000
nJobs=4

for sc in ${scenarios[@]}
do
for mass in ${mMed[@]}
do
namestring=mMed${mass}_${sc}
argument=${CMSSW_VERSION}\ ${evtsPerJob}\ ${mass}\ ${sc}\ \$\(Cluster\)\ \$\(Process\)

# Write jdl file
cat > jdl/condor_${namestring}.jdl << "EOF"
universe = vanilla
Executable = condor-exec.sh
Should_Transfer_Files = YES
WhenToTransferOutput = ON_EXIT
Transfer_Input_Files = condor-exec.sh
Output = log/suep_$(Cluster)_$(Process).stdout
Error = log/suep_$(Cluster)_$(Process).stderr
Log = log/suep_$(Cluster)_$(Process).log
x509userproxy = $ENV(X509_USER_PROXY)
EOF
echo "Arguments = "${argument} >> jdl/condor_${namestring}.jdl
echo "Queue "${nJobs} >> jdl/condor_${namestring}.jdl

# Submit job
condor_submit jdl/condor_${namestring}.jdl
done
done
