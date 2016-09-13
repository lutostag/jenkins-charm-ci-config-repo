#!/bin/bash -xe
rm -fr *

juju show-controller jenkins-clean-test >/dev/null ||
echo -e 'jenkins-clean-test\npass\npass' | juju register $(vault-client read secret/jenkins-clean-test | awk '/key/{print $2}')

git clone https://github.com/lutostag/jenkins-charm-ci-config-repo.git -b self-ci
cd jenkins-charm-ci-config-repo
juju deploy bundle.yaml
juju wait
cd ..

git clone https://github.com/lutostag/layer-jenkins.git -b built
juju upgrade-charm -p layer-jenkins jenkins
juju wait
