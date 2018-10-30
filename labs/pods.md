# Pods Lab

In this lab, we will deploy a Pod, the unit of compute to our Kubernetes cluster.

You will notice that we **always** use the declarative form for changing the state of our Kubernetes cluster and I strongly encourage you to always do the same.

See the page on [Object Management using kubetcl](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/declarative-config/) for more info.

## Introducing the Kubernetes Up and Running Demo (kuard) Pod

From the excellent [Kubernetes Up and Running](https://www.amazon.com/Kubernetes-Running-Dive-Future-Infrastructure/dp/1491935677) book, we're going to use this container to demonstrate many of Kubernetes Pod management features.

Deploy our kuard Pod:

    kubectl apply -f manifests/pod.yaml

Verify that the container is running in the Pod and is listening on port 8080:

    kubectl get pods kuard-pod --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'
    # >>> 8080

## Pod names

Pod names must be unique for a namespace.

For fun, let's deploy the `kuard-pod` into the `default` namespace.

    kubectl apply -f manifests/pod.yaml --namespace=default

No complaints about the Pod having the same name as its in a different namespace. 

Let's now delete it as we'll be using the `learn-k8s` namespace for this training.

    kubectl delete -f manifests/pod.yaml --namespace=default
    
For development purposes, often you only need a single Pod exposed. If so, then you can just deploy the Pod and port forward from your host.

    kubectl port-forward kuard-pod 8080:8080

View the API in your browser at http://localhost:8080/

Kill the port-forwarding process in your terminal using a SIGINT (Ctrl+C).

Let's inspect our Pod (in a few different ways):

    kubectl get pods kuard-pod
    kubectl get pods kuard-pod -o wide
    kubectl describe pods kuard-pod
    kubectl get pods kuard-pod -o yaml
    kubectl get pods kuard-pod -o json | jq

Docker commands such as `logs` and `exec` have Pod equivalents.

Let's view the logs for our Pod:

    kubectl logs kuard-pod

This works, but beware. If we had more than one container in our Pod, it wouldn't as kubectl would not know which container we want logs for. To do this in a way which will always work, let's use the container name.

    kubectl logs kuard-pod kuard

If we want to tail the logs, we need to supply the `-f` flag.

    kubectl logs kuard-pod kuard -f

We can see regular requests for `/healthy` and `/ready`. This is being called by the `kubelet` that is responsible for monitoring the health of the pods on each worker node.

## Accessing a Pod

Wouldn't it be great if we could get into a container inside our Pod, as easily as we the `docker container exec` command. Turns out we can.

    kubectl exec -it kuard-pod sh 

By default, `kubectl` will execute the command against the first container in the `spec.containers` list. 

To specify which Pod you want to access, use the `--container` (or `-c`) option along with the container name:

    kubectl exec -it kuard-pod --container kuard sh
    
Now let's see how Kubernetes reacts to us setting the kuard container to an unhealthy state.

    kubectl port-forward kuard-pod 8080:8080

Then in another terminal:

    make event-stream

Or...

    make watch-pods

Now let's set go to http://localhost:8080/ and set the health to unhealthy and we'll watch Kubernetes give it a chance to recover, then when it exceeds the unhealthy count threshold, kill the Pod and replace it with another.

## A debugging Pod

Sometimes you may want to inject a Pod into the current namespace for introspection purposes.

First, let's get the IP of the kuard Pod.

    kubectl get pods kuard-pod -o wide

Then, with a single command, we can launch a deployment and exec into our debugging container.

    make debug-container-up

Now let's try hitting the Pod directly using its IP address.

    wget $IP:8080 -q -O -

We're going to use this debug container later when we look at services.

For now, let's exit. As a result of exiting, it should also kill the deployment. Verify by running.

    kubectl get deployments

If you can still see your debug container running, then use the following command to delete it.

    make debug-container-down

Finally, remove the kuars Pod:

    kubectl delete -f manifests/pod.yaml

<!--
## TODO

 - OOM killing
 - Show what happens when you change certain set only fields (ports) vs labels or names.
 - Add horizontal Pod auto-scaling example - https://kubernetes.io/docs/tasks/run-application/horizontal-Pod-autoscale/
 - Example of assigning Pods to a specific node.
-->
