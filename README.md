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


## Future Work

Right now, the whole orchestation is done by `setup.sh` script, which is not the 
intended behavior for actual development and production environments. Following
are my recommendations to implement it with a CI/CD pipeline:

* Infrastructure shall be provisioned with Terraform
* Code shall be hosted on the Github repositiory
* Credentials/Environment details to be stored in github secrets
* Github Actions workflow shall be configured to build and publish the images automatically to the ECR
* Github Action workflow shall deploy the changes to the K8s cluster
* We can also define different tests on the code in the pipeline before the docker images are build and 
or deployed to K8s
* We can implement multiple Github workflows for differnet environments i.e Dev, Stage  and Production
* There can be different triggers for each environment
* Creating feature branch on the github repository triggers the pipeline for Dev environment and deploys to Dev K8s cluster
* Creating a tag in the feature branch triggers pipline in Stage environment and deploys to Stage K8s cluster
* Once Code is merged to master, it triggers pipline for the production environment and deploys to the production cluster
