#!/bin/sh
#check documenation on startup scripts on https://cloud.google.com/compute/docs/instances/startup-scripts/linux
# user=`whoami`
# echo "Logged in as user: $user" >> /startup-script-log
# echo "installing go modules" >> /startup-script-log
# runuser -l bootstrap -c "go get \"github.com/google/go-github/github\""
# runuser -l bootstrap -c "go get \"golang.org/x/oauth2\""
# runuser -l bootstrap -c "echo \"export GO111MODULE=off\" >> /home/bootstrap/.profile"
# runuser -l bootstrap -c "source /home/bootstrap/.profile"
runuser -l bootstrap -c "cd /home/bootstrap/lz-Bootstrap/landing-zone-automation/  && backend/backend &"