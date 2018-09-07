# ReplicaSets Lab

This lab is a bit different in that you'll be creating the the `replicaset.yaml` yourself.

## Code challenge

Using the documentation at *[https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)*, create a replicaset resource in `template/replicaset.yaml` that uses the information from the `manifests/pod.yaml` file. Set the number of replicas to whatever you like (although less than 20 is probably a good idea :).

For the solution, see the `manifests/replicaset-solution.yaml`.

We will use the solution with a copy of the `manifests/replicaset-solution.yaml` renamed to `manifests/replicaset.yaml` below but use your own `replicaset.yam` file if you completed the code challenge.

To deploy:

    kubectl apply -f manifests/replicaset.yaml

To verify:

    kubectl get replicasets
    kubectl get pods

Notice that the name of the pods is different for those that were created by the ReplicaSet.

Notice too that the `kuard-service` now has multiple endpoints.

    kubectl describe services kuard-service

Replicasets are in that they give us a way to manage multiple Pods, but they have no ability to help us change between one version of Pods to another. That's what deployments are for.

Clean up now by deleting your replicaset:

    kubectl delete -f manifests/replicaset.yaml
