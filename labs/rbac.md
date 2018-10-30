# RBAC

Role-Based Access Control (RBAC) controls access to the Kubernetes API and restricts what objects in what namespaces an authenticated user is authorizd to access.

`RBAC` has been GA in Kubernetes since 1.8 (late 2017) so most Kubernetes clusters have it enabled by default.

# Kubernetes Cluster Roles

Kubernetes comes with a set of default cluster roles:

    kubectl get clusterroles

Let's take a look at the `view` ClusterRole.

    kubectl get clusterrole view -o yaml

## Kubernetes Roles and Role Bindings

Running this will likely not return results because we haven't created any Roles in our `learn-k8s` Namespace:

    kubectl get roles

Let's look in the `kube-system` namespace and inspect the Role and RoleBinding for the Kubernetes dashboard:

    kubectl get roles --namespace=kube-system
    kubectl get role kubernetes-dashboard-minimal -o yaml --namespace=kube-system
    kubectl get rolebindings --namespace=kube-system
    kubectl get rolebinding kubernetes-dashboard-minimal -o yaml --namespace=kube-system

## Restricting a user to a namespace

Let's add a new user that can manage the resources for that namespace.

    kubectl apply -f manifests/rbac-role-pods-view.yaml

Taking a look at `manifests/rbac-role-pods-view.yaml`, we've created three resources:

 - ServiceAccount
 - Role
 - RoleBinding
 
The Role has full access to all resources (including batch objects such as jobs).

Because it is a Role, it can only be applied to a Namespace.

### Retrieve certificate credentials

In creating the ServiceAccount, Kubernetes created a secret that contains the CA and token we need for authentication.

    kubectl describe serviceaccount learn-k8s-user

The name of the secret is in the `Tokens` value.

    SECRET_NAME=$(kubectl get serviceaccount  learn-k8s-user -o "jsonpath={.secrets[0]['name']}")

Now let's get the token:

    kubectl get secret $SECRET_NAME -o "jsonpath={.data.token}"

And CA data:

    kubectl get secret $SECRET_NAME -o "jsonpath={.data['ca\.crt']}"

Now, let's append a user to our Kube config file (`~/.kube/config`), adding another entry to `users`:

    - name: learn-k8s
    user:
        client-key-data: $CA
        token: $TOKEN

Now we can test out the access capabilities of our `learn-k8s` user:

    kubectl get secrets --as=learn-k8s --namespace=kube-system

You should have recieved an error indicating you are not allowed to list secrets from the `kube-system` namespace. The `--as=learn-k8s` is a great option for testing user access.

Now let's change our `learn-k8s` context entry in the Kube config file to use our new `learn-k8s-user` user.

Now if you run:

    kubectl get secrets --namespace=kube-system

You'll get the same error.

!!! note

    If you're ever running commands that need Cluster level access, switch back to the `docker-for-desktop` context by running `kubectl config use-context docker-for-desktop`.
