##upgrade
aws eks update-cluster-config --name <cluster-name> --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'


#Cluster events
aws eks describe-cluster --name <cluster-name> --region <region> --query cluster.events
aws logs describe-log-groups --log-group-prefix /aws/eks/<cluster-name>/worker

#auth
kubectl get clusterroles
kubectl get clusterrolebindings
kubectl describe clusterrole <clusterrole-name>
kubectl describe clusterrolebinding <clusterrolebinding-name>


#control plane logging
aws eks update-cluster-config --name <cluster-name> --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
aws logs describe-log-groups --log-group-prefix /aws/eks/<cluster-name>/
