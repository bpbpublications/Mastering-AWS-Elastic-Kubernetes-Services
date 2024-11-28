#code commit repo
aws codecommit create-repository --repository-name <your-repo-name>
#clone
git clone https://git-codecommit.<your-region>.amazonaws.com/v1/repos/<your-repo-name>
aws codebuild create-project --name <your-project-name> --source "type=NO_SOURCE" --artifacts "type=NO_ARTIFACTS" --environment "type=LINUX_CONTAINER,computeType=BUILD_GENERAL1_SMALL" --service-role <your-service-role-arn> --buildspec buildspec.yml
aws codebuild start-build --project-name <your-project-name>

#blue green deployment
aws deploy create-deployment-config --deployment-config-name eks-bluegreen 
aws deploy create-application --application-name eks-bluegreen
aws deploy create-deployment-group --application-name eks-bluegreen --deployment-group-name eks-blue-group --deployment-config-name eks-bluegreen --service-role-arn <your-service-role-arn> --blue-green-deployment-config terminateBlueInstances
aws deploy create-deployment --application-name eks-bluegreen --deployment-group-name eks-blue-group --revision revisionType=GitHub,repository=https://github.com/<your-repo>,commitId=<your-commit-id>

#canary deployment
aws deploy create-deployment-config --deployment-config-name eks-canary
aws deploy create-deployment-group --application-name eks-canary --deployment-group-name eks-canary-group --deployment-config-name eks-canary --service-role-arn <your-service-role-arn> --deployment-style deploymentType=BLUE_GREEN,deploymentOption=WITH_TRAFFIC_CONTROL
aws deploy create-deployment --application-name eks-canary --deployment-group-name eks-canary-group --revision revisionType=GitHub,repository=https://github.com/<your-repo>,commitId=<your-commit-id>


#CloudWatch
aws cloudwatch put-metric-alarm --alarm-name <your-cpu-alarm-name> --metric-name CPUUtilization --namespace AWS/EKS --statistic Average --period 300 --threshold <your-threshold> --comparison-operator GreaterThanThreshold --dimensions Name=ClusterName,Value=<your-cluster-name> --evaluation-periods 2 --alarm-actions <your-SNS-topic-arn>
aws cloudwatch put-metric-data --namespace <your-namespace> --metric-name <your-metric-name> --value <your-metric-value> --dimensions Name=ClusterName,Value=<your-cluster-name>
aws cloudwatch put-dashboard --dashboard-name <your-dashboard-name> --dashboard-body file://eks-dashboard.json

#IAM role
aws iam create-role --role-name <your-codebuild-role-name> --assume-role-policy-section file://trust-policy-codebuild.json
aws iam attach-role-policy --role-name <your-codebuild-role-name> --policy-arn arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess
aws iam create-role --role-name <your-eks-role-name> --assume-role-policy-section file://trust-policy-eks.json
aws iam attach-role-policy --role-name <your-eks-role-name> --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy

#EKS and IAM
aws eks update-cluster-config --name <your-cluster-name> --region <your-region> --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'
eksctl create iamserviceaccount --region <your-region> --name <your-service-account-name> --namespace <your-namespace> --cluster <your-cluster-name> --attach-policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy --approve
kubectl apply -f rbac-policy.yaml
