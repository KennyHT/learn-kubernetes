# Secrets

Secrets can be created from literal values and exposed through environment variables and volume mounts and in this lab, we'll cover both.

## Creating a Secret from literal values

Let's create a secret from a literal value.

    kubectl create secret generic api-token --from-literal=API_TOKEN=ksej3839034u7bk28747op21u7d3u7
    kubectl get secrets

Notice that `api-token` is of `TYPE` *Opaque*? That means that it is a collection of key-pairs as opposed to a type of key that Kubernetes internally as `ServiceAccount` credentials or an `ImagePullSecret` secret.

Also note that the value of the secret has been base64 encoded.

    kubectl get secret api-token -o yaml
    
Delete the secret.

    kubectl delete secret api-token
    
## Creating Secrets from manifest files

Now lets create a secret declaratively, first getting the `base64` encoded value.

    echo -n 'ksej3839034u7bk28747op21u7d3u7' | base64

Then putting it into our Secret manifest (example at `manifests/secret-api-token.yaml`).

    apiVersion: v1
    kind: Secret
    metadata:
      name: api-token
    type: Opaque
    data:
      API_TOKEN: a3NlajM4MzkwMzR1N2JrMjg3NDdvcDIxdTdkM3U3

Now let's create this secret.

    kubectl apply -f manifests/secret-api-token.yaml

## Secret access in environment variables        

Secrets, like other configuration data are often supplied via environment variables, using the `kuard` Pod.

    kubectl apply -f manifests/pod-api-token.yaml
    kubectl port-forward kuard-pod 8080:8080

Now open http://localhost:8080/-/env to see that the environment variable `API_KEY` is defined with the base64 decoded value of `ksej3839034u7bk28747op21u7d3u7`.

Kill the port-forwarding the delete all resources.

    make delete-all

## Secrets access via volumes

Java applications often use `.properties` files for configuration. Let's use the file in `resources/db.properties` and mount it inside a `kuard` Pod. This Pod will also depend on `api-token`.

First, let's create the secret.

    kubectl apply -f manifests/secret-db-properties.yaml -f manifests/secret-api-token.yaml 

Now let's create the `kuard` Pod.

    kubectl apply -f manifests/pod-users-db.yaml
    kubectl port-forward kuard-pod 8080:8080

The `kuard`Pod has a file browser which while being a disaster for security, is really great for labs.

Open http://localhost:8080/fs/ and navigate to the `/etc/secrets/` directory where you can view the contents of the `db.properties` file.
