# MediaWiki Kubernetes Deployment

## MEDIAWIKI PROBLEM STATEMENT
 > Automate the deployment of MediaWiki using Kubernetes with Helm Chart/any equivalent automation.

### MEDIAWIKI Deployment Details

***
> Tools and Technology used for MEDIAWIKI Deployment.
  * Infrastructure as Code -- Terraform
  * Azure Kubernetes Services -- Azure
  * Helm Chart for the Deployment of MediaWiki and MariaDB
***

### Provisioning of infrastructure from local setup
#### Terraform
 * Install latest terraform locally
 * Change directory to "infrastructure" folder
 ```powershell
 cd infrastructure
 ```
 * Update default variables in "**variables.tf**"
```json
variable "prefix" {
  description = "A prefix used for all resources in this example"
  type    = string
  default     = "mediawiki"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  type    = string
  default     = "<location>"
}

variable "env" {
  description = "Possible values could be Dev/Test/Prod."
  default     = "dev"
}

variable "aks_version" {
  description = "K8S  version"
  default     = "1.27.9"
}
```
* Initiate terraform locally.
```powershell
terraform init
```
* Run terraform plan to see resources which are going to be created.
```powershell
terraform plan
```
* Apply the changes to create Azure resources 
```powershell
terraform apply
```

### Terraform will create,
***
  * Azure Kubernetes Service.
  * Virtual Network and subnet for Azure Kubernetes Service.
  * Select Azure CNI as a networking with Azure Network Policies.
  * Creates System Assigned Identity to provide access to other Azure resources.
  * Node pool with auto scaling enabled.
***

### Helm Deployment to Azure Kubernetes Service
* Change directory to "deploy"
```powershell
cd deploy
```
* Update variables value or export as environment variable in a bash terminal for "**deploy.sh**"
```powershell
#### If Running Script Manually via CLI then set environment values in local terminal or supply proper values in this script #####
export MEDIAWIKI_SUBSCRIPTION="<subscription-id of Azure Account>"
export RESOURCE_GROUP="<resource-group-name of K8S-server>"
export K8S_CLUSTERNAME="<K8S cluster-name Name>"
export MEDIAWIKI_NAMESPACE="wiki"
```
* Bash script is using Bitnami MediaWiki Helm Chart Repository to deploy MediaWiki and MariaDb.
* Deployment of Helm chart is automated and script will provide MediaWiki URL, Username and Password in following format.
  
```powershell
Mediawiki URL: http://<LoadBalancer-IP>/
Username: user
Password: <password-from-secret>
```
###########################################################################################################

### MEDIAWIKI Deployment from GitHub Actions CI/CD Pipeline

### Create GitHub Secrets & Push Code
```powershell
  * Go to https://github.com/vivek-2222005/mediawiki-app/settings/secrets/actions
  * Configure necessary secrets and their value defined in your pipeline.
  * Push code to "main" branch to trigger deployment pipeline
  * Two jobs are define in GitHub actions pipeline
    1. Infrastructure as Code -- Setup infrastructure as defined in terraform scripts.
    2. deploy-app -- Deploy application once infra setup is completed.
  * After the completion of pipeline infra and application both will be deployed in a automated way. 
```
## GitHub Actions Pipeline 

### Pipeline Secrets
![github-secrets](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/dde62fdf-3a88-4c2d-ac3f-a758b8e9d223)
***
### Pipeline Jobs
![cicd-pipeline](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/b9c5dae5-9253-4ed0-9c38-bf5305bdcc51)
***
### GitHub Infra Setup Step 
![infra-steps-cicd-pipeline](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/ec9e797a-9493-4bd5-9bc8-6fc29f9f543a)
***
### GitHub App Deployment Step 
![app-deployment-steps-cicd-pipeline](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/e308412a-ea82-4e28-99fc-ff4c55ca3d43)
***

## Kubernetes resources

### Deployments
![deployment](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/1d1a7d7d-c65c-4b59-ba12-98e89ef8eb6c)
***
### Statefulsets
![mariadb-stateful-set](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/acc0ef98-09dd-4539-8694-25cd109c8a85)
***
### Pods
![pods](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/ced16eca-a23c-4a5d-bad5-ca2382a869f0)
***
### Services
![mediawiki-services](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/491b48e1-a33c-4a3d-b953-aa916ab223e6)
***
### Persistent Volume
![pv](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/695c4ce9-87a6-4028-a9ae-fa0da88e4e08)
***
### Persistent Volume Claims
![pvc](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/8c3b6b21-748b-4cf0-9520-4ce1b04e99e7)
***
### Secrets
![secrets](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/91e6e833-2167-4a4a-840a-566b5654ef18)
***
### MediaWiki Application
***
![Application-mediawiki](https://github.com/vivek-2222005/mediawiki-application/assets/136461978/89027f76-f28c-4fa5-a223-138f59c695b9)
***
