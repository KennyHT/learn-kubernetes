# Pods Lab

In this lab, we will deploy a pod to our Minikube instance.

Deploy our nginx pod:

    kubectl apply -f templates/api-pod.yaml

Observe that it is running via Docker (just for fun really):

    docker container ps --filter name=api-pod

Verify that the api container is running in the pod and is listening on port 80:

    kubectl get pods api-pod  --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'

If all you need to work on is a single pod, then you can just deploy the pod, then port forward from the machine `kubectl` is running on to access the pod outside the cluster without deploying a service.

Port forward from the host to the pod:

    kubectl port-forward api-pod 8080:80

View the API in your browser at http://localhost:8080/api/v1/users/

Kill the port-forwarding process in your terminal/

Let's inspect our pod (in a few different ways):

    kubectl get pods api-pod
    kubectl get pods api-pod -o wide
    kubectl describe pods api-pod
    kubectl get pods api-pod -o yaml
    kubectl get pods api-pod -o json

Docker commands such as `logs` and `exec` have pod equivalents.

Let's view the logs for our pod:

    kubectl logs api-pod

Let's exec into our pod:

    kubectl exec -it api-pod sh

For these commands in this instance, we did not need to specify which container to access the logs or exec into because there is only one container in the pod. By default, `kubectl` will execute the command against the first container in the `spec.containers` list. 

To specify which pod you want to access, use the `--container` (or `-c-) option along with the container name:

    kubectl logs api-pod --container training-api --follow
    kubectl exec -it api-pod --container training-api sh

Finally, remvove your pod in one of the following ways:

    kubectl delete -f templates/api-pod.yaml
    kubectl delete pods/api-pod

Question: Which command is preferable and why? (think declarative vs. imperative).

## TODO

 - Add horizontal pod auto-scaling example - https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
 - Add container request and limit for resources - https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
 