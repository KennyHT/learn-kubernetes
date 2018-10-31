# ConfigMaps

ConfigMaps can be created from directories, files, or literal values.

This lab is going to focus on the most common use of ConfigMaps which is literal values mapping to environment variables.

See the [Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) page from the Kubernetes docs to see other examples.

## Anatomy of a ConfigMap

A ConfigMap is a collection of key-value pairs, known as its data-source.

To illustrate this, let's create a ConfigMap from literal values.

    kubectl create configmap db-config --from-literal=HOST=db.acmecorp.com --from-literal=NAME=users

Now let's get the ConfigMap contents.

    kubectl get configmap db-config -o yaml

You can see each key-value pair passed in on its own line in the `data` section.

Remove the ConfigMap before continuing.

    kubectl delete configmap db-config

## Creating ConfigMaps from manifest files

We can also create a ConfigMap the declarative way.

    kubectl apply -f manifests/configmap-db.yaml
    kubectl get configmaps
    kubectl get configmap db-config -o yaml    

Typically, ConfigMaps will be created as manifest files and if the values need to change, they will either be changed in source or use variable substitution at deploy time in your CI/CD system of choice. How you create the manifest file though does not matter.

## Mapping ConfigMap keys to Pod environment files

This is the most common way to use ConfigMap data. We can map keys to Pod environment variables one by one, or all at once.

Let's look at `manifests/pod-configmap.yaml` for examples of both types.

## Pods needs a valid ConfigMap to exist ahead of time

A Pod that depends on a ConfigMap will fail to start if the ConfigMap does not exist, or if the pod references a ConfigMap key that does not exist.

Let's delete all Pods and ConfigMaps from the `learn-k8s` namespace.

    kubectl delete pods,configmaps --all

The `manifests/pod-configmap.yaml` file relies on two ConfigMaps. Let's only deploy one ConfigMap.

    kubectl apply -f manifests/configmap-db.yaml
    kubectl apply -f manifests/pod-configmap.yaml
    kubectl get pod kuard-pod -o wide

We can see the Pod has a status of `CreateContainerConfigError`. Let's fix this by creating the missing ConfigMap.

    kubectl apply -f manifests/configmap-app.yaml
    watch kubectl get pod kuard-pod -o wide

After an amount of time, the Pod is able to start and eventually becomes healthy.

What's important to remember is that with ConfigMaps (and Secrets), order of operations matter. Also be careful that any Pod spec configuration changes are matched with ConfigMap changes.

## Verifying our Pod has the expected environment variables

    kubectl exec -it kuard-pod printenv
