# Replicas Lab

This lab is a bit different in that you'll be creating the replicaset.yaml yourself.

## Code challenge

Using the documentation at https://v1-9.docs.kubernetes.io/docs/concepts/workloads/controllers/replicaset/, create a replicaset resource in `template/replicaset.yaml` that uses the information from the api-pod.yaml file. Set the number of replicas to whatever you like (although less than 20 is probably a good idea :).

For the solution, see the\ `templates/api-replicaset-solution.yaml`.

To deploy:

    kubectl apply -f templates/api-replicaset.yaml

To verify

    kubectl get replicasets
    kubectl get pods

Notice that the name of the pods is different for those that were created by the ReplicaSet.

    # TODO: Fix. Not working.
    kubectl get pod api-replicaset-<HASH> --template='{{(index (index .metadata.annotations))}}{{"\n"}}'

## Debugging Tip: Isolating a pod or pods from a ReplicaSet

If a pod pods begin misbehaving, you may not want it to be killed, as you may want to quarantine it (take it out of service) in order to inspect it figure out what went wrong.

To do this, you can change or overwrite the labels (depending upon the replicaset label selector).

Let's take one of the replicaset pods out of service.

    # Get a pod name
    kubectl get pods

    # Take it out of service by changing its label
    kubectl label pods api-replicaset-<HASH> --overwrite app=api-unhealthy

This will cause Kubernetes to disassociate that pod with the replicaset which in turn, will cause Kubernetes to create a new pod. As this pod is now unmanaged, you can exec into it without fear of it being killed.
