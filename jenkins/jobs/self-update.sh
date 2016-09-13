#!/bin/bash -xe
juju show-model jenkins-clean-test || juju register $(vault-client read secret/jenkins) 

git clone https://github.com/lutostag/layer-jenkins.git -b built
juju upgrade-charm -m jenkins -p layer-jenkins jenkins
