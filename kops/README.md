# Kops Cluster

## Creating the cluster
The first thing to do is configure the resources created by the Terraform into kops cluster definition (kops-cluster.yaml)   
After configurations changed, the next step is to generate the cluster definition:
```bash
# export the AWS credentials of the kops user created early
$ export AWS_ACCESS_KEY_ID={}
$ export AWS_SECRET_ACCESS_KEY={}
# export the s3 bucket that kops will store the cluster configurations
$ export KOPS_STATE_STORE='s3://kops-k8s'
$ export CLUSTER_NAME='cluster.k8slabs.tk'

# generation of the cluster definition
$ kops create \
  -f 'kops-cluster.yaml' \
  -f 'kops-ig-bastion.yaml' \
  -f 'kops-ig-master.yaml' \
  -f 'kops-ig-nodes.yaml'
```
You also need to create SSH Keys, that will be used to access the instances if necessary:
```bash
$ ssh-keygen -t rsa -f "${CLUSTER_NAME}_rsa" -C ""
# store the ssh keys with the cluster config
$ kops create secret \
    --name "${CLUSTER_NAME}" sshpublickey admin -i "${CLUSTER_NAME}_rsa.pub"
```
Now the configuration already stored in S3, we can create the cluster
```bash
# Check the resources that the kops will create
$ kops update cluster "${CLUSTER_NAME}"
# Apply the changes
$ kops update cluster "${CLUSTER_NAME}" --yes
```
After the cluster was created, we need check dns propagation status:
```bash
$ dig "api.${CLUSTER_NAME}" @8.8.8.8
```
If it is accessible, check the cluster status
```bash
$ kops validate cluster
```

## Accessing and Checking the cluster state

To access the cluster we need export the kubeconfig file:
```bash
$ export KUBECONFIG=./"${CLUSTER_NAME}.conf"
$ kops export kubecfg --name "${CLUSTER_NAME}"
```
Checking if the containers on kube-system namespaces are running
```bash
$ kubectl get pods --all-namespaces
# The output should be something like this:
NAMESPACE     NAME                                                                  READY   STATUS    RESTARTS   AGE
kube-system   dns-controller-796fddd59-hvg76                                        1/1     Running   0          9m36s
kube-system   etcd-manager-events-ip-10-110-12-182.us-east-2.compute.internal       1/1     Running   0          9m59s
kube-system   etcd-manager-main-ip-10-110-12-182.us-east-2.compute.internal         1/1     Running   0          8m57s
kube-system   kops-controller-hwmnn                                                 1/1     Running   0          9m21s
kube-system   kube-apiserver-ip-10-110-12-182.us-east-2.compute.internal            1/1     Running   2          8m56s
kube-system   kube-controller-manager-ip-10-110-12-182.us-east-2.compute.internal   1/1     Running   0          9m50s
kube-system   kube-dns-autoscaler-594dcb44b5-pfc9g                                  1/1     Running   0          9m40s
kube-system   kube-dns-b84c667f4-hh7zf                                              3/3     Running   0          6m21s
kube-system   kube-dns-b84c667f4-t52xm                                              3/3     Running   0          9m40s
kube-system   kube-proxy-ip-10-110-12-182.us-east-2.compute.internal                1/1     Running   0          9m14s
kube-system   kube-proxy-ip-10-110-47-203.us-east-2.compute.internal                1/1     Running   0          7m32s
kube-system   kube-scheduler-ip-10-110-12-182.us-east-2.compute.internal            1/1     Running   0          9m30s
kube-system   weave-net-6mlbl                                                       2/2     Running   0          8m17s
kube-system   weave-net-vmpq2                                                       2/2     Running   0          9m36s
```
Checking the nodes status
```bash
$ kubectl get nodes
# The output should be something like this:
NAME                                          STATUS   ROLES    AGE     VERSION
ip-10-110-12-182.us-east-2.compute.internal   Ready    master   11m     v1.16.8
ip-10-110-47-203.us-east-2.compute.internal   Ready    node     9m32s   v1.16.8
```

## Deleting cluster

```bash
kops delete cluster --name "${CLUSTER_NAME}" --yes
```