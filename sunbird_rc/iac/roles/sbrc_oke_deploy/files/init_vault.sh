#!/bin/bash
kubectl -n vault exec vault-0 -- vault operator init \
-key-shares=1 \
-key-threshold=1 \
-format=json > /root/sunbird-rc/customization/vault/cluster-keys.json

vault_unseal_key=`cat /root/sunbird-rc/customization/vault/cluster-keys.json | jq -r ".unseal_keys_b64[]"`
vault_root_token=`cat /root/sunbird-rc/customization/vault/cluster-keys.json | jq -r ".root_token"`

kubectl -n vault exec vault-0 -- vault operator unseal $vault_unseal_key
kubectl -n vault exec vault-0 -- /bin/sh -c "vault login $vault_root_token && vault secrets enable -path=kv kv-v2"

echo "vault_unseal_key: $vault_unseal_key" > /root/sunbird-rc/customization/vault/vault_secrets.yaml
echo "vault_root_token: $vault_root_token" >> /root/sunbird-rc/customization/vault/vault_secrets.yaml
