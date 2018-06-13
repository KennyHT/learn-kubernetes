# Development Environment Setup

These instructions are currently for MacOS users with [homebrew](https://brew.sh/) installed. Linux users will be able to easily get the same results while Windows 10 users will have to use a Linux VM or the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Docker for Mac/Widows Edge Edition

At time of writing (April 2018), the Edge edition is still required for getting the Kubernetes integrated version of Docker for Desktop. More info at https://www.docker.com/kubernetes

## The `learn-docker` containers

These labs depends on images that are built using the `https://github.com/ryan-blunden/learn-docker` repository.

To build the required images:

    make build

## The watch command

The watch command allows you to observe the output from running a command every n seconds.

To install it with homebrew, use `brew install watch`.

## Bash completion for kubectl

The kubectl CLI is huge and the completion functionality will help save time and help you learn.

For this to work, you need `bash-completion` installed by homebrew by running:

    brew install bash-completion

Then add this to your ~/.bash_profile:

    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

Then install the completion for kubectl.

    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
