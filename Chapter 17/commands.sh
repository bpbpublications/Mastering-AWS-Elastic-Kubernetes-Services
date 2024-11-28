##lambda
aws lambda create-function --function-name <your-function-name> --runtime python3.11 --handler <your-handler> --zip-file fileb://<path-to-zip-file> --role <your-iam-role-arn>
aws lambda get-function --function-name <your-function-name> --query 'Configuration.FunctionArn'

#rds
eksctl create cluster --name <your-cluster-name> --region <your-region>
aws eks --region <your-region> update-kubeconfig --name <your-cluster-name>
aws rds describe-db-instances --db-instance-identifier <your-db-instance-id> --query 'DBInstances[0].[Endpoint.Address,MasterUsername,MasterUserPassword]' --output text
kubectl create secret generic rds-credentials --from-literal=username=<your-username> --from-literal=password=<your-password> --from-literal=host=<your-rds-endpoint>
kubectl get secrets rds-credentials


#scale
kubectl scale deployment your-app --replicas=5
kubectl logs -l app=your-app
aws rds modify-db-instance --db-instance-identifier <your-db-instance-id> --backup-retention-period 7 --apply-immediately
aws rds create-db-snapshot --db-instance-identifier <your-db-instance-id> --db-snapshot-identifier <your-snapshot-id>


#security
aws eks update-kubeconfig --name <your-cluster-name> --region <your-region>
eksctl create vpc-peering --vpc-id <your-eks-vpc-id> --peer-vpc-id <your-rds-vpc-id> --name <your-peering-connection-name>
aws ec2 authorize-security-group-ingress --group-id <your-eks-security-group> --protocol tcp --port 3306 --source <your-rds-security-group>
aws ec2 authorize-security-group-ingress --group-id <your-rds-security-group> --protocol tcp --port 3306 --source <your-eks-security-group>

#optimization
aws rds modify-db-parameter-group --db-parameter-group-name <your-parameter-group-name> --parameters "name=parameter_name,value=new_value,method=immediate" —apply-immediately
aws cloudwatch get-metric-statistics --namespace AWS/RDS --metric-name <your-metric-name> --start-time <start-time> --end-time <end-time> --period <period> --statistics <statistics> --dimensions Name=DBInstanceIdentifier,Value=<your-db-instance-id>


#ecs integration
eksctl create cluster --name <your-eks-cluster> --region <your-region>
aws eks --region <your-region> update-kubeconfig --name <your-eks-cluster>
aws ecs create-cluster --cluster-name <your-ecs-cluster>

#cloudwatch
aws eks --region <your-region> update-cluster-config --name <your-cluster-name> --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
kubectl get configmap cluster-info -o jsonpath='{.data.cluster\.yaml}' -n kube-system
wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
unzip AmazonCloudWatchAgent.zip
sudo ./install.sh  
sudo nano /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
aws cloudwatch put-metric-data --namespace <your-namespace> --metric-name <your-metric-name> --value <your-metric-value>
aws cloudwatch put-metric-alarm --alarm-name <your-alarm-name> --metric-name <your-metric-name> --namespace <your-namespace> --statistic <your-statistic> --period <your-period> --threshold <your-threshold> --comparison-operator <your-comparison-operator> --evaluation-periods <your-evaluation-periods> --actions-enabled --alarm-actions <your-SNS-topic-arn>
aws cloudwatch put-metric-data --namespace KubernetesClusterAutoscaler --metric-name nodes --value <your-metric-value>
aws cloudwatch put-dashboard --dashboard-name <your-dashboard-name> --dashboard-body file://eks-dashboard.json
aws autoscaling put-scaling-policy --policy-name <your-policy-name> --auto-scaling-group-name <your-auto-scaling-group> --scaling-adjustment <your-scaling-adjustment> --adjustment-type <your-adjustment-type> --cooldown <your-cooldown>
aws autoscaling describe-scaling-activities --auto-scaling-group-name <your-auto-scaling-group>

#dynamodb
aws iam create-role --role-name eks-dynamodb-role --assume-role-policy-section file://trust-policy.json   
aws iam attach-role-policy --role-name eks-dynamodb-role --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess   
eksctl create iamserviceaccount --region <your-region> --name dynamodb-sa --namespace <your-namespace> --cluster <your-cluster-name> --attach-policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess --approve
aws dax create-cluster --cluster-name <your-dax-cluster> --node-type <your-node-type> --replication-factor <your-replication-factor>