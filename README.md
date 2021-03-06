## Description

Deploy a microservice based Java application on AWS.

## Services / Tools 

* AWS Elastic Kubernetes Service (EKS)
* AWS Elastic Container Registry (ECR)
* Terraform
* AWS Cli
* Kubectl
* Docker

## Prerequisites

Following are the pre-requisites to be able to deploy and run the application: 

* AWS account
* AWS [CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) 
* [Docker](https://docs.docker.com/engine/install/ubuntu/)

## Deploy:

From the root of the folder, execute the following script:

`./setup.sh`

### Workflow

Here is the workflow after ./setup.sh script is executed:

* Infrastructure to run the application on AWS is brought UP from scratch i.e EKS cluster, ECR registries, VPC,
Security groups, Auto scaling group e.t.c
* Docker images are build locally on the machine from where the script is executed
* Docker images are uploaded to the corresponsing ECR registries
* Application is deployed on K8s using the images we built during the last stage

## Files and Folders

Following files and folders are of interest:
* `Dockerfile` and `docker-compose.yaml` build the docker images
* `iac` folder contains the infrastructure-as-a-code
* `k8s` folder contains the files used to deploy application on k8s
* `setup.sh` script orchestrates the whole process or building infrastructure and deploying the application
