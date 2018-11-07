# Kubectl essentials

## The Kubernetes kubectl cheat sheet

The Kubernetes documentation has its own [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/).

It is awesome. Let's spend some time reading it.

Then, here are a few that I like from that cheat sheet, as well as some of others that I find useful.

## kubectl

Perhaps the most important command that you may not have thought to run is:

    kubectl

This gives you an overview of the various commands.The grouping by purpose is very useful for knowing if a particular command would be useful for what you need to accomplish.

## kubectl global options

kubectl has a list of options that can be passed to any command (e.g. `--namespace`)

    kubectl options

## kubectl bash completion

This is essential. Not as easy as using the `bash-completion` system for homebrew but still easy.

    source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
    
    # add autocomplete permanently to your bash shell.
    echo "source <(kubectl completion bash)" >> ~/.bash_profile

## View pods 

Sometimes you need more control over the pods that are returned by `kubectl`.

    kubectl get pods --include-uninitialized
    
    # Status could be one of Pending, Running, Succeeded, Failed, or Unknown
    kubectl get pods --field-selector=status.phase=Running

# Diff configurations between local and live versions

While you can use something like `kubectl get pod kuard-pod -o yaml`, that will return the entire YAML stores in etcd. What about if you wanted to compare what Kubernetes has vs. what you have locally.

    kubectl apply -f manifests/pod.yaml
    kubectl alpha diff -f manifests/pod.yaml

This could be used to measure drift between resources in source control vs. resources in the cluster. It's also an awesome way to learn what other fields your specifications could have.

For example, I could add `successThreshold` to my `livenessProbe` properties.

## kubectl explain

Documentation for command line tools isn't always easy to understand. With Kubernetes, it's awesome!

    kubectl explain deployment

Oops. Notice `VERSION:  extensions/v1beta1` at the top?. We're looking at documentation for the first version of Deployments which is now deprecated.

What we need is the deployments from the `apps` API group.

    kubectl explain deployment --api-version=apps/v1

Now lets get more specific about what we want to learn about Deployments.

    kubectl explain deployment.spec --api-version=apps/v1
    kubectl explain deployment.spec.strategy --api-version=apps/v1
    
## Scale a deployment

This is important if you need to scale a deployment immediately but the advisable method is change the manifest YAML and change the replias that way.

    # Note: This won't work as we don't have a Deployment named `my-app`. It's just an example.
    kubectl scale --replicas=3 deployment/my-app

## A debug pod

To deug the state of an application from within the Namespace, I'd recommend deploying a short-lived debug Pod instead of `kubectl exec` to access and existing Pod.

You could even create a specialized debug image that has all the typical tools you need when debugging.

    kubectl run debug-shell --rm -it --image ubuntu:latest -- bash

## Cluster event stream

While you're probably better served by specially designed service, this is a good substitute in the absence of that.

    kubectl get events --sort-by=.metadata.creationTimestamp -o custom-columns=CREATED:.metadata.creationTimestamp,NAMESPACE:involvedObject.namespace,NAME:.involvedObject.name,REASON:.reason,KIND:.involvedObject.kind,MESSAGE:.message -w --all-namespaces

## Tail Pod logs

[Kail](https://github.com/boz/kail) is an awesome tool for tailing the logs of multiple Pods using a varied set of selectors. What's great, is that we can deploy it into our cluster so there is nothing to install locally.

To tail all pods in the cluster (probably only useful on your local instance).

    kubectl apply -f manifests/pod.yaml
    kubectl run -it --rm -l kail.ignore=true --restart=Never --image=abozanich/kail kail --
    
Tail the `kuard-pod`.

    kubectl run -it --rm -l kail.ignore=true --restart=Never --image=abozanich/kail kail -- --pod kuard-pod

## Force delete a Pod

Sometimes, a Pod can get into a state where you cannot kill it. This command should be a last resort.

    kubectl delete pod $POD_NAME --force --grace-period=0

If that doesn't work, it could be because the finalizer for a Pod

## List the available API resources for your cluster

    kubectl api-resources

## Caution! Delete all the objects from a namespace

This is handy during development when you want to clear out all objects in a namespace. Always specify the `--namespace` for safety.

    kubectl delete pods,services,configmaps,secrets,replicasets,deployments,jobs,cronjobs,daemonsets,statefulsets,podsecuritypolicies --all --namespace=learn-k8s

You could achieve the same thing by deleting the Namespace. Just remember to create it again.
