#genai cluster
eksctl create cluster \
  --name genai-eks \
  --version 1.28 \
  --nodegroup-name nodegroup-genai \
  --node-type m5.xlarge \
  --nodes 3 \
  --nodes-min 3 \
  --nodes-max 6 \
  --region us-west-2
aws eks update-kubeconfig --name <cluster-name> --region <region>
eksctl create nodegroup -n gpu-ng -t g5.12xlarge --nodes 1 --enable-ssm --managed --cluster genai-eks
NODE_NAME=`kubectl get nodes --show-labels |grep -i  g5type | awk '{print $1}'`
kubectl taint node $NODE_NAME nvidia.com/gpu:NoSchedule
helm repo add nvdp-helm https://nvidia.github.io/k8s-device-plugin
helm upgrade -i nvdp-helm nvdp/nvidia-device-plugin --namespace nvidia-device-plugin --create-namespace --version 0.14.1
eksctl utils associate-iam-oidc-provider --region us-west-2 --cluster genai-eks --approve
eksctl create iamserviceaccount --name ebs-csi-controller-sa --namespace kube-system --cluster genai-eks --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --approve --role-only --role-name AmazonEKS_EBS_CSI_DriverRole
eksctl create addon --name aws-ebs-csi-driver --cluster genai-eks --service-account-role-arn arn:aws:iam::{AWS_ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole --force

eksctl create iamserviceaccount --cluster genai-eks --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy --approve
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=genai-eks --set serviceAccount.create=false  --set serviceAccount.name=aws-load-balancer-controller
# Add the Helm repo
helm repo add kuberay https://ray-project.github.io/kuberay-helm/
helm repo update
# Confirm the repo exists
helm search repo kuberay --devel
# Install both CRDs and KubeRay operator v0.6.0.
helm install kuberay-operator kuberay/kuberay-operator --version 1.0.0-rc.0
helm upgrade --cleanup-on-fail --install jupyterhub jupyterhub/jupyterhub --namespace jupyterhub --create-namespace --version=3.1.0 --values values.yaml


kubectl apply -f https://raw.githubusercontent.com/helm/charts/master/stable/prometheus-operator/crds/crd-servicemonitor.yaml 
helm repo add gpu-helm-charts https://nvidia.github.io/gpu-monitoring-tools/helm-charts
helm repo update
helm install --generate-name gpu-helm-charts/dcgm-exporter
kubectl apply -f adot-daemonset.yaml