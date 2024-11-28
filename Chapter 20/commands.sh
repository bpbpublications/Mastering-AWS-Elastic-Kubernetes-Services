#Check RTO/RPO for DynamoDB PITR:
aws dynamodb describe-continuous-backups --table-name mytable 
#Test compute instance recovery:
aws ec2 recover-instances --instance-id i-abcd1234
#Restore EBS volume from snapshot:
aws ec2 restore-volume --snapshot-id snap-abcd5678 

#Take RDS DB snapshot: 
aws rds create-db-snapshot 
#List all snapshots for DB:
aws rds describe-db-snapshots
#Restore from DB snapshot:
aws rds restore-db-instance-from-db-snapshot


#FIS
aws iam create-role --role-name my-fis-role --assume-role-policy-document file://permissons/fis-trust-policy.json