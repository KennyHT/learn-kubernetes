# Testing the reconciliation loop

Let's manually delete all of the Pods from the `docker` Namespace and see what Kubernetes does.

First, let's set up a terminal that will watch the status of the Pods in the `docker` Namespace.

    watch kubectl get pods --namespace=docker
    
Or if you don't have watch installed:

    kubectl get pods --namespace=docker --watch

In another terminal, delete all Pods from the `docker` Namespace.

    kubectl delete --all pods --namespace=docker

Kubernetes observed that the desired state was no longer the current state and took action.

Wouldn't it be cool to see what Kubernetes did in more detail? Lets do the same thing again but this time, we'll tail the events log.

    make event-stream

Delete the Pods again.

    kubectl delete --all pods --namespace=docker

Probably more information than you need, but it's great that Kubernetes makes what is happening so transparent.
