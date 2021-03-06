#!/usr/bin/env bash
echo "Create Namespace for Prometheus"
kubectl create namespace prometheus
echo "Add the prometheus-community chart repository"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
echo "Deploy Prometheus"
helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
echo "Entering while-loop to wait for prometheus pods to be ready"
while [[ $(kubectl -n prometheus get pods -l app=prometheus -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True True True True True" ]]; do echo "waiting for pod to be ready" && sleep 1; done
echo "Port-forwarding Prometheus console"
kubectl --namespace=prometheus port-forward deploy/prometheus-server 9090
echo "Prometheus console now available at: localhost:9090"
