# Replicas Lab

This lab is a bit different in that you'll be creating the the `kuard-replicaset.yaml` yourself.

## Code challenge

Using the documentation at *[https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)*, create a replicaset resource in `template/replicaset.yaml` that uses the information from the `manifests/pod.yaml` file. Set the number of replicas to whatever you like (although less than 20 is probably a good idea :).

For the solution, see the `manifests/kuard-replicaset-solution.yaml`.

To deploy:

    kubectl apply -f manifests/kuard-replicaset.yaml

To verify:

    kubectl get replicasets
    kubectl get pods

Notice that the name of the pods is different for those that were created by the ReplicaSet.

    # TODO: Fix. Not working.
    kubectl get pod kuard-replicaset-<HASH> --template='{{(index (index .metadata.annotations))}}{{"\n"}}'

Clean up now by deleting your replicaset:

    kubectl delete -f manifests/kuard-replicaset.yaml
