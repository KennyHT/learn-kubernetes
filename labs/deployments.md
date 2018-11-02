# Deployments

Before we create the deployment, let's take a look at `manifests/deployment.yaml` file to see what resources it depends on.

    kubectl apply -f manifests/deployment.yaml

Get the state of the deploloyment:

    kubectl get deployments
    kubectl describe deployment kuard-deployment

## Observing the change to our Pods

In a termial window, observe the state change to the list of pods. We're going to keep this around for this entire lab.

    watch kubectl get pods

## Scale our pods using Deployments

Update `spec.replicas` in `deployment.yaml` to be `5`, then deploy our changes:

    kubectl apply -f manifests/deployment.yaml

Notice the old pods don't get deleted straight away. This is because of `spec.minReadySeconds` value of 30 seconds.

Update `spec.replicas` in `deployment.yaml` to be `20`, then deploy our changes. Did all of the Pods come up? Let's go checkout the Kubernetes dashboard.

Update `spec.replicas` in `deployment.yaml` to be `2` again.

## Update the deployment Deploy a new version of the kuard container

Update your `deployment.yaml` file, changing the image tag to `2` and adding the following under `spec.template.metadata` in order to provide a reason for the manifest change. This is something that would be template driven by your CD system.

    annotations:
        kubernetes.io/ change-cause: 'Upgraded to version 2.'

Then apply your change:

    kubectl apply -f manifests/deployment.yaml

Observe the deployment history:

    kubectl rollout history deployment/kuard-deployment

## Debugging Tip: Isolating a pod or pods from a ReplicaSet

If a pod pods begin misbehaving, you may not want it to be killed, as you may want to quarantine it (take it out of service) in order to inspect it figure out what went wrong.

To do this, you can change or overwrite the labels (depending upon the replicaset label selector).

Let's take one of the deployment pods out of service.

    # Get a pod name
    kubectl get pods

    # Take it out of service by changing its label
    # NOTE: Changing the label value is only to disassociate it the
    replicaset and service. It has nothing to do with the actual health of the pod and Kubernetes does not care about the value.

    kubectl label pods kuard-deployment--$ID --overwrite app=kuard-quarantined.

This will cause Kubernetes to disassociate that pod with the deployment which in turn, will cause Kubernetes to create a new pod. 

As the renamed pod is now unmanaged, you can exec into it without fear of it being killed.

## Cleanup

We can easily cleanup all of the resources in these labs by telling Kubernetes to delete all of the resources found in the `manifests` directory.

    kubectl delete -f manifests/

It's ok that some of these were not found.

Hope you enjoyed these labs!

<!-- TODO: 
- imperative command 
- Canary
-->