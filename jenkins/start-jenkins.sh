#!/bin/bash

echo "jenkins.service: ## Starting ##" | systemd-cat -p info

docker run -itd -p 8080:8080 \
       	--name jenkins \
	-e JENKINS_ADMIN_ID="bootstrap" \
	-e GITHUB_USERNAME="prateek2408" \
	-e GITHUB_TOKEN="test" \
	-e GITHUB_REPO="automated-lz" \
	-e JENKINS_ADMIN_PASSWORD="bootstrap" jenkins:custom
