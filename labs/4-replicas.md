# Replicas Lab

This lab is a bit different in that you'll be creating the the `api-replicaset.yaml` yourself.

## Code challenge

Using the documentation at *[https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)*, create a replicaset resource in `template/replicaset.yaml` that uses the information from the `templates/api-pod.yaml` file. Set the number of replicas to whatever you like (although less than 20 is probably a good idea :).

For the solution, see the `templates/api-replicaset-solution.yaml`.

To deploy:

    kubectl apply -f templates/api-replicaset.yaml

To verify:

    kubectl get replicasets
    kubectl get pods

Notice that the name of the pods is different for those that were created by the ReplicaSet.

    # TODO: Fix. Not working.
    kubectl get pod api-replicaset-<HASH> --template='{{(index (index .metadata.annotations))}}{{"\n"}}'

Clean up now by deleting your replicaset:

    kubectl delete -f templates/api-replicaset.yaml
