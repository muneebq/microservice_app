#!/bin/bash

AWS=$(which aws)
AWS_PROFILE=~/.aws/config
TF=$(which terraform)
TFv=$(terraform -v | awk '{ print $2 }' |cut -d"." -f2)

if [ -z ${AWS} ]; then
    echo "Could not found AWS CLI"
    exit 1
fi

if [ -z ${TF} ]; then
    echo "Could not found Terraform"
    exit 1
fi

if [ -z ${AWS_PROFILE} ]; then
    echo "Cound not found a valid profile, an aws profile must be created: ~/.aws/config"
    exit 1
fi

pushd iac
#Run Terraform init

terraform init

#Run Terraform plan

terraform plan 

#Run terraform apply
echo "Creating infrastructure, takes around 10-15 minutes"
terraform apply -auto-approve

if [ ! -f ~/.kube ]; then
    mkdir -p ~/.kube
fi
sleep 5
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

export REGION=$(terraform output -raw region)
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

popd
docker-compose build && docker images

#Authenticate docker with for ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

#Upload docker images to Amazon ECR repositories
docker tag assets_service $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/assets_service 
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/assets_service
docker tag front_end_service $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/front_end_service
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/front_end_service
docker tag newsfeeds_service $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/newsfeeds_service
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/newsfeeds_service
docker tag quotes_service $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/quotes_service
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/quotes_service

pushd k8s

#Update container image in k8s deployment files
#Create Deployments, Services and PODs in EKS cluster

kubectl set image -f assets-deployment.yaml assets=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/assets_service --local -o yaml

kubectl set image -f newsfeed-deployment.yaml newsfeed=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/newsfeeds_service --local -o yaml

kubectl set image -f quotes-deployment.yaml quotes=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/quotes_service --local -o yaml

kubectl set image -f front-end-deployment.yaml front-end=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/front_end_service --local -o yaml

kubectl apply -f assets-service.yaml,newsfeed-service.yaml,quotes-service.yaml,front-end-service.yaml,assets-deployment.yaml,newsfeed-deployment.yaml,quotes-deployment.yaml,front-end-deployment.yaml
sleep 20
echo "Please use the following URL to access the application on port 8081"
kubectl get svc front-end

exit 0
