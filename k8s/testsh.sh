#!/bin/bash
# myPodName="$(kubectl get pods | awk '{print $1}' | grep dspace-solr )"
# myPodStatus="$(kubectl get pods | grep dspace-deploy | awk '{print $2}')"
# myPodAge="$(kubectl get pods | grep dspace-deploy | awk '{print $3}')"
# config="$(kubectl get configmap | grep local-config-map )"

# echo "$myPodName" 
# echo "$myPodStatus" 
# echo "$config" 


# myPodName="$(kubectl get pods | awk '{print $1}' | grep create-admin )"
# echo "$myPodName"
# dastatus = $(kubectl logs $myPodName )
# echo "${dastatus}"

# # Check if pod started
# myPodStatus="$(kubectl get pods | grep dspace-angular | awk '{print $2}')"
# while [ "$myPodStatus" != "1/1" ]
# do
#    echo "Current Deployment status: $myPodStatus" 
#    myPodStatus="$(kubectl get pods | grep dspace-angular | awk '{print $2}')"
# done

podStatus="$(kubectl get pods | grep dspace-create-admin | awk '{print $3}' )"
while [ "$podStatus" != "Completed" ]
do 
    sleep 5
    podStatus="$(kubectl get pods | grep dspace-create-admin | awk '{print $3}' )"
    echo "$podStatus" 
done

