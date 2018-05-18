# Services Lab

To illustrate the dynamic and loosely coupled design of Kubernetes, we're going to expose a service, but exposing the service first without any pods to support it.

Create the service:

    kubectl apply -f templates/api-service.yaml

Inspect the service so we can get the randomly assigned ports:

    kubectl describe service api-service | grep Port

Confirm we don't have any pods matching the label the service is querying for:

    kubectl get pods api-pod

## Services and Docker for Mac

For those of you coming from Minikube, you may find Docker for Desktop's approach to service exposure a bit strange.

So can we access the service from our host machine? Well sort of, but not in the way you may expect.

Docker purposely want us trying to access the Linux VM and instead, it plans on port forwarding every `targetPort` value to the VM for us.

Open a new terminal window and create the api pod.

    kubectl apply -f templates/api-pod.yaml

Switch back to the other terminal at which point, it will launch a web browser window once an endpoint becomes available.

How did the service know to send traffic to the `api-pod`? Because the `api-pod` had a label of `app=api` and the `api-service` had a label selector of `app=api`. The service then looked up the endpoint associated with each pod so it could load balance across them.

## The ClusterIP

When a Service is created, it is assigned Cluster IP which is unique for the life of the service. This Service IP is completely virtual though. See https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies for more info.

Let's find the `Cluster IP` value of the `api-service`. The Cluster IP is guaranteed not to change.

    echo `kubectl get service api-service --template='{{.spec.clusterIP}}'`

Now let's ssh to the minikube instance and use curl to perform a request inside the Kubernetes cluser.

    minikube ssh
    curl <API SERVICE IP>/api/v1/users/
    curl <API SERVICE IP>/api/v1/users/
