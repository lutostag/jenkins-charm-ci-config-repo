#!/bin/bash -xe
rm -fr *

juju show-controller jenkins-clean-test >/dev/null ||
echo -e 'jenkins-clean-test\npass\npass' | juju register $(vault-client read secret/jenkins-clean-test | awk '/key/{print $2}')

git clone https://github.com/lutostag/jenkins-bundle-example.git -b self-ci
juju deploy ./jenkins-bundle-example/bundle.yaml
juju wait

git clone https://github.com/lutostag/layer-jenkins.git -b built jenkins
juju upgrade-charm --path=./jenkins jenkins
juju wait

juju status | grep error >/dev/null && return 1~
