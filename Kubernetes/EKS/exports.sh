#!/bin/bash
SECRETS="$(aws secretsmanager get-secret-value --secret-id ${SECRET_NAME} --region ${AWS_REGION} --profile ethan.carson | jq -r .'SecretString')"
export VPC_ID="$(echo $SECRETS | jq -r .'VPCID')"
export VPC_CIDR="$(echo $SECRETS | jq -r .'VPCCidr')"
export PUBLIC_SUBNET1="$(echo $SECRETS | jq -r .'PublicSubnetID1')"
export PUBLIC_SUBNET2="$(echo $SECRETS | jq -r .'PublicSubnetID2')"
export PRIVATE_SUBNET1="$(echo $SECRETS | jq -r .'PrivateSubnetID1')"
export PRIVATE_SUBNET2="$(echo $SECRETS | jq -r .'PrivateSubnetID2')"

cat cluster.yaml | envsubst > new-cluster.yaml