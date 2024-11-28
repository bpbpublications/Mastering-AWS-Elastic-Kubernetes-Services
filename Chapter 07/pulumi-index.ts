import * as awsx from "@pulumi/awsx";
import * as eks from "@pulumi/eks";
   
const cluster = new eks.Cluster("my-cluster", {
     vpcId: awsx.ec2.Vpc.getDefault().id,
     desiredCapacity: 2,
     minSize: 1,
     maxSize: 2,        
});
