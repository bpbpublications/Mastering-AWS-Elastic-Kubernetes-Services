#scaling pods
kubectl run memcached-loader --image=busybox 
kubectl expose deployment memcached-loader --port=11211
kubectl top pods # view metrics


#apply memcached hpa 
kubectl apply -f memcached-hpa.yaml
kubectl get hpa # view current status
kubectl autoscale deployment memcached-loader --cpu-percent=50 --min=1 —max=10


#metrics server
helm install metrics-server stable/metrics-server  
kubectl top pods # view metrics


#vpa
kubectl apply -f my-vpa.yaml
kubectl describe vpa my-app-vpa # view recommendations


#annotate node group
kubectl annotate nodegroup my-nodegroup \  
  cluster-autoscaler.kubernetes.io/scale-down-utilization-threshold=0.5


#deploy CA
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml 

#edit configmap
kubectl edit configmap cluster-autoscaler-status -n kube-system
  awsRegion: us-west-1
  autoDiscovery: 
    clusterName: demo

##Karpenter
# Set cluster requirements
eksctl utils update-cluster-endpoints --region=us-east-1 --name=my-cluster --append-subdomains=karpenter

# Install the Helm chart
helm repo add karpenter https://charts.karpenter.sh
helm install karpenter karpenter/karpenter --create-namespace -n karpenter --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::123456789:role/KarpenterNodeRole 

# Label the nodegroup to opt-in
kubectl label nodegroup ng-1 karpenter.sh/discovery=true
cat <<EOF | kubectl apply -f - 
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata: 
  name: default 
spec: 
  requirements:  
    - key: "node.kubernetes.io/instance-type"
      operator: In
      values: 
        - "t3.medium" 
EOF


##Keda
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace keda --create-namespace
kubectl apply -f https://github.com/kedacore/keda/releases/download/v2.0.0/keda-2.0.0-redis-queue-adapter.yaml 