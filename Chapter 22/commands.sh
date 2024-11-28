#spark
eksctl create cluster \
  --name my-spark-cluster \
  --version 1.28 \
  --nodegroup-name spark-workers \
  --node-type m5.xlarge \
  --nodes 3 \
  --nodes-min 3 \
  --nodes-max 6 \
  --region us-west-2
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/spark-on-k8s-operator/master/manifest/spark-operator.yaml
kubectl apply -f spark-app.yaml
kubectl logs spark-pi-driver -f
kubectl port-forward spark-pi-driver 4040:4040


#jupyter
eksctl create cluster \
  --name my-jupyter—cluster \
  --version 1.28 \
  --nodegroup-name jupyter-node-group \
  --node-type m5.xlarge \
  --nodes 3 \
  --nodes-min 3 \
  --nodes-max 6 \
  --region us-west-2
aws eks update-kubeconfig --name my-jupyter-cluster --region us-west-2

#superset
eksctl create cluster \
  --name my-superset-cluster \
  --version 1.28 \
  --nodegroup-name superset-ng \
  --node-type m5.xlarge \
  --nodes 3 \
  --nodes-min 3 \
  --nodes-max 6 \
  --region us-west-2
kubectl create namespace superset
kubectl apply -f superset.yaml -n superset
kubectl apply -f superset-service.yaml -n superset

