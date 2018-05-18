# Pods Lab

In this lab, we will deploy a pod, the unit of compute to our Kubernetes instance.

You will notice that we **always** use the declarative form for changing the state of our Kubernetes cluster and I strongly encourage you to always do the same.

See the page on [Object Management using kubetcl](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/declarative-config/) for more info.

Deploy our API pod:

    kubectl apply -f templates/api-pod.yaml

Observe that it is running via Docker (just for fun really):

    docker container ps --filter name=api-pod

Verify that the api container is running in the pod and is listening on port 80:

    kubectl get pods api-pod --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'

For development purposes, often you only need a single pod exposed. If so, then you can just deploy the pod and port forward from your host.

    kubectl port-forward api-pod 8080:80

View the API in your browser at http://localhost:8080/api/v1/users/

Kill the port-forwarding process in your terminal using a SIGINT (Ctrl+c).

Let's inspect our pod (in a few different ways):

    kubectl get pods api-pod
    kubectl get pods api-pod -o wide
    kubectl describe pods api-pod
    kubectl get pods api-pod -o yaml
    kubectl get pods api-pod -o json

Docker commands such as `logs` and `exec` have pod equivalents.

Let's view the logs for our pod:

    kubectl logs api-pod

This works, but beware. If we had more than one container in our Pod, it wouldn't as kubectl would not know which container we want logs for. To do this in a way which will always work, let's use the container name.

    kubectl logs api-pod training-api

If we want to tail the logs, we need to supply the `-f` flag.

    kubectl logs api-pod training-api -f

Wouldn't it be great if we could get into a container inside our Pod, as easily as we the `docker container exec` command. Turns out we

    kubectl exec -it api-pod sh

By default, `kubectl` will execute the command against the first container in the `spec.containers` list. 

To specify which pod you want to access, use the `--container` (or `-c`) option along with the container name:

    kubectl exec -it api-pod --container training-api sh

Finally, remove your pod:

    kubectl delete -f templates/api-pod.yaml

## TODO

 - Add horizontal pod auto-scaling example - https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
 - Add container request and limit for resources - https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
 - Example of assigning pods to a specific node.
 - Add QoS with resource constraints - https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
