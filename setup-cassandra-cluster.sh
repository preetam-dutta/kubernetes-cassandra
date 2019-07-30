#!/bin/bash

isHostPath=true

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
  echo "Docker Volume for HostPath:"
  for index in 1 2 3 ; do
    (( $(docker volume ls | grep -c data-cassandra-${index}) == 0 )) && docker volume create data-cassandra-${index}
    (( $(docker volume ls | grep -c log-cassandra-${index}) == 0 )) && docker volume create log-cassandra-${index}
    docker volume ls | grep -e "data-cassandra-${index}|log-cassandra-${index}"
  done
  echo "Setting up storage class"
  kubectl apply -f hostpath-storage-class.yaml
  sleep 5
  kubectl get sc
  echo ""
}

setupAwsEbsStorage() {
  echo "Setting up storage class"
  kubectl apply -f awsebs-storage-class.yaml
  sleep 5
  kubectl get sc
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

echo "Setting up Persistent Volume and Persistent Volume Claim"
kubectl apply -f persistent-volume-0.yaml
sleep 5
kubectl apply -f persistent-volume-1.yaml
sleep 5
kubectl apply -f persistent-volume-2.yaml
sleep 5
kubectl get pv,pvc
echo ""
sleep 2

echo "Setting up Cassandra Stateful Set"
kubectl apply -f cassandra-stateful-set.yaml
sleep 10
kubectl get sc,pv,pvc,all
sleep 5
kubectl get sc,pv,pvc,all

echo "Execute the below command to check the status of coming up Cassandra nodes"
echo "kubectl get all"

exit 0
