# Services Lab

To illustrate the dynamic and loosely coupled design of Kubernetes, we're going to expose a service, but exposing the service first without any pods to support it.

!!! note

    Because Docker for Desktop does not bind the `NodePort` associated with the `LoadBalancer` Service type to localhost (on the host), I will be using the a type of `NodePort` service.

    Currently when using type `LoadBalancer`, every `port` value (not the NodePort) in our service is mapped from our host machine to the Docker VM. I have no idea why this is the default as it means that we can't have multiple services which listen on the same ports.

Create the service:

    kubectl apply -f manifests/service.yaml

Inspect the service so we can get the randomly assigned ports:

    kubectl describe service kuard-service | grep Port

Confirm we don't have any pods matching the label the service is querying for:

    kubectl get pods kuard-pod

We can tell the service doesn't have Pods because there are no endpoints associated with the service.

    kubectl describe service kuard-service

Let's create the kuard Pod again.

    kubectl apply -f manifests/pod.yaml

And now, we can see one endpoint.

    kubectl describe service kuard-service

### Service name by DNS

This must be done through a container running in the same namespace as the service.

Now that we've deployed the kuard Pod, we can get the fully qualified domain name (FQDN).

    make debug-container-up
    nslookup kuard-service

!!! note
    The output from `nslookup` which says "nslookup: can't resolve '(null)': Name does not resolve" is expected because there is no DNS server to perform the lookup against.

Now let's try making a request to the service.

    wget kuard-service -q -O -

What's neat is that the service is constantly monitoring the Pods who's labels match it's selector query and so knows which Pod Ip addresses (endpoints) to route the request to.

Exit (to kill) the debug container.

### The ClusterIP

When a Service is created, it is assigned Cluster IP which is unique for the life of the service. This Service IP is completely virtual though. See https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies for more info.

Virtual doesn't mean magic through.

Let's find the `Cluster IP` value of the `kuard-service`. The Cluster IP is guaranteed not to change.

    echo `kubectl get service kuard-service --template='{{.spec.clusterIP}}'`
    
    
Let's verify that this is a legit IP address by hitting it from the Docker VM.

    make docker-vm-shell
    wget <IP> -q -O -

No magic and no hidden IP address scheme. Kubernetes is awesome!

Exit out of the Docker VM shell
