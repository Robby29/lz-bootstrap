#!/bin/bash
#constants
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
bold=$(tput bold)
normal=$(tput sgr0)

logfile=bootsrap-script.logs
echo -e "${BLUE}[ Welcome to the landing zone automation bootstrap script. This script will help you setup the landing zone automatically in no time. Enjoy the ride ]\n"
sleep 2

echo -e "${BLUE}Enter the ${bold}region${normal} ${BLUE}where you wish to setup the landing zone${GREEN}"
read region
echo -e "${BLUE}Enter the ${bold}zone${normal} ${BLUE} where you wish to deploy the compute engine${GREEN}"
read zone
# echo -e "${BLUE}Enter the landing zone ${bold}project id${normal} ${BLUE} that was created as prerequisites for this script. Follow the README.md for more details${GREEN}"
# read project_id
# echo -e "${BLUE}Enter the ${bold}member id or service account${normal} ${BLUE} name which will be used to run the setup${GREEN}"
# read member_id
project_id=`gcloud config list --format="value(core.project)"`
member_id=`gcloud auth list --filter=status:ACTIVE --format="value(account)"`
sleep 2
echo -e "\n${BLUE}Thank you for the inputs.\nProject: $project_id\nUser: $member_id\nFollowing resources will be created as part of the landing zone bootstrap project:\n1.Network with one subnet\n2.Firewall rules to allow connection via IAP\n3.Compute Engine where the automation tool will run\n4.Cloud Nat\n${NC}"
#echo -e "${RED}Note: Estimated cost per day for the above resources is 20\$${NC}\n"
#Create project

#IAM permission for admin
# gcloud projects add-iam-policy-binding $3 \
#     --member=user:$4 \
#     --role=roles/owner

#Enable API
#compute engine
sleep 2
#echo -e "${BLUE}Creating network....${NC}"
#Network
gcloud compute networks create lz-network --subnet-mode=custom >> $logfile 2>&1
gcloud compute networks subnets create lz-subnet-$region --network=lz-network --region=$region --range=10.160.0.0/24 >> $logfile 2>&1
echo -e "${GREEN}Network created.${NC}"

sleep 2
##Firewall
#echo -e "${BLUE}Creating Firewalls......${NC}"
gcloud compute firewall-rules create lz-allow-ssh \
--direction=INGRESS --priority=1000 \
--network=lz-network --action=ALLOW --rules=tcp \
--source-ranges 35.235.240.0/20 >> $logfile 2>&1
echo -e "${GREEN}Firewalls created.${NC}"

sleep 2
#Cloud-Nat
#echo -e "${BLUE}Creating Cloud Nat......${NC}"
gcloud compute routers create lz-nat-router \
    --network lz-network \
    --region $region >> $logfile 2>&1
gcloud compute routers nats create lz-nat-config \
    --router-region $region \
    --router lz-nat-router \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips >> $logfile 2>&1
echo -e "${GREEN}Cloud Nat Created ....${NC}"
sleep 2
#Service Account

#Compute
#echo -e "${BLUE}Creating Bootstrap Compute engine......${NC}"
gcloud compute instances create lz-bootstrap \
    --project=lz-automation \
    --machine-type=n1-standard-2 \
    --image-family=debian-10 \
    --image-project=virtual-flux-328808 \
    --network=lz-network \
    --subnet=lz-subnet-$region \
    --zone=$zone \
    --no-address \
    --metadata-from-file=startup-script=./startup-script.sh >> $logfile 2>&1
echo -e "${GREEN}Created Bootstrap Compute engine${NC}"


#Add owner role to compute service account
#echo -e "${BLUE}Adding roles to compute service account${NC}"
serviceAccount=`gcloud compute instances describe lz-bootstrap --zone=$zone --format="value(serviceAccounts.email)"`
echo -e "${BLUE}Service account detected\n${GREEN}$serviceAccount${NC}"
gcloud projects add-iam-policy-binding $project_id \
    --member=serviceAccount:$serviceAccount \
    --role=roles/owner >> $logfile 2>&1

sleep 2
#IAP
##IAM permission
echo -e "${BLUE}Adding IAP tunnel permissions${NC}"
gcloud projects add-iam-policy-binding $project_id \
    --member=user:$member_id \
    --role=roles/iap.tunnelResourceAccessor >> $logfile 2>&1actually 

echo -e "${BLUE}Run the following command to create cloud IAP tunnel in order to connect to the landing zone automation ui.${NC}"
##IAP tunnel
echo -e "${GREEN} [ gcloud compute start-iap-tunnel lz-bootstrap --zone=asia-south1-a 8081 --local-host-port=localhost:8087 --project=lz-automation ] ${NC}\n You can access the portal using the below link\n ${GREEN}http://localhost:8087 ${NC}"
# sleep 5
# echo "IAP tunnel created. Please access the landing zone automation tool using the folloiwng link: http://localhost:8087"
