#!/bin/bash

echo "----------------------------------------------------------------------------------------------------------------"
kubectl get sc,pv,pvc,all --selector="app=cassandra,env=dev"
echo "deleting above cassandra cluster resources..."
echo "----------------------------------------------------------------------------------------------------------------"
echo ""
sleep 2
kubectl delete statefulset.apps/cassandra \
service/cassandra \
pod/cassandra-2 \
pod/cassandra-1 \
pod/cassandra-0 \
persistentvolumeclaim/node-log-cassandra-2 \
persistentvolumeclaim/node-log-cassandra-1 \
persistentvolumeclaim/node-log-cassandra-0 \
persistentvolumeclaim/node-data-cassandra-2 \
persistentvolumeclaim/node-data-cassandra-1 \
persistentvolumeclaim/node-data-cassandra-0 \
persistentvolume/pv-n3-log \
persistentvolume/pv-n3-data \
persistentvolume/pv-n2-log \
persistentvolume/pv-n2-data \
persistentvolume/pv-n1-log \
persistentvolume/pv-n1-data \
storageclass.storage.k8s.io/sc-node-log \
storageclass.storage.k8s.io/sc-node-data
echo "----------------------------------------------------------------------------------------------------------------"
echo ""
exit 0