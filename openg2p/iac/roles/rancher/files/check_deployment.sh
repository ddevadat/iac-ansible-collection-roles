#!/bin/bash

checkk8s() {
while true; do
	echo "checking k8s nodes"
	status=$(kubectl get nodes --no-headers | awk '{print $2}')
	if [ "$status" = "Ready" ]; then
	break
	else
	sleep 5
	fi
done

}
check_unavailable() {
  sleep 30
  while true; do
    deployments=$(kubectl get deployments -n "${NAMESPACE}" -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.replicas}{'\t'}{.status.readyReplicas}{'\n'}{end}")
    while read -r line; do
      lines+=("$line")
    done <<<"$deployments"

    all_available=true
    for line in "${lines[@]}"; do
      read -ra arr <<<"$line"
      if [ "${arr[1]}" != "${arr[2]}" ]; then
        echo "${arr[0]} deployment has ${arr[2]} unavailable Replicas"
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

checkk8s
check_unavailable