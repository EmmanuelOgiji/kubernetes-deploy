# kubernetes-deploy
Personal project to further understanding of kubernetes

# Objectives
This test project is to apply knowledge learnt from Kubernetes CKAD training.
This should allow more understanding of kubernetes deployment, AWS EKS and so on


# Current State
This repository contains:
- Terraform code which sets up an AWS EKS Cluster with two node groups (one public and one private)
- Kubernetes manifests for:
  - A service account named Service User
  - A config map named html-config which holds a index.html file containing some basic html
  - A deployment called k8s-deploy which uses an nginx container to show a simple html page. Details about the deployment:
     - 2 replicas
     - A Rolling update deployment strategy with 1 pod as the maximum unavailable allowed
     - The pods:
        - use the service account service-user
        - run as user 1000 
        - contain one container which:
            - runs the nginxinc/nginx-unprivileged image
            - exposes the port 8080
            - mounts a volume containing data from the "html-config" config map at /usr/share/nginx/html
            - has a readiness probe which runs every 5 seconds after an initial delay of 5 seconds that uses the cat command to check that the expected index.html file has been mounted
            - has a liveness probe which runs every 5 seconds after an initial delay of 5 seconds that does a http get to the / path
            - has memory and cpu requests set as 64Mi amd 250m respectively
            - has memory and cpu limits set as 128Mi amd 500m respectively
  - A loadbalancer service called k8s-deploy which exposes the deployment to port 80 of the Load Balancer provisioned by AWS
  - A script which can be used to deploy prometheus into the cluster for logging and monitoring purposes in a separate namespace


# Solution
Note: In the steps below $ denotes that what follows is a terminal command
To run,
- Deploy EKS via Terraform:
  - Setup vars either inline or using a .tfvars file
  - $ terraform init
  - $ terraform plan
  - $ terraform apply
- To deploy kubernetes resources
  - Connect local kubectl to the cluster
    - Ensure your awscli is configured to access a role or user with sufficient permissions
    - $ aws eks --region eu-west-1 update-kubeconfig --name k8s-deploy
  - $ cd kubernetes-manifests
  - $ kubectl create -f .
- To deploy prometheus into the cluster
  - $ cd kubernetes-manifests/config
  - $ bash deploy_prometheus.sh