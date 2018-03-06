# Pods Lab

Deploy our nginx pod:

    kubectl apply -f templates/api-pod.yaml

Observe that it is running via Docker (just for fun really):

    docker container ps --filter name=api-pod

Verify that the api container is running in the pod and is listening on port 80:

    kubectl get pods api-pod  --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'

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

Let's view the logs for our pod:

    kubectl logs api-pod

Let's exec into our pod:

    kubectl exec -it api-pod sh

Clean up in one of the following ways:

    kubectl delete -f templates/api-pod.yaml
    kubectl delete pods/api-pod
