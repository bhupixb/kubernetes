#!/bin/bash

# Remove Finalizers from a resource
kubectl patch resource/resource-name --type json \
    --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]'
    

### BASH script way 
# Below script only works if there's only 1 finalizer
# It gets all deployments yaml based on some filters, remove the line having finalizer and next line.
for i in $(kubectl get deploy --no-headers| awk '$2!="1/1" {print $1}'); do
    echo $i
    kubectl get deploy -oyaml $i > test
    line=$(grep -n finalizers test | awk -F: '{print $1}')
    echo "Line: $line"
    if [[ -n "$line" ]]; then
        sed -i "" "${line}d" test
        sed -i "" "${line}d" test
        kubectl apply -f test
        # cat test
    fi
    break;
done
