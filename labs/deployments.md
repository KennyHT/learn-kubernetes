# Deployments

Before we create the deployment, let's take a look at `manifests/deployment.yaml` file to see what resources it depends on.

Make sure you have created the required ConfigMaps and Secrets. Then create the Deployment.

    kubectl apply -f manifests/deployment.yaml

Get the state of the Deployment:

    kubectl get deployments
    kubectl describe deployment kuard

## Observing the change to our Pods

In a new terminal window, observe the state change to the list of Pods. We're going to keep this around for this entire lab.

    make watch-pods

## Scale our Pods using Deployments

Update `spec.replicas` in `deployment.yaml` to be `3`, then deploy the change:

    kubectl apply -f manifests/deployment.yaml

Let's scale up the imperative way:

    kubectl scale --replicas=5 deployment kuard

Notice the old pods don't get deleted straight away. This is because of `spec.minReadySeconds` value of 30 seconds.

Update `spec.replicas` in `deployment.yaml` to be `20`, then deploy our changes. Did all of the Pods come up? Let's go checkout the Kubernetes dashboard.

Update `spec.replicas` in `deployment.yaml` to be `2` again and apply the change.
<!-- 
## Rolling Back to a Previous Revision

Let's say that something went wrong when we upgraded to the newer `kuard` container and we want to roll back:

    kubectl rollout undo deployment kuard -->

## Update the deployment to Deploy a new version of the kuard container

Update your `deployment.yaml` file, changing the image tag to `2` and add the following under `spec.template.metadata` in order to provide a reason for the manifest change. This is something that would be template driven by your CD system.

    annotations:
        kubernetes.io/ change-cause: 'Upgraded to version 2.'

Then apply your change:

    kubectl apply -f manifests/deployment.yaml

Observe the deployment history:

    kubectl rollout history deployment kuard



## Debugging Tip: Isolating a Pod from a ReplicaSet

If a pod pods begin misbehaving, you may not want it to be killed, as you may want to quarantine it (take it out of service) in order to inspect it figure out what went wrong.

To do this, you can change or overwrite the labels (depending upon the RepicaSet label selector).

Let's take one of the deployment pods out of service.

    # Get a pod name
    kubectl get pods

    # Take it out of service by changing its label
    # NOTE: Changing the label value is only to disassociate it the
    RepicaSet and Service. It has nothing to do with the actual health of the Pod and Kubernetes does not care about the value.

    kubectl label pods kuard-- $ID --overwrite app=kuard-quarantined.

This will cause Kubernetes to disassociate that Pod with the deployment which in turn, will cause Kubernetes to create a new Pod. 

As the renamed Pod is now un-managed, you can exec into it for investigation. Be aware that because it is now un-managed, it will need to be deleted manually.

<!-- TODO: 
- Canary
-->