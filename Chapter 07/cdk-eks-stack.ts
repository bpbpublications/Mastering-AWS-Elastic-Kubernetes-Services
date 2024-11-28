import { Cluster, KubernetesVersion } from "aws-eks";
import { Construct } from "constructs"; 

export class CdkEksStack extends Stack {
  constructor(scope: Construct, id: string) {
    super(scope, id);
    
    new Cluster(this, "EksCluster", {
      version: KubernetesVersion.V1_21 
    });
  }
}
