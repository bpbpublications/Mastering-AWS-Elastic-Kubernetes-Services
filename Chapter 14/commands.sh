#Apply StorageClass manifest with the following command:
kubectl apply -f storageclass_csi.yaml

# Apply StatefulSet manifest with the following command:
kubectl apply -f statefulset_csi.yaml

# Verify deployment with the following command:
kubectl get statefulsets,pods,pvc

# Apply Pod manifest with the following command:
kubectl apply -f efs-pod.yaml

#	Verify deployment with the following command:
kubectl get pods,pvc
