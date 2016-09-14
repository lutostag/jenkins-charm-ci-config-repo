#!/bin/bash -xe
rm -fr *

# make sure we have a juju controller setup (or spin on waiting for secret to register)
juju show-controller jenkins-clean-test >/dev/null ||
echo "Waiting for registration secret to be passed into vault" &&
while true;
    do vault-client read -field=register-key secret/charm/juju-model 2>/dev/null && break; sleep 20;
done &&
echo -e 'jenkins-clean-test\npass\npass' | juju register $(vault-client read -field=register-key secret/charm/juju-model)

git clone https://github.com/lutostag/jenkins-bundle-example.git -b self-ci
juju deploy ./jenkins-bundle-example/bundle.yaml
juju wait

git clone https://github.com/lutostag/layer-jenkins.git -b built jenkins
juju upgrade-charm --path=./jenkins jenkins
juju wait

juju status | grep error >/dev/null && return 1
