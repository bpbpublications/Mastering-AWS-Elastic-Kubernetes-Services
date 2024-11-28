#gitops
aws codecommit create-repository --repository-name my-gitops-repo
git add .
git commit -m "Define Kubernetes manifests"
git push origin master
aws deploy create-application --application-name my-gitops-app
aws iam create-policy --policy-name my-gitops-policy --policy-document file://iam-policy.json
aws eks update-cluster-config --name my-eks-cluster --logging '{"clusterLogging": [{"types": ["api", "audit", "authenticator", "controllerManager", "scheduler"]}]}' --region us-west-2


#argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl create namespace flux

#crossplane
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm install crossplane crossplane-stable/crossplane --namespace crossplane-system—create-namespace
kubectl get pods -n crossplane-system


#kubevela
helm repo add kubevela https://charts.kubevela.net/core
helm repo update
helm install --create-namespace -n vela-system kubevela kubevela/vela-core --wait

#Observability
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/aws/deploy.yaml
kubectl create namespace monitoring
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/main/bundle.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl get events --all-namespaces
npm install prom-client
kubectl apply -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/main/output/elasticsearch/fluent-bit-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-fluentd-quickstart.yaml
kubectl apply -f https://raw.githubusercontent.com/prometheus/alertmanager/main/doc/example/simple-config/alertmanager.yaml
