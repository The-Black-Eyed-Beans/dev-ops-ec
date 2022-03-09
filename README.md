# Dev Ops
## ECS Folder
### Description
Uses Docker Compose with an ECS context connected to my AWS account to create an ECS cluster.
### Usage
Use command <br> <b>docker compose --project-name name --file docker-compose.yml up</b> <br>to create cluster. <br>You need to create a file, config.env, to provide environment variables. Use example.env for reference.
Also, need environment variables AWS_ID and AWS_REGION.
<br>Use command <br>
<b>docker compose --project-name name --file docker-compose.yml down</b>
<br>to tear down cluster.
## EKS Folder
### Description
Uses eksctl to create EKS cluster, and uses cluster.yaml to create for some configuration.
### Usage
Use command <br> 
<b>eksctl create cluster -f cluster.yaml</b>
<br>to create EKS cluster.
<br>Use command 
<br><b>eksctl destroy cluster -f cluster.yaml</b>
<br>to tear down EKS cluster.
## Kubernetes Folder
### Description
Deployments and services used to run microservices on Kubernetes. Microservice folder has microservices with independent services while Gateway folder has microservice sharing a single service which the gateway uses to send requests to them.
### Usage
Need to create a configmap containing the keys (and their values):
<br>USER_PORT, UNDER_PORT, TRANS_PORT, BANK_PORT, DB_PORT and DB_NAME.
<br>Need to create a secret containing the keys (and their values):
<br>DB_USERNAME, DB_PASSWORD, DB_HOST, ENCRYPT_SECRET_KEY, JWT_SECRET_KEY.