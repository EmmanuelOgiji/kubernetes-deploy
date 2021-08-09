# kubernetes-deploy
Personal project to further understanding of kubernetes

# Objectives
This test project is to apply knowledge learnt from Kubernetes CKAD training.
This should allow more understanding of kubernetes deployment, AWS EKS and so on


# Problem
The problem should go as follows:
- Run an nginx kubernetes deployment on an AWS EKS cluster using Terraform. 
    - Should be deployed to via a pipeline.
    - The deployment should be a simple nginx deployment exposed by a NodePort service
    - The home html page should be mounted as a volume
    - Look to follow best practice progressively e.g. set security context, service account, network policy
- Integrate ArgoCD, Prometheus into the cluster
