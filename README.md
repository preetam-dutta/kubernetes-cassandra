
About
=====
This project demonstrates Apache Cassandra cluster deployment either on development machine or cloud

1. **For Local Development**: On your Docker Desktop setup with Kubernetes enabled
2. **For Cloud Deployment**: On AWS having Kubernetes enabled.

For local it deploys a stateful-set of 3 nodes with Docker volume as **HOSTPATH** and for Cloud(AWS only for now) it leverages **AWS EBS** 

During the deployment all the steps remains same except the definition of **Storage Class** (i.e. the k8/storage-class-local and k8/storage-class-cloud). The Storage Class switches between the local and cloud deployment.

Prerequisite
============

For Local Setup (Docker Desktop)
---------------
1. Docker Desktop with Kubernetes enabled
2. Docker Desktop's VM should have atleast 2 core CPU
3. Docker Desktop's should have atleast 3 GM spare RAM
4. Docker Desktop's volume should have atleast 15GB spare disk capacity


For Cloud Setup (AWS)
---------------------
1. You have Docker and Kubernetes setup on your development machine (i.e. docker and kubectl commands are available on terminal)
1. You already have AWS EC2 up and running
2. Minimum configuration is 4 nodes of T3.small EC2 nodes
3. You have AWS API already setup and configured to run from your terminal


Project Execution
=================

1. Download the project
2. Go to the project home (lets assume its $PRJ_HOME)

For Local Cluster Creation (Docker Desktop)
-------------------------------------------
1. Execute the below command to create the Cassandra cluster on your development machine (laptop/desktop)
    ```bash
    cd $PRJ_HOME/bin
    ./create-casssandra-cluster.sh
    ```
2. Once the above command is completed, the Cluster nodes will be coming up. You can check the status of them via the below command
    ```bash
    kubectl get pod --selector="app=cassandra,env=dev"
    ```
3. Once all the three nodes are up and running, use the below command to check the status or logon to CQLSH
    ```bash
    kubectl exec -it cassandra-0 nodetool status
    kubectl exec -it cassandra-0 cqlsh
    ```

For Local Cluster Deletion (Docker Desktop)
-------------------------------------------
1. When you are done with the Cassandra Cluster, use the below command to destroy the cluster
    ```bash
    cd $PRJ_HOME/bin
    ./delete-cassandra-cluster.sh
    ```

For Cloud(AWS only) Cluster Creation
--------------------------
1. Ensure the kube config is pointing to the AWS (i.e. ~/.kube/config)
2. Execute the below command to create the Cassandra cluster on your development machine (laptop/desktop)
    ```bash
    cd $PRJ_HOME/bin
    ./create-casssandra-cluster.sh -c
    ```
3. Once the above command is completed, the Cluster nodes will be coming up. You can check the status of them via the below command
    ```bash
    kubectl get pod --selector="app=cassandra,env=dev"
    ```
4. Once all the three nodes are up and running, use the below command to check the status or logon to CQLSH
    ```bash
    kubectl exec -it cassandra-0 nodetool status
    kubectl exec -it cassandra-0 cqlsh
    ```

For Cloud(AWS only) Cluster Deletion
--------------------------
1. When you are done with the Cassandra Cluster, use the below command to destroy the cluster
    ```bash
    cd $PRJ_HOME/bin
    ./delete-cassandra-cluster.sh
    ```
