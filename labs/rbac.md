# RBAC

Role-Based Access Control (RBAC) controls access to the Kubernetes API and restricts what objects in what namespaces an authenticated user is authorizd to access.

`RBAC` has been GA in Kubernetes since 1.8 (late 2017) so most Kubernetes clusters have it enabled by default.

In this lab, we are going to create a new user that is restricted to accessing the `learn-k8s` Namespace and can only manage Deployments.

The use-case here is that the user (or deploy server) should not have the ability to modify environment configuration objects such as Services, ConfigMaps and Secrets. Those objects to be managed by a DevOps Engineer or SRE.

## Get set up

 - Create a directory named `.kubecerts` in your home directory.
 - Ensure you have `openssl` installed.

## Creating a new user

Kubernetes does not an API for managing Users but there are [many ways Kubernetes can authenticate a user](https://kubernetes.io/docs/admin/authentication). For this lab, we will be using client certificates.

## Step 1. Create the client key and signing request

We will create a new user with username `learn-k8s` in the `learn-k8s` group.

Change into the `~/.kubecerts/` directory, then generate the key:

    openssl genrsa -out learn-k8s.key 2048

Now create a certificate signing request (CSR) using this private key. The `CN` key is for the user name and `O` is for the user's group:

    openssl req -new -key learn-k8s.key -out learn-k8s.csr -subj "/CN=learn-k8s/O=learn-k8s"

## Step 2. Download the cluster CA certificate and key

The cluster's Certificate Authority (CA) is required for signing your CSR and generating the client certificates required for accessing the cluster.

To do this, you will need the CA certificate and key for your cluster.

!!! note

    Because this is a development environment and we're doing this for learning purposes, we will save the CA certificate and key from our cluster locally to make things easier.

### Docker for Desktop

The cluster certificates are in `/run/config/pki`. 

Get the certificate contents and save it to `~/.kubecerts` as `ca.crt`:

    make docker-vm-shell DOCKER_VM_CMD="cat /run/config/pki/ca.crt"

Get the key contents and save it to `~/.kubecerts` as `ca.key`:

    make docker-vm-shell DOCKER_VM_CMD="cat /run/config/pki/ca.key

### Minikube

From the `minikube` directory, download the `ca.crt` and `ca.key` to the `~/.kubecerts` directory.

## Step 3. Sign the CSR using the cluster Certificate Authority (CA)

Now that we have downloaded the CA cert and key from the cluster, we can create the final certificate to give us access to the cluster:

    openssl x509 -req -in ~/.kubecerts/learn-k8s.csr -CA ~/.kubecerts/ca.crt -CAkey ~/.kubecerts/ca.key -CAcreateserial -out ~/.kubecerts/learn-k8s.crt -days 500

## Step 4. Add a new context using the learn-k8s user

Add the learn-k8s user to your kubectl config (you need to provide the absolute path to your home directory):

    kubectl config set-credentials learn-k8s --client-certificate=/home/path/.kubecerts/learn-k8s.crt  --client-key=/home/path/.kubecerts/learn-k8s.key

Now create the context using either `minikube` or `docker-for-desktop-cluster` as the $CLUSTER_NAME:

    kubectl config set-context learn-k8s-deployer --cluster=$CLUSTER_NAME --namespace=learn-k8s --user=learn-k8s

Now try to get a list of Pods using this context:

    kubectl --context=learn-k8s-deployer get pods

This fails because we haven't **bound** this ser to a Role.

## Step 5. Provide access to our learn-k8s user

Create the Role:

    kubectl apply -f manifests/rbac-role.yaml

Then create the RoleBinding:

    kubectl apply -f manifests/rbac-rolebinding.yaml

## Step 6. Check our access

Now let's try to list the Pods and Deployments using our new context:

    kubectl --context=learn-k8s-deployer get pods
    kubectl --context=learn-k8s-deployer get deployments.apps

What about secrets?

    kubectl --context=learn-k8s-deployer get secrets

Just as we expected, we do not have access to Secrets.

## Step 7. Clean-up

Delete the `~/.kubecerts` folder.

Remove the learn-k8s user:

    kubectl config unset users.learn-k8s

Remove the context:

    kubectl config unset contexts.learn-k8s-deployer
