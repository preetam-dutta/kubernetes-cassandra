#!/bin/bash

isHostPath=true
k8cfg=$(dirname $0)/../k8

usage() {
  echo "Usage: $0"
  echo "  setup cassandra cluster locally with storage class as docker volume"
  echo ""
  echo "Usage: $0 -c"
  echo "  setup cassandra cluster on cloud(AWS) with storage class as EBS volume"
  echo "  pre-requisite AWS cluster with 1 master and 3 worker with min footprint of t3-small"
  echo ""
}

setupHostPathStorage() {
  echo "setting up docker volume"
  sleep 5
  for index in 1 2 3 ; do
    (( $(docker volume ls | grep -c data-cassandra-${index}) == 0 )) && docker volume create data-cassandra-${index}
    (( $(docker volume ls | grep -c log-cassandra-${index}) == 0 )) && docker volume create log-cassandra-${index}
  done
  for index in 1 2 3 ; do
    docker volume ls | grep -e "data-cassandra-${index}|log-cassandra-${index}"
  done
  echo "setting up storage class for hostpath (docker volume)"
  kubectl apply -f $k8cfg/storage-class-local.yaml
  sleep 5
  kubectl get sc
  echo "----------------------------------------------------------------------------------------------------------------"
  echo ""
}

setupAwsEbsStorage() {
  echo "setting up storage class for AWS EBS"
  sleep 10
  kubectl apply -f $k8cfg/storage-class-cloud.yaml
  sleep 5
  kubectl get sc
  echo "----------------------------------------------------------------------------------------------------------------"
  echo ""
  sleep 2
}

while getopts ":ch" opt; do
  case ${opt} in
    c)
      isHostPath=false
      ;;
    h)
      usage
      ;;
    *)
      usage
      ;;
   esac
done

if ( $isHostPath ); then
  setupHostPathStorage
else
  setupAwsEbsStorage
fi

echo "setting up persistent volume and persistent volume claim"
kubectl apply -f $k8cfg/persistent-volume-0.yaml
sleep 5
kubectl apply -f $k8cfg/persistent-volume-1.yaml
sleep 5
kubectl apply -f $k8cfg/persistent-volume-2.yaml
sleep 5
kubectl get sc,pv,pvc,all --selector="app=cassandra,env=dev"
echo "----------------------------------------------------------------------------------------------------------------"
sleep 2

echo "setting up cassandra stateful set"
kubectl apply -f $k8cfg/stateful-set.yaml
echo "----------------------------------------------------------------------------------------------------------------"
sleep 10
kubectl get sc,pv,pvc,all --selector="app=cassandra,env=dev"
echo "----------------------------------------------------------------------------------------------------------------"
sleep 5
kubectl get pod --selector="app=cassandra,env=dev"
echo ""
echo "execute the below command to check the status of coming up cassandra nodes"
echo ""
echo "  kubernetes pod status: kubectl get pod --selector=\"app=cassandra,env=dev\""
echo "  cassandra node status: kubectl exec -it cassandra-0 nodetool status"
echo "  cassandra cqlsh:       kubectl exec -it cassandra-0 cqlsh"
echo ""
exit 0
