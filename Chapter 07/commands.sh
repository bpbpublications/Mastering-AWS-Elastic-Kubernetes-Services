#Get eksctl binary
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
sudo chmod +x /usr/local/bin/eksctl


#Create EKS cluster
eksctl create cluster -f clusterconfig.yaml


# view worker nodes
kubectl get nodes 

#Get nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
. ~/.nvm/nvm.sh
nvm install --lts
node -v 
npm -v


#install cdk
npm install -g aws-cdk
cdk --version


#boostrap cdk
cdk bootstrap  -c cloudformationExecutionPolicies=arn:aws:iam::aws:policy/AdministratorAccess
mkdir cdk-eks-demo
cd cdk-eks-demo
npm init -y
npm install aws-cdk aws-eks


#deploy cdk
cdk deploy


#Get Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update  
sudo apt install terraform
terraform -v


#TF execution
terraform init
terraform plan
terraform apply


#pulumi  
pulumi login 
pulumi new aws-typescript -s dev
npm install @pulumi/kubernetes @pulumi/aws @pulumi/eks