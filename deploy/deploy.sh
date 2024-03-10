#!/bin/bash

############# If Running Script Manually via CLI then set environment values in local terminal or supply proper values in this script ##########
#MEDIAWIKI_SUBSCRIPTION="<subscription-id of Azure Account>"
#RESOURCE_GROUP="<resource-group-name of K8S-server>"
#K8S_CLUSTERNAME="<K8S cluster-name Name>"
#MEDIAWIKI_NAMESPACE="wiki"

echo "--------------------------------------------------------------"
echo "SET SUBSCRIPTION"
echo "--------------------------------------------------------------"
az account set --subscription $MEDIAWIKI_SUBSCRIPTION
echo "Subscription set to $MEDIAWIKI_SUBSCRIPTION"

echo "--------------------------------------------------------------"
echo "GET $K8S_CLUSTERNAME CREDENTIALS"
echo "--------------------------------------------------------------"
az aks get-credentials --resource-group $RESOURCE_GROUP --name $K8S_CLUSTERNAME

#Set cluster's context
kubectl config use-context $K8S_CLUSTERNAME

echo "--------------------------------------------------------------"
echo "CREATE $MEDIAWIKI_NAMESPACE  NAMESPACE"
echo "--------------------------------------------------------------"
NAMESPACE=$(kubectl get namespace $MEDIAWIKI_NAMESPACE  --ignore-not-found)

if [ -n "$NAMESPACE" ]; then
    echo "Skipping creation of $MEDIAWIKI_NAMESPACE  - already exists"
else
    kubectl create namespace $MEDIAWIKI_NAMESPACE 
    NAMESPACE=$(kubectl get namespace $MEDIAWIKI_NAMESPACE  --ignore-not-found)
    echo "namespace $NAMESPACE  created"
fi

echo "--------------------------------------------------------------"
echo "Add Bitnami MediaWiki Helm Chart Repository"
echo "--------------------------------------------------------------"

helm repo add bitnami https://charts.bitnami.com/bitnami

echo "--------------------------------------------------------------"
echo "Update Helm Repository"
echo "--------------------------------------------------------------"

helm repo update

echo "--------------------------------------------------------------"
echo "Apply Bitnami MediaWiki Helm Chart Repository"
echo "--------------------------------------------------------------"

helm install mediawiki -n wiki bitnami/mediawiki

echo "--------------------------------------------------------------"
echo "Getting Deployment Values"
echo "--------------------------------------------------------------"

export APP_HOST=$(kubectl get svc --namespace wiki mediawiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo "Application Host: $APP_HOST"

export APP_PASSWORD=$(kubectl get secret --namespace wiki mediawiki -o jsonpath="{.data.mediawiki-password}" | base64 -d)
echo "Application Password: $APP_PASSWORD"

export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace wiki mediawiki-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
echo "MariaDb Root Password: $MARIADB_ROOT_PASSWORD"

export MARIADB_PASSWORD=$(kubectl get secret --namespace wiki mediawiki-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
echo "MariaDb Password: $MARIADB_PASSWORD"

echo "--------------------------------------------------------------"
echo "Upgrade Helm Deployment"
echo "--------------------------------------------------------------"

helm upgrade --namespace wiki mediawiki oci://registry-1.docker.io/bitnamicharts/mediawiki --set mediawikiHost=$APP_HOST,mediawikiPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD

echo "--------------------------------------------------------------"
echo "Please use following credentials to login"
echo "--------------------------------------------------------------"

export SERVICE_IP=$(kubectl get svc --namespace wiki mediawiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")

echo "Mediawiki Application URL: http://$SERVICE_IP/"
echo Username: user
echo Password: $(kubectl get secret --namespace wiki mediawiki -o jsonpath="{.data.mediawiki-password}" | base64 -d)
