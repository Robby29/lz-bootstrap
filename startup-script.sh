#!/bin/sh
#check documenation on startup scripts on https://cloud.google.com/compute/docs/instances/startup-scripts/linux
runuser -l bootstrap -c "cd /home/bootstrap/lz-Bootstrap/landing-zone-automation/  && backend/backend &"
runuser -l bootstrap -c "cd /home/bootstrap/lz-Bootstrap && git clone https://github.com/g-lz-automation/lz-ci-cd-jenkins.git"
#runuser -l bootstrap -c "cd /home/bootstrap/lz-Bootstrap/lz-ci-cd-jenkins && terraform init && terraform apply -var-file terraform.tfvars -auto-approve"