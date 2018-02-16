# Development Environment Setup

## Minikube setup

### Bash complete

    minikube completion bash > ~/source/minikube_completion.sh

The add this to your `.bash_profile`:

    source ~/source/minikube_completion.sh    

### Docker CLI to Minikube Docker Daemon

We want to avoid having to setup a local registry for K8s to talk to so we make the Docker CLI point to Minikube.

This way, we can build locally and have Kubernetes use the new image instantly without a push to and pull from a registry.

Point Docker CLI at Minikube:

    eval $(minikube docker-env)

Verify it works:

    docker image ls

Build our API image:

    make api-build

Can we see the newly created image in minikube?

    docker image ls | grep training.io/api

## Kubectl bash complete

    kubectl completion bash > ~/source/kubectl_completion.sh

The add this to your `.bash_profile`:

    source ~/source/kubectl_completion.sh

## Minikube add-ons

