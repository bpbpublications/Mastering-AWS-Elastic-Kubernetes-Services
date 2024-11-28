##pod networking
#Enable support in the EKS cluster if not already done, as shown:
eksctl utils update-cluster-endpoints --name mycluster --region us-west-2 --vpc-private-access —wait

#Create a security group with required ingress/egress rules, as shown:
aws ec2 create-security-group --group-name my-pod-sg --description "Security group for pods"
aws ec2 authorize-security-group-ingress --group-name my-pod-sg --protocol tcp --port 8080 --cidr 0.0.0.0/0

# Annotate the pod spec to reference the security group, as shown:
spec:
  securityGroups:
    - name: my-pod-sg


##Network policies
# Check that network policy support exists in the EKS cluster, as shown:
eksctl utils describe-cluster --name demo --region us-east-1 | grep -i cni

# Label namespaces and pods that will be governed by the network policy. Labels are used for rule selection. For example, let us use the following labels:
kubectl label ns myapp app=foo
kubectl label pod myapp-pod app=foo


# Apply the network policy, as shown:
kubectl apply -f network-policy.yaml


##Custom networking
# Create a custom security group for pods, as shown:
aws ec2 create-security-group \
   --group-name sg-eks-pods \
   --description "Security group for EKS pods”

# Define a custom subnet in your VPC for secondary IP allocation, as shown:
aws ec2 create-subnet \
   --vpc-id vpc-abcd12345 \ 
   --cidr-block 10.7.0.0/20 \
   --availability-zone us-east-1a

# Apply the ENIConfig resource with the following:
kubectl apply -f eniconfig.yaml


##prefix delegation
# Install latest version > 1.9.0 
yum install -y amazon-vpc-cni-k8s

# Edit CNI config file with the following command:
vi /etc/cni/net.d/10-aws.conflist

# Enable prefix delegation, as shown:
{
  "cniVersion": "1.0.0",
  "enable_prefix_delegation": true,
  "warm_prefix_target": 5
}

# Set warm pool prefix target 
systemctl restart aws-vpc-cni

# Confirm if the VPC CNI is configured to run in prefix mode.
kubectl get ds aws-node -o yaml -n kube-system | yq '.spec.template.spec.containers[].env'


##vpc lattice
eksctl utils install-gatewayapi-controller

# Link the Gateway to a Kubernetes service with the following command:
kubectl expose deployment my-app --port=80 —name=my-service
