#!/bin/sh

#Remove IAP tunnel permission
echo "Removing IAP Tunnel User role from user"
gcloud projects remove-iam-policy-binding lz-automation \
    --member=user:robbysingh@google.com \
    --role=roles/iap.tunnelResourceAccessor

sleep 2
#Closing IAP tunnel
echo "Closing IAP tunnel on port 8085 locally .....\n"
echo "Closed IAP tunnel on port 8085\n"

sleep 2
#Delete compute engine created for bootstrapping
echo "Deleting VM lz-bootstrap.......\n"
gcloud compute instances delete lz-bootstrap -q --zone=asia-south1-a
echo "The following VM was deleted:\nlz-bootstrap\n"

sleep 2
#Delete cloud nat
echo "Deleting cloud nat ......\n"
gcloud compute routers nats delete lz-nat-config --region=asia-south1 --router=lz-nat-router -q
echo "The following cloud nat config was deleted:\nlz-nat-config"

sleep 2
#Delete Cloud Nat and Cloud Router
echo "Deleting cloud nat router......\n"
gcloud compute routers delete lz-nat-router --region=asia-south1 -q
echo "The following cloud nat router was deleted:\nlz-nat-router"

sleep 2
#Delete firewall rules
echo "Deleting firewall rule lz-allow-ssh ......\n"
gcloud compute firewall-rules delete lz-allow-ssh -q
echo "The following firewall rule was deleted:\nlz-allow-ssh"

sleep 2
#Delete subnet
echo "Deleting subnet lz-subnet-asia-south1 ......."
gcloud compute networks subnets delete lz-subnet-asia-south1 -q --region=asia-south1
echo "The following subnet was deleted:\nlz-subnet-asia-south1"

sleep 2
#Delete network
echo "Deleting network lz-network ......."
gcloud compute networks delete lz-network -q
echo "The following network was deleted:\nlz-network"

#Disable API
#compute engine
sleep 2
#Final confirmation message
echo "Bootstrap project resources created as part of landing zone automation have been deleted."
