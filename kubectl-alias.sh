#!/bin/bash

# enable/disable debug mode
# set -x

# colors
red='\033[0;31m'
yellow='\033[0;33m'
green='\033[0;32m'
NC='\033[0m' # No Color

alias k='kubectl'

# Changes default namespace current k8s context.
    # Usage e.g.:
    # $ change_ns kube-system
change_ns() {
    if [ -z "$1" ]; then
        echo "No namespace specified"
    else
        k config set-context --current --namespace=$1
        local context=$(kubectl config current-context)
        echo "[INFO]${green} $1 ${NC}${yellow}is set as default namespace in context ${context} ${NC}"
    fi
}

# Exec's into a pod. You can pass any number of arguments which kubectl supports, like namespace, container name
    # Usage e.g.:
    # 1. getin your-pod
    # 2. getin my-k8s-pod -n my-namespace -c my-container
getin() {
    k exec -it "$@" -- sh -c '(bash || sh)'
}

# Shows current default namespace and k8s context.
ctx_info() {
    local namespace=$(k config view --minify --output 'jsonpath={..namespace}')
    local context=$(kubectl config current-context)
    echo "${yellow}[INFO] Current Default Namespace: ${green}${namespace:-'No Namespace is set as default.'}${NC}${NC}"
    echo "${yellow}[INFO] Current Context: ${green}${context:-'No context found!'}${NC}${NC}"
}

# List, get or watch pod or get their yaml.
    # Usage e.g.:
    # 1. pods
    # 2. pods -w
    # 3. pods -l app=some-app -n my-namespace -oyaml
pods() {
    k get pod $@
}

# List, get or watch pod or get their yaml/json or any thing that kubectl supports.
    # Usage e.g.:
    # 1. deploy
    # 2. deploy -w
    # 3. deploy -l app=some-app -n my-namespace -oyaml
deploy() {
    k get deploy $@
}

# Describe a k8s resource.
des() {
    k describe $@
}

# Watch, stream logs of a pod/svc.
    # Usage e.g.:
    # 1. plogs pod-name
    # 2. plogs pod-name -f
    # 3. plogs -l app=some-app --since=5m -n my-namespace
    # 4. plogs svc/my-service
plogs() {
    k logs $@
}

# Resource usage of pods
    # Usage e.g.:
    # 1. res_usage -n my-namespace
    # 2. res_usage --sort-by='cpu'
res_usage() {
    k top pod ${@}
}

# List all containers(including initContainers) name & image of a pod.
    # Usage e.g.:
    # 1. pc my-pod
    # 2. pc my-pod -n my-namespace
pc() {
    kubecolor get pod $@ --output=json | jq '.spec | (.containers[] | "container: " + .name + "   " + .image),(.initContainers[]? | "init-container: " + .name + "   " + .image)'
}

# List all containers(including initContainers) name & image of a Deployment.
    # Usage e.g.:
    # 1. dc my-deployment
    # 2. dc my-deployment -n my-namespace
dc() {
    k get deploy $@ --output=json | jq '.spec.template.spec.containers[] | .name + " " + .image'
}
