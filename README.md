# Kubernetes labs

Kubernetes cluster on AWS using Terraform and Kops   

This project was created using many

## Creating the cluster

An domain is required to create the cluster. [Dot TK](http://www.dot.tk) is a domain name registry that provides free domain   
After create your domain, you can create the resources on AWS doing
```bash
$ cd terraform

# initilizer the Terraform
$ terraform init

# Checking the resources will create
$ terraform plan

# Creating
$ terraform apply --auto-approve
```
After cluster creation successfully, get the nameservers doing
```bash
$ terraform output domain-ns
```
Now you need configure this records on your domain configuration page   