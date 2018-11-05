# Minikube on AWS

This Terraform plan installs Minikube in Ubuntu on AWS.

## Why?

This is for educational purposes. During Kubernetes training courses, some students have issues with Docker for Desktop and Minikube on their local machines. This is to give them an easy solution.

## WARNING!

Running Minikube with `--vm-driver=none` is not recommended for cloud virtual machines and could pose security risks. It is recommended that you set the `ingress_cidr` variable in Terraform to your local IP address/corporate range to limit access to the instance.

## Requirements

- [Install Terraform](https://www.terraform.io/intro/getting-started/install.html).
- [Create an IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) user and attach the  `EC2FullAccess` (although this could be reduced even further).
- [Create an EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair) called `minikube`, then download it to the `minikube-aws` directory, giving it read only permissions (`chmod 400 minikube.pem`).

## Step 1. Configuration

- Add your IAM credentials to `.aws/credentials`
- Make a copy of the `terraform.tfvars.sample` file, re-naming it to `terraform.tfvars`
- Add values to the `terraform.tfvars` file. There are more variables you can define, just look in `vars.tf`

## Step 2. Create your Minikube instance

Download the required Terraform resources:
    make init

Confirm what we're going to create:

    make plan

Create the resources:

    make apply

The `make apply` step will output the public IP. To get this again run:

    make output

## Step 3. Access your Minikube instance

Presuming you download your EC2 key pair to the `minikube-aws` directory and called it `minikube`, run:

    ssh ubuntu@$PUBLIC_IP -i minikube.pem

Depending upon how quickly you accessed your instance after it was created, it may still be installing Minikube.

To check on the progress of the installation script (`resources/user-data.sh`), on the instance, run:

    tail -f /var/log/cloud-init-output.log 

## Step 4. Check it's working

Cluster verification:

    kubectl cluster-info
    kubectl get nodes

Change into the `learn-kubernetes` directory that and create a Deployment and a Service:

    kubectl apply -f manifests/deployment.yaml
    kubectl apply -f manifests/service.yaml

Then get one of the NodePorts created for the Service:

    kubectl get service kuard

And try to access the service:

    http://$PUBLIC_IP:$NODE_PORT

## Step 5. Terminate

Once you're done, terminate the instance:

    make destroy
