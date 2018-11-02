# Secrets

Secrets can be created from literal values and exposed through environment variables and volume mounts.

## Creating a Secret from literal values

Let's create a secret from a literal value.

    kubectl create secret generic api-token --from-literal=API_TOKEN=ksej3839034u7bk28747op21u7d3u7
    kubectl get secrets api-token

Notice that `api-token` is of `TYPE` *Opaque*? That means it's a collection of key-pairs as opposed to a type of key that Kubernetes uses internally, such as `ServiceAccount` credentials or an `ImagePullSecret` secret.

Also note that the value of the secret has been base64 encoded.

    kubectl get secret api-token -o yaml
    
Delete the secret:

    kubectl delete secret api-token
    
## Creating Secrets from manifest files

Now lets create a secret declaratively, first `base64` encoding the value.

    echo -n 'ksej3839034u7bk28747op21u7d3u7' | base64

Then putting it into our Secret manifest (example at `manifests/secret-api-token.yaml`).

    apiVersion: v1
    kind: Secret
    metadata:
      name: api-token
    type: Opaque
    data:
      API_TOKEN: a3NlajM4MzkwMzR1N2JrMjg3NDdvcDIxdTdkM3U3

Now let's create this secret:

    kubectl apply -f manifests/secret-api-token.yaml

## Secret access in environment variables        

Secrets, like other configuration data are often supplied via environment variables, using the `kuard` Pod.

    kubectl apply -f manifests/pod-api-secret.yaml

Now print out the environment vars to see `API_KEY`:

    kubectl exec -it kuard-pod-api-secret printenv

Let's clean-up all resources we've created so far.

    make delete-all

## Secrets access via volumes

Applications often use `.properties` or `.env` files for configuration. Let's use the file in `resources/db.properties` and mount it inside a `kuard` Pod. This Pod will also depend on `api-token`.

First, let's create the secrets:

    kubectl apply -f manifests/secret-db-properties.yaml 
    kubectl apply -f manifests/secret-api-token.yaml 

Now let's create the `kuard` Pod.

    kubectl apply -f manifests/pod-db-secret.yaml

Then view the environment vars to confirm that the Secret info has been mapped to the environment variables.

    kubectl exec kuard-pod-db-secret printenv
    

The `kuard`Pod has a file browser which while being a disaster for security, is really great for labs.

Port forward to the Pod:

    kubectl port-forward kuard-pod-db-secret 8080:8080

Open http://localhost:8080/fs/ and navigate to the `/etc/secrets/` directory where you can view the contents of the `db.properties` file.
