#Eks cluster config
aws eks --region us-west-1 update-kubeconfig --name my-cluster

#Kubectl commands
kubectl get nodes
kubectl describe deployments
kubectl logs pod/my-app


#upgrade cluster with eksctl
eksctl upgrade cluster --name my-cluster --kubernetes-version 1.29

