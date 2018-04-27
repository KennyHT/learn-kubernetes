# Development Environment Setup

## The watch command

The watch command allows you to observe the output from running a command every n seconds.

To install it with homebrew, use `brew install watch`.

### Bash complete

Completion instructions are for environments running bash. 

For this to work, you need `bash-completion` installed by homebrew by running `brew install bash-completion`.

Other shells are supported by Minikube and Kubectl but are not supported in this course.

*Note*: The instructions below presume the existence of a `source` directory at `$HOME`. Either create this or change the code below

### Minikube

    minikube completion bash > ~/source/minikube_completion.sh

The add this to your `.bash_profile`:

    source ~/source/minikube_completion.sh   

### Kubectl

    kubectl completion bash > ~/source/kubectl_completion.sh

The add this to your `.bash_profile`: 

## Docker CLI to Minikube Docker Daemon

We want to avoid having to setup a local registry for K8s to talk to so we make the Docker CLI point to Minikube.

This way, we can build locally and have Kubernetes use the new image instantly without a push to and pull from a registry.

Point Docker CLI at Minikube:

    Execute the code from `minikube docker-env`.

Verify it works:

    docker image ls

Build our API image:

    make api-build

Can we see the newly created image in minikube?

    docker image ls | grep training.io/api

## Minikube add-ons

Let's enable the `kube-dns` addon so we can lookup services internally by their service name.

    minikube addons enable kube-dns

*Note*: This is currently not working in Minikube 0.25.0 and Kubernetes 1.9
