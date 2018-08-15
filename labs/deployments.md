# Deployments

Create the deployment object:

    kubectl apply -f objects/api-deployments.yaml

Get the state of the deploloyment:

    kubectl get deployments
    kubectl describe deployment api-deployment

## Scale our pods using Deployments

Update `spec.replicas` in `api-deployments.yaml` to be 15, then deploy our changes:

    kubectl apply -f objects/api-deployments.yaml

Then observe the state change to the list of pods every second using the `watch` command:

    watch -n 1 kubectl get pods

Notice the old pods don't get deleted straight away. This is because of `spec.minReadySeconds` value of 30 seconds.

## Deploy a new version of our API container

Let's change the data in `api/data/users/index.json` to change the data served by our API.

Then lets build a new version of the api container:

    make api-build VERSION=2.0

Now update your `api-deployments.yaml` file, changing the image tag to `2.0` and adding the following under `spec.template.metadata` in order to provide a reason for the manifest change. This is something that would be template driven by your CD system.

    annotations:
        kubernetes.io/ change-cause: 'Data changed in API, updating to 2.0'

Then apply your change:

    kubectl apply -f objects/api-deployments.yaml

Then observe the state change to the list of pods every second using the `watch` command:

    watch -n 1 kubectl get pods

Observe the deployment history:

    kubectl rollout history deployment/api-deployment

## Debugging Tip: Isolating a pod or pods from a ReplicaSet

If a pod pods begin misbehaving, you may not want it to be killed, as you may want to quarantine it (take it out of service) in order to inspect it figure out what went wrong.

To do this, you can change or overwrite the labels (depending upon the replicaset label selector).

Let's take one of the deployment pods out of service.

    # Get a pod name
    kubectl get pods

    # Take it out of service by changing its label
    # NOTE: Changing the label value is only to disassociate it the
    replicaset and service. It has nothing to do with the actual health of the pod and Kubernetes does not care about the value.

    kubectl label pods api-replicaset-<HASH> --overwrite app=api-quarantined.

This will cause Kubernetes to disassociate that pod with the replicaset which in turn, will cause Kubernetes to create a new pod. As this pod is now unmanaged, you can exec into it without fear of it being killed.

<!--
*TODO*: Add name change as well to make it more obvious which pod was disassociated with the replicaset.
-->