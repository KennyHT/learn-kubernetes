# Development Environment Setup

## Docker for Desktop

I recommend using Docker for Desktop for local development on macOS and Windows.

- [macOS](https://download.docker.com/mac/edge/Docker.dmg)
- [Windows 10](https://download.docker.com/win/edge/Docker%20for%20Windows%20Installer.exe)

!!! note

    Docker for Desktop also installs and configures `kubectl`, CLI that communicates with the Kubernetes cluster.

!!! warning

    Docker for Desktop on Windows uses Hyper-V which means it is incompatible with other Hypervisors. I recommend enabling Hyper-V just for the course, then evaluate how you will run a local cluster after. 

    If that's not possible, [Minikube](https://kubernetes.io/docs/setup/minikube/) is probably your best option.

Once Docker for Desktop is running, you need to enable Kubernetes by accessing the Preferences/Settings screen, select the **Kubernetes** tab, check the **Enable Kubernetes** checkbox, then click **Apply**.

<img alt="" src="/media/img/enable-kubernetes.png" width="480" />

### Linux or Linux VM users

I recommend using [Minikube](https://kubernetes.io/docs/setup/minikube/) or [this guide using kubeadm](https://medium.com/@lizrice/kubernetes-in-vagrant-with-kubeadm-21979ded6c63) by Liz Rice is recommended.

## Kubernetes Check

Execute the following commands to check `kubectl` can communicate with your cluster.

    kubectl cluster-info
    kubectl get nodes

## Lab 

Run `make setup` to pull down the required images for the labs.

    make setup

## System utilities

### kubectl

This should have been installed by Docker for Desktop or Minikube. See the [kubectl installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/) if it is not installed.

### kubeval

Validates your Kubernetes files. [Installation instructions on GitHub](https://github.com/garethr/kubeval#installation).

### kubetpl

Provides simple variable substitution for Kubernetes files. [Installation instructions on GitHub](https://github.com/shyiko/kubetpl#installation).

### make

Windows users can [download Make from Sourceforge](https://sourceforge.net/projects/gnuwin32/files/make/3.81/). Once installed, add the folder containing the Make.exe binary to your %PATH.

### watch

The `watch` binary allows you to observe the output from running a command every n seconds.

While kubernetes has a built-in `--watch` flag, I don't use it as it doesn't flush the previous output.

### jq

The `jq` binary allows us to nicely format, search and extract data from JSON on the command line. 

For a lot of Kubernetes commands, we'll be using the `--template` flag which uses Go template syntax but `jq` is in general, a very useful tool, even if all you use it for is to pretty print JSON.

## Bash completion for kubectl

The kubectl CLI is huge and the completion functionality will help save time.

### For macOS

Install `bash-completion` for homebrew by running:

    brew install bash-completion

Then add this to your ~/.bash_profile:

    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

Then install the completion for kubectl.

    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
