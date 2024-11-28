##Kubecost
aws eks create-addon --addon-name kubecost_kubecost --cluster-name $YOUR_CLUSTER_NAME --region $AWS_REGION
kubectl get deployment -n kubecost
kubectl get service -n kubecost kubecost-cost-analyzer \
    -o jsonpath="{.status.loadBalancer.ingress[*].hostname}:9090{'\n'}"
