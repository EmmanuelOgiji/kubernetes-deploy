# kubernetes-deploy
Personal project to further understanding of kubernetes

# Objectives
This test project is to apply knowledge learnt from Kubernetes CKAD training.
This should allow more understanding of kubernetes deployment, AWS EKS and so on


# Problem
The problem should go as follows:
- Build an AWS EKS Cluster with public and private node groups using Terraform
- Run an nginx kubernetes deployment on the EKS cluster.
    - The deployment should be a simple nginx deployment exposed by a LoadBalancer service
    - The home html page should be mounted as a volume
    - Look to follow best practice progressively e.g. set security context, service account, network policy
- Integrate ArgoCD, Prometheus into the cluster
