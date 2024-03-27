#!/bin/bash
deployments=$(kubectl get deploy -n ${1} -o=jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.status.unavailableReplicas}{'\n'}{end}")
while read -r line; do lines+=("$line"); done <<<"$deployments"
for line in "${lines[@]}"
do
  read -ra arr <<< "$line"
  if [ "${arr[1]}" ]; then
    echo "${arr[0]} deployment has ${arr[1]} unavailable Replicas "
  fi
done