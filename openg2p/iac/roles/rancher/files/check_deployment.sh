#!/bin/bash

check_unavailable() {
  while true; do
    deployments=$(kubectl get deploy -n "${NAMESPACE}" -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.unavailableReplicas}{'\n'}{end}")
    while read -r line; do
      lines+=("$line")
    done <<<"$deployments"

    all_available=true
    for line in "${lines[@]}"; do
      read -ra arr <<<"$line"
      if [ "${arr[1]}" ]; then
        echo "${arr[0]} deployment has ${arr[1]} unavailable Replicas"
        all_available=false
      fi
    done

    if $all_available; then
      echo "All deployments are available."
      break
    fi

    sleep 10  # Adjust the sleep duration as needed
  done
}

# Set your namespace
NAMESPACE=$1

check_unavailable