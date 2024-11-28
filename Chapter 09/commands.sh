#deploy namespace
kubectl apply -f namespace.yaml

#deploy pod
kubectl apply -f pod.yaml
kubectl get pods -n demo


#deploy service
kubectl apply -f service.yaml

#deploy ingress
kubectl apply -f ingress.yaml

#helm install nginx
helm install my-nginx nginx \
  --set=replicaCount=3 \
  —set=resources.limits.cpu=200m


