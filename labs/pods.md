# Pods Lab

In this lab, we will deploy a Pod, the unit of compute to our Kubernetes cluster.

A real application would never have just a single Pod, we're keeping things simple for now and we'll get to multiple Pods later when we cover Deployments.

!!! note

    You will notice that we **always** use the declarative form for changing the state of our Kubernetes cluster throughout these labs, and I encourage you to do the same.

    See the page on [Object Management using kubetcl](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/declarative-config/) for more info.

## Introducing the Kubernetes Up and Running Demo (kuard) Pod

From the excellent [Kubernetes Up and Running](https://www.amazon.com/Kubernetes-Running-Dive-Future-Infrastructure/dp/1491935677) book, we're going to use the `kuard` container throughout these labs as its a fantastic container to use for debugging and learning about Kubernetes.

!!! warning

    THe kuard container is designed for learning and should never be run on a production cluster. Use it on a local cluster only.

Create the `kuard` Pod the declarative way (the right way):

    kubectl apply -f manifests/pod.yaml

Verify that the container is running in the Pod and is listening on port 8080:

    # Eample of using a Go template
    kubectl get pod kuard-pod --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'

    # I prefer using json path as I think it's easier to use and read
    kubectl get pod kuard-pod -o "jsonpath={.spec.containers[0].ports[0].containerPort}"

## Pod names

Pod names must be unique for a Namespace.

Let's try create a Pod named `kuard-pod` in our `learn-k8s` namespace.

    # Using create here as apply will think we're applying updates to the existing kuard-pod
    kubectl create -f manifests/pod.yaml

You should have gotten a `AlreadyExists` error.

# Port forwarding

We can't reach the `kuard-pod` because everything in the cluster is private unless exposed by a Service. To get the `kuard-pod`, we'll use port forwarding:

    kubectl port-forward kuard-pod 8080:8080

View the API in your browser at http://localhost:8080/

Kill the port-forwarding process in your terminal by sending a sigal interupt (SIGINT) by pressing Ctrl+C.

Let's inspect our Pod in a few different ways:

    kubectl get pod kuard-pod
    kubectl get pod kuard-pod -o wide
    kubectl describe pod kuard-pod
    kubectl get pod kuard-pod -o yaml
    kubectl get pod kuard-pod -o json | jq

These commands are not specific to Pods. This is how we data about all of the resources avaialble to our cluster.

## Container logs

Let's view the logs for our Pod:

    kubectl logs kuard-pod

When you have multiple containers in your Pod, you'll need to specify which container you want the logs for.

    kubectl logs kuard-pod $CONTAINER_NAME
    kubectl logs kuard-pod kuard

If we want to tail the logs, we need to supply the `-f` flag.

    kubectl logs kuard-pod kuard -f

We can see regular requests for `/healthy` and `/ready`. This is being called by the `kubelet` that is responsible for monitoring the health of the pods on each worker node.

## Accessing a Pod

Wouldn't it be great if we could get into a container inside our Pod, as easily as the `docker container exec` command.

    kubectl exec -it kuard-pod sh 

By default, `kubectl` will execute the command against the first container in the `spec.containers` list. 

use the `--container` (or `-c`) and the container name to choose which container to exec to:

    kubectl exec -it kuard-pod --container kuard sh

Now that we're inside the container, we can run commands:

    printenv

We can run any command against the container though (we don't have to have a shell session first).

    kubectl exec -it kuard-pod --container kuard printenv

## Liveness probe
    
Now let's see how Kubernetes reacts to the `kuard` container being in an unhealthy state.

    kubectl port-forward kuard-pod 8080:8080

Then in another terminal:

    make event-stream

Open the [liveness page](http://localhost:8080/-/liveness) for the `kuard` container and click on the **Fail** link.

Observe that Kubernetes **imediately** killed the Pod as soon as the container's `.spec.containers.livenessProbe.failureThreshold` was exceeded. It was then replaced with a brand new Pod.

When a Pod dies, any file system changes die with it, and that's a good thing. Stateless applications are predictable as we always know they start with the same file system contents.

Kill the `make event-stream` process in your terminal by sending a sigal interupt (SIGINT) by pressing Ctrl+C.
 
## Readiness probe

When it comes to readiness probes, Kubernetes is more tolerant.

A successful readiness probe result indicates the container is ready to do whatever it does. That's different to a liveness probe which indicates whether the container is dead or alive.

In the terminal that you previously ran `make event-stream`, run:

    watch kubectl get pod kuard-pod -o wide

Open the [readiness page](http://localhost:8080/-/readiness) for the `kuard` container and click on the **Fail** link.

Once the readiness probe exceeds the `failureThreshold` value, the `READY` values changes to `0/1`.

But notice that the Pod did not get killed. That's because it is still alive.

If on the [readiness page]http://localhost:8080/-/readiness), we click on the **Succeed** link, we will see `READY` change to `1/1`.

## When your Pod exceeds its allotted memory

Kubernetes has no tolerance for containers that exceed their memory consumption limits.

Let's open the [Memory](http://localhost:8080/-/mem) page and click on the **Allocate 500 MiB** link.

We see Kubernetes kill the Pod soon after, noticing the `STATUS` briefly changing to `OOMKilled`, then to `CrashLoopBackOff`, then to `RUNNING`.

The transition to the `CrashLoopBackOff` `STATUS` is important. In order to protect the Nodes, every time your Pod is killed due to a problem, the time between entering `CrashLoopBackOff` and `RUNNING` increases.

## A debugging Pod

Sometimes you may want to inject a Pod into the current namespace for introspection purposes.

First, let's get the IP of the kuard Pod. We'll use this in our debugging container.

    echo $(kubectl get pod kuard-pod -o "jsonpath={.status.podIP}")

Then, with a single command, we can launch a deployment and exec into our debugging container.

!!! note

    I'm now aware this command is now deprecated and am investigating an alternative.

    make debug-container

Now let's try hitting the Pod directly using its IP address.

    wget $IP:8080 -q -O -

We're going to use this debug container again when we look at Services.

Exit from the debug container. As a result of exiting, it *should* also kill the deployment. Sometimes, it does not. Check by running:

    kubectl get deployments

If you can still see your debug container running, then use the following command to delete it.

    make kill-debug-container

Finally, remove the `kuard` Pod so we're in a clean state for the next lab.

    kubectl delete -f manifests/pod.yaml

<!--
## TODO

 - OOM killing
 - Show what happens when you change certain set only fields (ports) vs labels or names.
 - Add horizontal Pod auto-scaling example - https://kubernetes.io/docs/tasks/run-application/horizontal-Pod-autoscale/
 - Example of assigning Pods to a specific node.
-->
