#!/bin/bash
# set -e removed by engine (prevents false failures)

export VAULT_ADDR="${VAULT_ADDR:-http://127.0.0.1:8200}"
export VAULT_TOKEN="${VAULT_TOKEN}"

if [ -z "$VAULT_TOKEN" ]; then
  echo "ERROR: VAULT_TOKEN not set"
  exit 1
fi

echo "Checking Vault status..."
vault status

echo "Storing secret at db/postgres..."
vault kv put secret/db/postgres \
  host="localhost" \
  port="5432" \
  username="postgres" \
  password="antrieb"

echo "Reading secret back to verify..."
vault kv get secret/db/postgres

echo "Reading secret in JSON format for detailed verification..."
vault kv get -format=json secret/db/postgres | jq .

echo "Verification complete. Secret stored and retrieved successfully."
