---
layout: default
---

## Sock Shop Microservices Deployment on Kubernetes (*AWS EKS*) Using Terraform (*IaaC*)

### Project Objective
This project is carried out in fulfillment of AltSchool of Cloud Engineering Tinyuka 2023 Capstone Project

#### Project Overview
A microservices-based architecture application is deployed on Kubernetes and there’s a need to create a clear IaaC (Infrastructure as Code) deployment to be able to deploy the services in a fast manner.

**Resources**
The microservices app to be deployed and the deployment files are located in the links below...
* Socks Shop Microservices Demo [Github Repo](https://github.com/microservices-demo/microservices-demo.github.io)
* App Deployment Repo [Github Repo](https://github.com/microservices-demo/microservices-demo/tree/master)

**Task Instructions**
* All deliverables need to be deployed using an Infrastructure as Code approach.
* In your solution please emphasize readability and maintainability (make yor application deployment clear)
* We expect a clear way to recreate your setup and will evaluate the project decisions based on:
    - Deploy pipeline
    - Metrics (Alertmanager)
    - Monitoring (Grafana)
    - Logging (Prometheus)
* Use Prometheus as a monitoring tool
* Use Ansible or Terraform as the configuration management tool.
* You can use an IaaS provider of your choice.
* The application should run on Kubernetes


## MY SOLUTION
### Preamble
The SockShop Microservices app is an invention of a company called WeaveWorks to demostrate the microservices architecture paradigm and forster the cloud-native aganda of CNCF (Cloud Native Computing Foundation); a non-profit organization that aims to promote and develop cloud-native technologies, including Kubernetes, Prometheus, and others.

### Pre-requisites
* AWS CLI
* Docker
* Terraform
* [Minikube](https://github.com/kubernetes/minikube)
* [kubectl](http://kubernetes.io/docs/user-guide/prereqs/)
* Helm
* Github Actions
* Jenkins/ArgoCD

To align with the theme of readability and maintainabilty advised on this project, I packaged the pre-requisite installations for this project in a batch script as seen below. This script is also availbale in this repository.









### Clone the microservices-demo repo 

```
git clone https://github.com/microservices-demo/microservices-demo
cd microservices-demo
```

### Start Minikube

You can start Minikube by running:

```
minikube start --memory 8192 --cpus 4
```

Check if it's running with `minikube status`, and make sure the Kubernetes dashboard is running on http://192.168.99.100:30000.

Approximately 4 GB of RAM is required to run all the services.

##### *(Optional)* Run with Fluentd + ELK based logging

If you want to run the application using a more advanced logging setup based on Fluentd + ELK stack, there are 2 requirements:
* assign at least 6 GB of memory to the minikube VM
* increase vm.max_map_count to 262144 or higher (Required because Elasticsearch will not start if it detects a value lower than 262144).

```
minikube delete
minikube config set memory 6144
minikube start
minikube ssh
```

Once logged into the VM:

```
$ sudo sysctl -w vm.max_map_count=262144
```

After these settings are done you can start the logging manifests.

```
kubectl create -f deploy/kubernetes/manifests-logging
```

You should be able to see the Kibana dashboard at http://192.168.99.100:31601.

### Deploy Sock Shop

Deploy the Sock Shop application on Minikube

```
kubectl create -f deploy/kubernetes/manifests/sock-shop-ns.yaml -f deploy/kubernetes/manifests
```

To start Opentracing run the following command after deploying the sock shop
```
kubectl apply -f deploy/kubernetes/manifests-zipkin/zipkin-ns.yaml -f deploy/kubernetes/manifests-zipkin
```

Wait for all the Sock Shop services to start:

```
kubectl get pods --namespace="sock-shop"
```

### Check the Sock Shop webpage

Once the application is deployed, navigate to http://192.168.99.100:30001 to see the Sock Shop home page.

### Opentracing

Zipkin is part of the deployment and has been written into some of the services.  While the system is up you can view the traces in
Zipkin at http://192.168.99.100:30002.  Currently orders provide the most comprehensive traces, but this requires a user to place an order.

### Run tests

There is a separate load-test available to simulate user traffic to the application. For more information see [Load Test](#loadtest).
This will send some traffic to the application, which will form the connection graph that you can view in Scope or Weave Cloud. You should
also check what ip your minikube instance has been assigned and use that in the load test.

```
minikube ip
docker run --rm weaveworksdemos/load-test -d 5 -h 192.168.99.100:30001 -c 2 -r 100
```

### Uninstall the Sock Shop application

```
kubectl delete -f deploy/kubernetes/manifests/sock-shop-ns.yaml -f deploy/kubernetes/manifests
```

If you don't need the Minikube instance anymore you can delete it by running:

```
minikube delete
```
