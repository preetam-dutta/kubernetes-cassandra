
About
-----
Creates a stateful-set of 3 nodes with docker volume as **HOSTPATH** or **AWS EBS**

Only the **Storage class** needs to be changed for hostpath or awsebs, rest of the steps remains same

Create Docker Volume as hostPath mount for Host Path
----------------------------------------------------
**SKIP THIS STEP FOR AWS EBS**

Create the below volumes, and ensure the PersistenVolume has the same as *path* param in *hostPath*

  ```bash
  docker volume create data-cassandra-0
  docker volume create log-cassandra-0
  
  docker volume create data-cassandra-1
  docker volume create log-cassandra-1
  
  docker volume create data-cassandra-2
  docker volume create log-cassandra-2
  ```

Create the storage-class
------------------------
Create set of storage class for data and log

**For HOSTPATH**
  ```bash
  kubectl apply -f hostpath-storage-class.yaml
  ```

**For AWS EBS**
  ```bash
  kubectl apply -f awsebs-storage-class.yaml
  ```

Create Persistent Volume and respective Persistent Volume Claim
------------------------
- Note: the status says *available* and once the PVC is bind, the status changes to *bound*
- Note: the *labels* the *storageClass* and the *labels* have been used to connect PVs to correct PVCs

The PVC is optional step, when deploying the statefulSet kuberentes automatically created PVC.
However to ensure I control the ordering and the mapping of the PVC and the stateful, creating it manually

  ```bash
  kubectl apply -f persistent-volume-0.yaml
  kubectl apply -f persistent-volume-1.yaml
  kubectl apply -f persistent-volume-2.yaml
  ```
  
  ```bash
  kubectl get sc,pv,pvc,all
  ```


Start and verify Pod
--------------------

  ```bash
  kubectl apply -f cassandra-stateful-set.yaml
  ```

  ```bash
  kubectl get sc,pv,pvc,all
  ```


