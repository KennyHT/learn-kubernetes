# Deploying declaratively with the Kubernetes dashboard

The Kubernetes dashboard helps to visualize and understand what is happening with your deployments and the cluster itself.

We're going to install it as an example deploying declaratively in Kubernetes.

!!! warning

    The instructions below are suitable for a **local development environment only**!

    This article from Heptio is essential reading for [securing the Kubernetes dashboard](https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca).

## Step 1. Install it

Let's use the `kubectl` (Kube Control) CLI tool to install a the required objects for the dashboard.

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

By the end of the training, you will understand this entire file.

## Step 2. Kubernetes dashboard access

Even for our development environment, we don’t want to expose the dashboard publicly, so we have two simple options:

    kubectl proxy

or

    kubectl port-forward

I prefer the `kubectl port-forward` option as when using Docker for Desktop, you access it at localhost:<port>.

`kubectl proxy` may be better if you need to access other internal services, or if the self-signed certification is giving you problems.

It’s up to you and below, we'll use both.

### Step 2.1 Kubernetes Dashboard with Port Forwarding

The `kubectl port-forward` command needs the Pod name, the host machine port, and the local port.

!!! note: 
    The following code presumes the existence of bash so if you’re on Windows, you’ll have to grab the pod name and insert it into the port forward command manually.

Grab the name of the Pod:

    kube_dashboard_name=$(kubectl get pods --namespace=kube-system | grep kubernetes-dashboard | awk '{print $1}')

Setup the port forwarding

    kubectl port-forward ${kube_dashboard_name} 30000:8443 --namespace=kube-system

Now you can access the dashboard at https://localhost:30000

Want to run the port forwarding in the background with a single command?

From the learn-kubernetes directory.

    make k8s-dashboard-up

To kill the port forwarding process and remove the dashboard.

    make k8s-dashboard-down

### Step 2.2 Kubernetes Dashboard with `kubectl proxy`

The command is easy to remember, the URL not so much:

    kubectl proxy

Then go to http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview

!!! note

    The `kubectl proxy` makes it possible to access any Service. TODO: LINK.

## Step 3. Access the Dashboard

If this is the first time you’ve accessed the dashboard, you’ll be greeted with a setup screen.

We’re going to click **SKIP** as we're using the Dashboard for our development environment.

## Kubernetes Dashboard in Production

Access should be controlled via a Service token and it shoule be used as a read-only dashboard, not as a way to manage your cluster.

!!! danger

    Never expose it publicly!

    Read more about [securing the Kubernetes dashboard](https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca).
