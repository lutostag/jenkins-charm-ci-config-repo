#!/bin/bash -xe
rm -fr *

git clone https://github.com/lutostag/layer-jenkins.git -b built jenkins
cd jenkins
tox
