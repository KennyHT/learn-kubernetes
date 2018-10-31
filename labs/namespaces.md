# Namespaces

Namespaces allow you to break a Kubernetes cluster into several virtual clusters.

What namespaces exist for your cluster?

    kubectl get namespaces

What objects are in a particular namespace?

    kubectl get all --namespace=kube-system

Let's create the `learn-k8s` namespace that we'll use at times during this training.

    kubectl apply -f manifests/namespace.yaml

Verify it succeeded.

    kubectl get namespaces

Let's create the `kuard-pod` in the default namespace for verifying what namespace we're pointing to later.

    kubectl apply -f manifests/pod.yaml
    
## The kubectl context

A `context` is just that, a context for what cluster, which user and which namespace should be used for deploying resources.

You can use contexts for switching between different clusters or even the same cluster but with a different user, different namespace or both.

We're going to create a context for the `docker-for-desktop` cluster that sets the namespace to `learn-k8s` so all of the resources you deploy for these labs don't interfere with any resources you may have in the `default` namespace. That's what namespaces are for! To keep things separated.

We'll call the context `learn-k8s` (first positional argument).

    kubectl config set-context learn-k8s --cluster=docker-for-desktop-cluster --user=docker-for-desktop --namespace=learn-k8s

But this has only created the context. Let's tell `kubectl` to use our new `learn-k8s context.

    kubectl config use-context learn-k8s

As a test, let's create `kuard-pod` and inspect the Pod properties to see which namespace it was created in.

    kubectl apply -f manifests/pod.yaml
    echo $(kubectl get pod kuard-pod -o "jsonpath={.metadata['namespace']}")

Cleanup the `kuard-pod`:

    kubectl delete -f manifests/pod.yaml

!!! note

    You can also switch the context by using the Docker toolbar app.
    
    <img style="width: 400px" src="../media/img/docker-for-desktop-set-context.jpg" />
