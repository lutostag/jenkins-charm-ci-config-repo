#!/bin/bash -xe
juju show-model jenkins-clean-test || juju register $(vault-client read secret/jenkins-clean-test | awk '/key/{print $2}') 

git clone https://github.com/lutostag/jenkins-charm-ci-config-repo.git -b self-ci
juju deploy -m jenkins-clean-test jenkins-charm-ci-config-repo/bundle.yaml
juju wait -e jenkins-clean-test


git clone https://github.com/lutostag/layer-jenkins.git -b built
juju upgrade-charm -m jenkins-clean-test -p layer-jenkins jenkins
juju wait -e jenkins-clean-test
