
About
=====
This project demonstrate Cassandra cluster implementation via Docker and Kubernetes either on
1. **For Local Development**: On your Docker Desktop setup with Kubernetes enabled
2. **For Cloud Deployment**: On AWS having Kubernetes enabled.

Deploys a stateful-set of 3 nodes with docker volume as **HOSTPATH** for local or **AWS EBS** for Cloud (AWS only for now)

With respect to Kubernetes configuration, only the **Storage class** (i.e. the k8/storage-class-local and k8/storage-class-cloud) changes to switch between the local and cloud deployment.

Prerequisite
============

For Local Setup
---------------
1. Docker Desktop with Kubernetes enabled
2. Docker Desktop's VM should have atleast 2 core CPU
3. Docker Desktop's should have atleast 3 GM spare RAM
4. Docker Desktop's volume should have atleast 15GB spare disk capacity


For Cloud Setup
---------------
1. You have Docker and Kubernetes setup on your development machine (i.e. docker and kubectl commands are available on terminal)
1. You already have AWS EC2 up and running
2. Minimum configuration is 4 nodes of T3.small EC2 nodes
3. You have AWS API already setup and configured to run from your terminal


Project Execution
=================

1. Download the project
2. Go to the project home (lets assume its $PRJ_HOME)

For Local Cluster Creation
--------------------------
1. Ensure the kube config is pointing to the Docker Desktop (i.e. ~/.kube/config)
2. Execute the below command to create the Cassandra cluster on your development machine (laptop/desktop)
    ```bash
    cd $PRJ_HOME/bin
    ./create-casssandra-cluster.sh
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

For Local Cluster Deletion
--------------------------
1. When you are done with the Cassandra Cluster, use the below command to destroy the cluster
    ```bash
    cd $PRJ_HOME/bin
    ./delete-cassandra-cluster.sh
    ```

For Cloud(AWS) Cluster Creation
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

For Cloud(AWS) Cluster Deletion
--------------------------
1. When you are done with the Cassandra Cluster, use the below command to destroy the cluster
    ```bash
    cd $PRJ_HOME/bin
    ./delete-cassandra-cluster.sh
    ```
