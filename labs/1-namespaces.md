## Namespaces

Namespaces allow you to break a Kubernetes cluster into several virtual clusters.

What namespaces exist for your cluster?

    kubectl get namespaces

What objects are in a particular namespace?

    kubectl get all --namespace=kube-system

Let's create the `learn-k8s` namespace that we'll use at times during this training.

    kubectl apply -f objects/namespace.yaml

Verify it succeeded.

    kubectl get namespaces
