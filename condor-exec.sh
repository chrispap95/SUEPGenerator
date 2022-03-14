#!/bin/bash
echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node

# setting up the input variables
CMSSW=$1
numEvts=$2
mMed=$3
scenario=$4
cluster=$5
process=$6

# bring in the tarball you created before with caches and large files excluded:
xrdcp -s root://cmseos.fnal.gov//store/user/chpapage/CMSSW_TARBALLS/${CMSSW}.tgz .
source /cvmfs/cms.cern.ch/cmsset_default.sh 
tar -xf ${CMSSW}.tgz
rm ${CMSSW}.tgz
cd ${CMSSW}/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"

# run the desired code
cmsRun SUEPGenerator/Pythia8Interface/test/suep_decay_${scenario}.py maxEvents=${numEvts} mMed=${mMed}
xrdcp -f output_numEvent${numEvts}.root root://cmseos.fnal.gov//store/user/chpapage/SUEPTest/mMed${mMed}_gen14TeV_${scenario}_HT100_${cluster}_${process}.root
rm output_numEvent${numEvts}.root
 
