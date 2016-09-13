#!/bin/bash -xe
juju show-model ||
echo -e 'jenkins-clean-test\npass\npass' | juju register $(vault-client read secret/jenkins-clean-test | awk '/key/{print $2}')

git clone https://github.com/lutostag/jenkins-charm-ci-config-repo.git -b self-ci
juju deploy jenkins-charm-ci-config-repo/bundle.yaml
juju wait

git clone https://github.com/lutostag/layer-jenkins.git -b built
juju upgrade-charm -p layer-jenkins jenkins
juju wait
