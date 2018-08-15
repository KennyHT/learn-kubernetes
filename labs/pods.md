# Pods Lab

In this lab, we will deploy a Pod, the unit of compute to our Kubernetes instance.

You will notice that we **always** use the declarative form for changing the state of our Kubernetes cluster and I strongly encourage you to always do the same.

See the page on [Object Management using kubetcl](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/declarative-config/) for more info.

## Introducing the Kubernetes Up and Running Demo (kuard) Pod

From the excellent [Kubernetes Up and Running](https://www.amazon.com/Kubernetes-Running-Dive-Future-Infrastructure/dp/1491935677) book, we're going to use this handy container to help demonstrate many of Kubernetes Pod management features.

Deploy our kuard Pod:

    kubectl apply -f objects/pod.yaml

Verify that the container is running in the Pod and is listening on port 8080:

    kubectl get pods kuard-pod --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'
    # >>> 8080

For fun, let's deploy the `kuard-pod` into the `learn-k8s` namespace.

    kubectl apply -f objects/pod.yaml --namespace=learn-k8s

No complaints about the Pod having the same name as its in a different namespace. 

Let's now delete it as we'll be using the default namespace for the training for ease of use.

    kubectl delete -f objects/pod.yaml --namespace=learn-k8s
    
For development purposes, often you only need a single Pod exposed. If so, then you can just deploy the Pod and port forward from your host.

    kubectl port-forward kuard-pod 8080:8080

View the API in your browser at http://localhost:8080/

Kill the port-forwarding process in your terminal using a SIGINT (Ctrl+c).

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

Finally, remove your Pod:

    kubectl delete -f objects/pod.yaml

<!--
## TODO

 - Show debug Pod example
 - Health and Readiness check
 - OOM killing
 - Image pull policy
 - Show what happens when you change certain set only fields (ports) vs labels or names.
 - Add horizontal Pod auto-scaling example - https://kubernetes.io/docs/tasks/run-application/horizontal-Pod-autoscale/
 - Example of assigning Pods to a specific node.
-->
