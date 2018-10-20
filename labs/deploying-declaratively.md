# Deploying declaratively with the Kubernetes dashboard

The Kubernetes dashboard helps to visualize understand what is happening with your deployments and the cluster itself.

We're going to install it as an example of how we deploy things declaritively in Kubernetes.

!!! warning

    Note: This is not a production quality setup for the dashboard.

    This article from Heptio is essential reading for [securing the Kubernetes dashboard](https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca).

## Step 1. Install it

We’re use the kubectl (Kube Control) CLI tool to install a bunch of objects in the kube-system namespace.

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

By the end of the course, you’ll understand most, if not all of what is in that file!

## Step 2. Kubernetes Dashboard access

Even for our development environment, we don’t want to expose the dashboard publicly, so we have two simple options:

    kubectl proxy

or

    kubectl port-forward

I prefer the port-forward option as when using Docker for Desktop, you access it at localhost:<port> and that’s it.

kubectl proxy might be a good choice if the self-signed cert gives you grief or if you don’t want to do port forwarding.

It’s up to you as we’ll use both.

### Step 2.1 Kubernetes Dashboard with Port Forwarding

The kubectl port-forward command needs the name of the pod, the port on the host machine to forward traffic from and port on the pod to forward traffic too.

Note: The following code presumes the existence of bash so if you’re on Windows, you’ll have to grab the pod name and insert it into the port forward command manually. Sorry. Perhaps it’s time to install the Windows SubShell for Linux?

Grab the name fo the pod

    kube_dashboard_name=$(kubectl get pods --namespace=kube-system | grep kubernetes-dashboard | awk '{print $1}')

Setup the port forwarding

    kubectl port-forward ${kube_dashboard_name} 30000:8443 --namespace=kube-system

Then you can access the dashboard at https://localhost:30000

Want to run the port forwarding in the background with a single command?

From the learn-kubernetes directory.

    make k8s-dashboard-up

To kill the port forwarding process and remove the dashboard.

    make k8s-dashboard-down

### Step 2.2 Kubernetes Dashboard with kubectl proxy

The command is easy to remember, the URL not so much.

    kubectl proxy

Then go to http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview

!!! note

    The kubectl proxy command is great for accessing any service running on your cluster so it’s useful beyond accessing the dashboard.

For example, you could access a service of type ClusterIP during development instead of NodePort or LoadBalancer.

## Step 3. Access the Dashboard

If this is the first time you’ve accessed the dashboard, you’ll be greeted with a setup screen.

We’re going to click *SKIP* as it’s just for our private development purposes.

## Kubernetes Dashboard in Production

Never expose it publicly.

Access should be controlled via a Service token.
https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca#0886

Finally, use it as a read-only dashboard, not as a way to manage your cluster.
