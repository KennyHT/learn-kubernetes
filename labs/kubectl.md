# Kubectl essentials

The [Kubernetes kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) is a incredible resource and I would take the time to go through it after this training.
 
In this lab, though, I'm going to highlight a few of my favorites, some of which aren't in that guide.

## kubectl bash autocompletion

This is essential

    source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
    
    # add autocomplete permanently to your bash shell.
    echo "source <(kubectl completion bash)" >> ~/.bashrc

## View pods 

Sometimes you need more control over the pods that are returned by `kubectl`.

    kubectl get pods --include-uninitialized
    
    # Status could be one of Pending, Running, Succeeded, Failed, or Unknown
    kubectl get pods --field-selector=status.phase=Running

# Diff configurations between local and live versions

While you can use something like `kubectl get pod kuard-pod -o yaml`, that will return the entire YAML stores in etcd. What about if you wanted to compare what Kubernetes has vs. what you have locally.

    kubectl alpha diff -f manifests/pod.yaml

This is important in for operations as it could provide a way to measure drift, but also to learn what other fields your specifications could have.

## kubectl explain

Most commandline tools documentation isn't the easiest to understand. Not so with Kubernetes.

    kubectl explain deploy

Oops. That is for the first version of deployments which is now deprecated because it's been moved to GA.

    kubectl explain deploy --api-version=apps/v1

Now lets get more specific.

    kubectl explain deploy.spec --api-version=apps/v1
    kubectl explain deploy.spec.strategy --api-version=apps/v1
    
## Scale a deployment

Be careful doing this if you're using a manifest file as the source of truth.

    kubectl scale --replicas=3 deployment/my-app

## Debug pod

To inspect the state of the cluster or namespace, I'd recommend deploying a short-lived debug pod instead of exec'ing into an existing pod. 

    kubectl run debug-shell --rm -it --image alpine:latest -- sh

## Cluster event stream

While you're probably better served by specially designed service, this is a good substitute in the absence of that.

    kubectl get events --sort-by=.metadata.creationTimestamp -o custom-columns=CREATED:.metadata.creationTimestamp,NAMESPACE:involvedObject.namespace,NAME:.involvedObject.name,REASON:.reason,KIND:.involvedObject.kind,MESSAGE:.message -w --all-namespaces

## Tail Pod logs

[Kail](https://github.com/boz/kail) is an awesome tool for tailing the logs of multiple Pods using a varied set of selectors. What's great, is that we can deploy it on Kubernetes so there is nothing to install locally.

To tail all pods in the cluster (probably only useful on your local instance).

    kubectl run -it --rm -l kail.ignore=true --restart=Never --image=abozanich/kail kail -- --pod kuard-pod
    
Tail the `kuard-pod`.

    kubectl run -it --rm -l kail.ignore=true --restart=Never --image=abozanich/kail kail -- --pod kuard-pod

## Caution! Delete all the objects from a namespace

This one is handy during development when you want to clear out all objects in a namespace.

    kubectl delete pods,services,configmaps,secrets,deployments,pods --all --namespace=learn-k8s

<!--
TODO: Annotate a deployment if the configmap or secret changes to force the Pods to redeploy
kubectl annotate deployments my-deployment configmap_hash=47348hgksh
-->
