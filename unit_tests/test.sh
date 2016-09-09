#!/bin/sh
# you will need jenkins-job-builder installed from pip (not system packages)
# sudo apt-get install pip; sudo pip install -I jenkins-job-builder==1.1.0
cd $(dirname "$(readlink -f "$0")")/../jenkins/jobs/

jenkins-jobs test *.yml >/dev/null 2>&1

if [ "$?" -eq "0" ]
then
    echo "pass"
else
    jenkins-jobs test *.yml
    echo "fail"
fi


