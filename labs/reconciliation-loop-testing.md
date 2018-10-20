# Testing the Reconciliation Loop

Let’s manually delete all of the Pods from the docker namespace and see what Kubernetes does.

First, let's setup a termial that will watch the status of the Pods in the `docker` namespace.

    watch kubectl get pods --namespace=docker —watch

Now in another terminal, delete the Pods.

    kubectl delete --all pods --namespace=docker

Without us having to do anything, Kubernetes observed that the desired state was no longer the current state and sprung into action.

Wouldn’t it be cool if we could see exactly what Kubernetes was doing? Let’s do the same thing again but this time, we’ll tail the events log.

    make event-stream

Delete the Pods again.

    kubectl delete --all pods --namespace=docker

Proably more information than you need, but it's great that Kubernetes makes what's happening so transaprent.
