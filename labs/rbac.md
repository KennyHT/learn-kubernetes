# RBAC

Role-Based Access Control controls access to the Kubernetes API and restricts what objects in what namespaces an authenticated user is authorizd to access.

`RBAC` has been GA in Kubernetes since 1.8 (late 2017) so most Kubernetes installs now enable it out of the box which is great!
 
RBAC is a big topic and let's start off bu looking at the three A's - Authorization, Access, and Auditing.

!!! note

    Authentication and Authorization is a HUGE topic and we can't hope to cover it all in one lab.
    
    What we do want to do, is deviate from the defaults that are setup to expose you to the options that you have.
    
    This is because when it comes time to access Kubernetes clusters in live environments, your `.kube/config` file for `kubectl` won't be setup for you.
    
## Authorization

**Purpose:** Is `kubectl` able to make a request?

Using `Docker for Desktop` as an example, let's take a look at our `kubectl` config file at `$HOME/.kube/config`.

Taking a look under the `users` key, we can see that a user called `docker-for-desktop` using [X509 Client Certs](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#x509-client-certs) as the authentication method.

This is not the only game in town, with Tokens and Authentication proxies being others ([more info here](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)).

## Step 1. Backup your current config

Copy and paste your current `$HOME/.kube/config` file as `$HOME/.kube/config.bak` in case you break something.

!!! note

    If you happen to completely break your `kubectl` configuration and did not take a back-up, Docker for Desktop has you covered.
    
    Just reset your Kubernentes cluster back to its original settings by going to Docker > Preferences/Settings > Reset and click the `Reset Kubernetes cluster` button.
    
    This will also reset your `$HOME/.kube/config, restoring your original certificate authenication config in the process.

## Step 2. Get the token from the `default-token` secret.

Let's get a service account token by using `kubectl` to access the `.data.token` value of the `default-token` key.

    # Extract just the token name
    DEFAULT_TOKEN_NAME=$(kubectl get secrets --namespace=kube-system | grep default-token | awk '{print $1}')
    
    # Get the default token value from the secret and base64 decode it
    # Note: `KUBE_AUTH_TOKEN` is our name and does not mean anything to `kubectl`.
    KUBE_AUTH_TOKEN=$(kubectl get secret --namespace=kube-system ${DEFAULT_TOKEN_NAME} --template='{{.data.token}}' | base64 -D)
    
Now it's time to experiment with our token and talking to the API server.

## Experiment 1. Authentication via the `--token` flag

We have the option of overriding the default user for our current context by using the `--token` flag.

First, let's observe authentication failing if we pass in an invalid token.

    kubectl get nodes --token=123

You should've gotten an error like `error: You must be logged in to the server (Unauthorized).`.

Now let's try it out using our legit token.

    kubectl get nodes --token=${KUBE_AUTH_TOKEN}

Success!

## Experiment 2. Hit the Kubernetes API directly (no kubectl)

Let's hit the `/version` and `/metrics`endpoints for the API Server using our token.

We need to know the API server endpoint which we can get from our `$HOME/.kube/config` and the `clusters > cluster > server` value.

!!! note

    We'll be using the `--insecure` flag because the SSL certificate installed is a self-signed certificate.

First, let's make sure it fails without the token.

    curl --insecure -H "Authorization: Bearer ABC123" https://localhost:6443/version
    
And now with the token.

    # Version
    curl --insecure -H "Authorization: Bearer ${KUBE_AUTH_TOKEN}" https://localhost:6443/version
    
    # Metrics
    curl --insecure -H "Authorization: Bearer ${KUBE_AUTH_TOKEN}" https://localhost:6443/metrics

## Experiment 3. Let's create a new user for our `kubectl` config.

Now let's create a new user called `jack-sparrow` and we'll make him belong to a new context .

    kubectl config set-credentials jack-sparrow --token=${DEFAULT_TOKEN}

If we want to use our current context but override the current user (`docker-for-desktop`), then we can pass `kubectl` the `--user` flag.

    # Fail with non-existent user
    kubectl get nodes --user black-beard
    
    # Success with jack
    kubectl get nodes --user jack-sparrow

We can go one step further and create a new context called `pirate` that will target the `docker-for-desktop` node, but using our `jack-sparrow` user and the `learn-k8s` namespace.

    kubectl config set-context pirate -cluster=docker-for-desktop-cluster --user=docker-for-desktop --namespace=learn-k8s

### Access

Does the authenticated user have the permissions required to access and perform the required task against the reqeusted resource?

TODO CONTENT.

### Auditing

Record an audit trail of who did what.

TODO CONTENT.

## Roles and Cluster Roles

## Binding Roles to Users and Groups
