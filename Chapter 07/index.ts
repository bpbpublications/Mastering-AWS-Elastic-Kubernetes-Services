import { App } from "aws-cdk-lib";
import { CdkEksStack } from "./cdk-eks-stack";

const app = new App();
new CdkEksStack(app, "eks-stack");
app.synth();
